require "test_helper"

class BorrowingTest < ActiveSupport::TestCase
  test "is due 30 days after borrowing" do
    borrowing = Borrowing.create!(book: books(:refactoring), reader: readers(:anna),
                                  borrowed_at: Time.zone.local(2026, 1, 10, 12))

    assert_equal Date.new(2026, 2, 9), borrowing.due_on
  end

  test "a book can have only one active borrowing" do
    assert_raises(ActiveRecord::RecordNotUnique) do
      Borrowing.create!(book: books(:ddd), reader: readers(:anna), borrowed_at: Time.current)
    end
  end
end
