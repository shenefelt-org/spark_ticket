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

namespace :tickets do
  desc "Exporting to sheet.."

  task export: :environment do
    tickets = Ticket.count
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    style = {
      total: tickets,
      width: tickets,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :tnum [:bar] :percent | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)
    processable = Ticket.all.map { |e| e.uploaded = false }

    if processable.length == 0
      prompt.say("No records to process")
      bar.advance(100, process: "No records to process", tnum: "nil")
      exit
    end
    Ticket.find_each do |ticket|
      if ticket.uploaded
        bar.advance(1, process: "skipped upload", tnum: "#{ticket.id} already uploaded".ljust(10))
        sleep(0.1)
        next
      end
      bar.advance(1, process: "uploading".ljust(10), tnum: "#{ticket.id}".ljust(20))
      GoogleSheetsService.update_sheet(datum: ticket, source: "rake task")
      ticket.update(uploaded: true)
      sleep(0.1)
    end
    fin = "#{pastel.bold.bright_green('Mission Complete!')}"
    prompt.say(fin)
  end

  task seek_response: :environment do
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
    Ticket.find_each do |ticket|
      if ticket.status == "open"
        bar.advance(1, process: "#{pastel.bold.yellow('Seeking response')}".ljust(20), tnum: "#{ticket.id}".ljust(10))

        sleep(0.1)
      else
        bar.advance(1, process: "#{pastel.bold.red('skipped')}".ljust(10), tnum: "#{ticket.id} status is #{ticket.status}".ljust(10))
        sleep(0.1)
      end
    end
    fin = "#{pastel.bold.bright_green('Mission Complete!')}"
    prompt.say(fin)
  end

  task update_ticket: :environment do
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    ticket_id = prompt.ask("Enter the ticket ID you want to update?", convert: :int)
    field = prompt.select("Which field do you want to update?", %w[subject body status priority])
    value = prompt.ask("Enter the new value for #{field}:")

    if TicketsHelper.update_ticket(ticket_id: ticket_id, param: { field => value })
      prompt.say("#{pastel.bold.green('Success!')} Ticket ##{ticket_id} updated.")
    else
      prompt.say("#{pastel.bold.red('Error:')} Failed to update Ticket ##{ticket_id}. Please check the ID and try again.")
    end
  end
end
