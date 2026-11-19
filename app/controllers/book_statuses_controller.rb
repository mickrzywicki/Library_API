class BookStatusesController < ApplicationController
  def update
    book = Book.find_by!(serial_number: params[:book_serial_number])

    case params.require(:status)
    when "borrowed" then borrow(book)
    when "available" then give_back(book)
    else render_error :unprocessable_content, "Status must be borrowed or available"
    end
  end

  private

  def borrow(book)
    reader = Reader.find_by!(card_number: params.require(:card_number))
    book.borrowings.create!(reader:, borrowed_at: Time.current)
    render_book book
  rescue ActiveRecord::RecordNotUnique
    render_error :conflict, "Book is already borrowed"
  end

  def give_back(book)
    return render_error(:conflict, "Book is not borrowed") unless book.borrowed?

    book.current_borrowing.update!(returned_at: Time.current)
    render_book book
  end

  def render_book(book)
    render json: { book: BookSerializer.new(book.reload).as_json }
  end
end
