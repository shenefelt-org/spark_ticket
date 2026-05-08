unless defined?(Fixnum)
  Fixnum = Integer
end

unless defined?(Bignum)
  Bignum = Integer
end

require "tty-table"

module TicketsHelper
  def print_ticket_table
    table = TTY::Table.new(header: ["id", "subject", "body"])

    Ticket.all.each do |row|
      table << [row[:id], row[:subject], row[:body]]
    end

    # Render the table
    puts table.render(:unicode)
  end
end

