class SendBorrowingRemindersJob < ApplicationJob
  def perform(today = Date.current)
    due_soon_range = (today + 1)..(today + Borrowing::DUE_SOON_REMINDER_DAYS)

    Borrowing.active.where(due_on: due_soon_range, due_soon_reminder_sent_at: nil).find_each do |borrowing|
      BorrowingReminderMailer.with(borrowing:).due_soon.deliver_later
      borrowing.update!(due_soon_reminder_sent_at: Time.current)
    end

    Borrowing.active.where(due_on: today, due_today_reminder_sent_at: nil).find_each do |borrowing|
      BorrowingReminderMailer.with(borrowing:).due_today.deliver_later
      borrowing.update!(due_today_reminder_sent_at: Time.current)
    end
  end
end
