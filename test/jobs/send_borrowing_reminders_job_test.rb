require "test_helper"

class SendBorrowingRemindersJobTest < ActiveJob::TestCase
  test "reminds before and on the due date, only once" do
    Borrowing.create!(book: books(:refactoring), reader: readers(:anna), borrowed_at: 28.days.ago)
    borrowings(:ddd_by_jan).update!(due_on: Date.current)

    perform_enqueued_jobs { 2.times { SendBorrowingRemindersJob.perform_now } }

    assert_equal [ "anna@example.com", "jan@example.com" ], ActionMailer::Base.deliveries.map(&:to).flatten.sort
  end
end
