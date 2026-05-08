unless defined?(Fixnum)
  Fixnum = Integer
end

unless defined?(Bignum)
  Bignum = Integer
end

require "tty-table"
require 'pastel'

module AppLogsHelper
  def print_log_table
    pastel = Pastel.new
    table = TTY::Table.new(header: ["#{pastel.bold.red('level')}", "#{pastel.bold.magenta('method')}", "path", "ip_address"])

    AppLog.all.each do |row|
      table << ["#{pastel.bold.bright_magenta(row[:level])}", row[:method], row[:path], row[:ip_address]]
    end

    # Render the table
    puts table.render(:unicode)
  end
end

