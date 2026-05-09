class TicketResponse < ApplicationRecord
  belongs_to :ticket
  belongs_to :tech
end
