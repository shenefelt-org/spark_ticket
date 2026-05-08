require "test_helper"

class AppLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_log = app_logs(:one)
  end

  test "should get index" do
    get app_logs_url, as: :json
    assert_response :success
  end

  test "should create app_log" do
    assert_difference("AppLog.count") do
      post app_logs_url, params: { app_log: { agent: @app_log.agent, ip_address: @app_log.ip_address, level: @app_log.level, method: @app_log.method, path: @app_log.path } }, as: :json
    end

    assert_response :created
  end

  test "should show app_log" do
    get app_log_url(@app_log), as: :json
    assert_response :success
  end

  test "should update app_log" do
    patch app_log_url(@app_log), params: { app_log: { agent: @app_log.agent, ip_address: @app_log.ip_address, level: @app_log.level, method: @app_log.method, path: @app_log.path } }, as: :json
    assert_response :success
  end

  test "should destroy app_log" do
    assert_difference("AppLog.count", -1) do
      delete app_log_url(@app_log), as: :json
    end

    assert_response :no_content
  end
end
