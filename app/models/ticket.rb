class Ticket < ApplicationRecord
  has_many :ticket_assignments, dependent: :destroy
  has_many :teches, through: :ticket_assignments
end
