class Reader < ApplicationRecord
  SIX_DIGITS = /\A\d{6}\z/

  has_many :borrowings, dependent: :restrict_with_error

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :full_name, with: ->(full_name) { full_name.squish }

  validates :card_number, presence: true, format: { with: SIX_DIGITS, message: "must be a six-digit number" },
                          uniqueness: true
  validates :full_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
