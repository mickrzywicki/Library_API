class BorrowingReminderMailer < ApplicationMailer
  before_action { @borrowing = params[:borrowing] }

  def due_soon
    mail to: @borrowing.reader.email, subject: "Reminder: \"#{@borrowing.book.title}\" is due on #{@borrowing.due_on}"
  end

  def due_today
    mail to: @borrowing.reader.email, subject: "\"#{@borrowing.book.title}\" is due today"
  end
end
