class Borrowing < ApplicationRecord
  LOAN_PERIOD = 30.days
  DUE_SOON_REMINDER_DAYS = 3

  belongs_to :book, inverse_of: :borrowings
  belongs_to :reader

  scope :active, -> { where(returned_at: nil) }

  before_validation :set_due_on, on: :create

  validates :borrowed_at, :due_on, presence: true
  validate :returned_at_not_before_borrowed_at

  private

  def set_due_on
    self.due_on ||= (borrowed_at.in_time_zone + LOAN_PERIOD).to_date if borrowed_at
  end

  def returned_at_not_before_borrowed_at
    return if returned_at.nil? || borrowed_at.nil? || returned_at >= borrowed_at

    errors.add(:returned_at, "can't be earlier than borrowed_at")
  end
end
