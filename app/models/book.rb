class Book < ApplicationRecord
  SIX_DIGITS = /\A\d{6}\z/

  normalizes :title, :author, with: ->(value) { value.squish }

  validates :serial_number, presence: true, format: { with: SIX_DIGITS, message: "must be a six-digit number" },
                            uniqueness: true
  validates :title, :author, presence: true
end
