class BooksController < ApplicationController
  def index
    books = Book.includes(:current_borrowing).order(:serial_number)

    render json: { books: books.map { BookSerializer.new(it).as_json } }
  end

  def show
    book = Book.includes(:current_borrowing, borrowings: :reader).find_by!(serial_number: params[:serial_number])

    render json: { book: BookSerializer.new(book, with_history: true).as_json }
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: { book: BookSerializer.new(book).as_json }, status: :created
    else
      render_validation_errors book
    end
  end

  def destroy
    book = Book.find_by!(serial_number: params[:serial_number])
    return render_error(:conflict, "Cannot delete a book that is currently borrowed") if book.borrowed?

    book.destroy!
    head :no_content
  end

  private

  def book_params
    params.expect(book: %i[serial_number title author])
  end
end
