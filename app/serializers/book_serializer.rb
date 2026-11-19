class BookSerializer
  def initialize(book, with_history: false)
    @book = book
    @with_history = with_history
  end

  def as_json(*)
    json = {
      serial_number: @book.serial_number,
      title: @book.title,
      author: @book.author,
      status: @book.status
    }
    json[:borrowings] = @book.borrowings.map { BorrowingSerializer.new(it).as_json } if @with_history
    json
  end
end
