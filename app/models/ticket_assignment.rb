class TicketAssignment < ApplicationRecord
  belongs_to :ticket
  belongs_to :tech
end
