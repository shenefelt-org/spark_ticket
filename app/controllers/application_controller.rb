class ApplicationController < ActionController::API
  before_action :block_malicious_ips

  private

  # Childish IP blocking for dev env
  def block_malicious_ips
    allowed_ips = [ "172.56.152.126", "94.156.149.165", "localhost", "127.0.0.1" ]
    # log all incoming requests with a warn as these are bad ips
    @log = AppLog.create!(
      level: "WARN",
      method: request.method,
      path: request.path,
      agent: request.user_agent,
      ip_address: request.remote_ip,
    )

    if !allowed_ips.include?(request.remote_ip)
      @log.update(message: "Blocked IP #{request.remote_ip}")
      render json: { error: "Blocked IP", message: "Your IP has been blocked. 💋", naughty_ip: request.remote_ip, defeated: true }, status: :forbidden
    end

    # block requests that contain 'php' in the path to prevent malicious attempts to access PHP files
    if request.path.downcase.include?("php")
      @log.update(message: "Blocked PHP Access Attempt")
      render json: { error: "Nice try!", message: "PHP files are not allowed here 💋" }, status: :forbidden
    end

    if request.path.downcase.include?("admin")
      @log.update(message: "Blocked Admin Access Attempt")
      render json: { error: "Nice try!", message: "Gotta try harder silly 💋" }, status: :forbidden
    end
  end
end
