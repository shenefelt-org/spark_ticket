require "google_drive"
require "dotenv"
Dotenv.load
class GoogleSheetsService
  @spreadsheet_id = ENV["SPARK_SHEET_ID"]
  @session = GoogleDrive::Session.from_service_account_key(ENV["SERVICE_ACCOUNT_KEY"])
  @sheet = @session.spreadsheet_by_key(@spreadsheet_id)

  def self.update_sheet(datum: nil, source: "PUSH")
    return nil if datum.nil?

    session = GoogleDrive::Session.from_service_account_key("config/google_credentials.json")
    sheet = session.spreadsheet_by_key(@spreadsheet_id)
    worksheet = sheet.worksheets.first
    app_log = sheet.worksheets.second

    worksheet.insert_rows(
      worksheet.num_rows + 1,
      [
        [
          datum.id, datum.subject, datum.body, datum.status, datum.priority, datum.teches.map(&:employee_id).join(", ")
        ]
      ]
    )

    worksheet.save
    sleep(0.1)
    update_applog_sheet(datum: {}, source: source)
  end

  def self.update_applog_sheet(datum: nil, source: "unknown")
    return nil if datum.nil?
    worksheet = @sheet.worksheets.second
    return nil if worksheet.nil?

    worksheet.insert_rows(
      worksheet.num_rows + 1,
      [
        [
          "INFO", "#{source}", "/sheets_service", "SUCCESS"
        ]
      ]
    )

    worksheet.save
    sleep(0.1)
  end

  def self.update_puma_log(datum: nil, source: "unknown")
    return nil if datum.nil?
    worksheet = @sheet.worksheets[3]
    return nil if worksheet.nil?

    worksheet.insert_rows(
      worksheet.num_rows + 1,
      [
        [
          datum.level, "puma/#{datum.method.downcase}", datum.path, datum.agent, datum.ip_address, Time.now.strftime("%Y-%m-%d %H:%M:%S"), "#{source}"
        ]
      ]
    )

    worksheet.save
    sleep(0.1)
  end
end
