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

namespace :app_log do
  desc "manage tasks related to app logs"

  task set_uploaded_false: :environment do
   prompt = TTY::Prompt.new
   pastel = Pastel.new
   logs = AppLog.where(uploaded: true).length

   style = {
      total: logs,
      width: logs,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :lnum [:bar] :percent | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)
    processable = AppLog.where(uploaded: true)

    if processable.length == 0
      prompt.say("No logs to update")
      bar.advance(100, process: "No logs to update", lnum: "nil")
      exit
    end

    AppLog.find_each do |log|
      bar.advance(1, process: "marking".ljust(10), lnum: "#{log.id}".ljust(20))
      log.update(uploaded: false)
      sleep(0.1)
    end
    fin = "#{pastel.bold.bright_green('Mission Complete!')}"
    prompt.say(fin)
  end

  task set_uploaded_true: :environment do
   prompt = TTY::Prompt.new
   pastel = Pastel.new
   logs = AppLog.where(uploaded: false).length

   style = {
      total: logs,
      width: logs,
      complete: "=",
      incomplete: "-",
      clear: false
    }
    format = ":process :lnum [:bar] :percent | ETA: :eta"
    bar = TTY::ProgressBar.new(format, style)
    processable = AppLog.where(uploaded: false)

    if processable.length == 0
      prompt.say("No logs to update")
      bar.advance(100, process: "No logs to update", lnum: "nil")
      exit
    end

    AppLog.find_each do |log|
      bar.advance(1, process: "marking".ljust(10), lnum: "#{log.id}".ljust(20))
      log.update(uploaded: true)
      sleep(0.1)
    end
    fin = "#{pastel.bold.bright_green('Mission Complete!')}"
    prompt.say(fin)
  end
end
