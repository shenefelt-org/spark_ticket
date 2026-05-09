class Tech < ApplicationRecord
  has_many :ticket_assignments, dependent: :destroy
  has_many :tickets, through: :ticket_assignments
end
