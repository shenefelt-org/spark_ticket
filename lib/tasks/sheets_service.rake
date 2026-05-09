unless defined?(Fixnum)
  Fixnum = Integer
end
unless defined?(Bignum)
  Bignum = Integer
end

require "tty"
require "tty-prompt"
require "tty-progressbar"
require "pastel"

namespace :sheets_service do
  desc "Upload logs to Google Sheets"
  task upload_puma_logs: :environment do
    prompt = TTY::Prompt.new
    pastel = Pastel.new

    style = {
      total: AppLog.count,
      width: AppLog.count,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :lnum [:bar] :percent | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)

    processable = AppLog.where(uploaded: false)

    if processable.empty?
      prompt.say("No logs to upload")
      bar.advance(100, process: "No logs to upload", lnum: "nil")
      next # Using `next` instead of `exit` so it safely exits the task without killing the entire Rake process
    end

    AppLog.find_each do |log|
      if log.uploaded
        bar.advance(1, process: "skipped upload", lnum: "#{log.id} already uploaded".ljust(10))
        sleep(0.1)
        next
      end

      bar.advance(1, process: "uploading".ljust(10), lnum: log.id.to_s.ljust(20))
      GoogleSheetsService.update_puma_log(datum: log, source: "rake_task/upload_puma_logs")
      log.update(uploaded: true)
      sleep(0.5)
    end

    fin = pastel.bold.bright_green("Mission Complete!")
    prompt.say(fin)
  end

  desc "Upload tickets to Google Sheets"
  task upload_tickets: :environment do
    prompt = TTY::Prompt.new
    pastel = Pastel.new

    style = {
      total: Ticket.count,
      width: Ticket.count,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :tnum [:bar] :percent | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)

    processable = Ticket.where(uploaded: false)

    if processable.empty?
      prompt.say("No tickets to upload")
      bar.advance(100, process: "No tickets to upload", tnum: "nil")
      next
    end

    Ticket.find_each do |ticket|
      if ticket.uploaded
        bar.advance(1, process: "skipped upload", tnum: "#{ticket.id} already uploaded".ljust(10))
        sleep(0.1)
        next
      end

      bar.advance(1, process: "uploading".ljust(10), tnum: ticket.id.to_s.ljust(20))
      GoogleSheetsService.update_sheet(datum: ticket, source: "rake_task/upload_tickets")
      ticket.update(uploaded: true)
      sleep(0.5)
    end

    fin = pastel.bold.bright_green("Mission Complete!")
    prompt.say(fin)
  end
end
