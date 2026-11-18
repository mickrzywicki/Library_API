class Reader < ApplicationRecord
  SIX_DIGITS = /\A\d{6}\z/

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :full_name, with: ->(name) { name.squish }

  validates :card_number, presence: true, format: { with: SIX_DIGITS, message: "must be a six-digit number" },
                          uniqueness: true
  validates :full_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
