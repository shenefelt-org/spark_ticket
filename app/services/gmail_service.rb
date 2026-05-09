# app/services/gmail_service.rb
unless defined?(Fixnum)
  Fixnum = Integer
end
unless defined?(Bignum)
  Bignum = Integer
end
require "google/apis/gmail_v1"
require "googleauth"
require "tty-table"
require "tty-progressbar"

class GmailService
  SCOPE = [ "https://mail.google.com/" ].freeze

  def initialize(user_to_impersonate)
    @service = Google::Apis::GmailV1::GmailService.new
    @service.authorization = authorize!(user_to_impersonate)
  end

  def list_messages
    @service.list_user_messages("me")
  end

  def list_subjects(limit: 10)
    response = @service.list_user_messages("me", max_results: limit)

    unless response.messages
      puts "No messages found."
      return []
    end

    total_messages = response.messages.length

    # Initialize the TTY Progress Bar
    bar = TTY::ProgressBar.new("Fetching emails [:bar] :percent :eta", total: total_messages)

    table_rows = []

    response.messages.each do |message_ref|
      full_message = @service.get_user_message("me", message_ref.id)

      subject_header = full_message.payload.headers.find { |h| h.name.downcase == "subject" }
      subject = subject_header ? subject_header.value : "(No Subject)"

      from_header = full_message.payload.headers.find { |h| h.name.downcase == "from" }
      from = from_header ? from_header.value : "Unknown"

      table_rows << [ from[0..35], subject[0..60] ]

      # Advance the TTY progress bar
      bar.advance
    end

    table = TTY::Table.new(header: [ "Sender", "Subject" ], rows: table_rows)

    puts "\n"
    puts table.render(:unicode, padding: [ 0, 1, 0, 1 ])

    table_rows
  end

  private

  def authorize!(user)
    key_path = Rails.root.join(ENV.fetch("SERVICE_ACCOUNT_KEY"))
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(key_path), scope: SCOPE
    )
    authorizer.sub = user
    authorizer.fetch_access_token!

    puts "user #{user} authorized successfully."
    authorizer
  end
end
