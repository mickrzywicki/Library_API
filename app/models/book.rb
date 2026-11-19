class Book < ApplicationRecord
  SIX_DIGITS = /\A\d{6}\z/

  has_many :borrowings, -> { order(borrowed_at: :desc, id: :desc) }, dependent: :delete_all, inverse_of: :book
  has_one :current_borrowing, -> { active }, class_name: "Borrowing", inverse_of: :book

  normalizes :title, :author, with: ->(value) { value.squish }

  validates :serial_number, presence: true, format: { with: SIX_DIGITS, message: "must be a six-digit number" },
                            uniqueness: true
  validates :title, :author, presence: true

  def borrowed? = current_borrowing.present?

  def status = borrowed? ? "borrowed" : "available"
end
