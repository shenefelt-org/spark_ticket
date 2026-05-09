unless defined?(Fixnum)
  Fixnum = Integer
end
unless defined?(Bignum)
  Bignum = Integer
end

require 'tty'
require 'tty-prompt'
require 'tty-progressbar'
require 'pastel'

namespace :tickets do
  desc "Exporting to sheet.."

  task export: :environment do
    tickets = Ticket.count
    prompt = TTY::Prompt.new 
    pastel = Pastel.new
    style = {
      total: tickets,
      width: 100,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :tnum [:bar] | PERCENT: :pct | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)
    processable = Ticket.all.map {|e| e.uploaded = false } 

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

end
