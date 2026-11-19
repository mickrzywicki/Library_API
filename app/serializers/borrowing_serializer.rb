class BorrowingSerializer
  def initialize(borrowing)
    @borrowing = borrowing
  end

  def as_json(*)
    {
      borrowed_at: @borrowing.borrowed_at.iso8601,
      returned_at: @borrowing.returned_at&.iso8601,
      reader: ReaderSerializer.new(@borrowing.reader).as_json
    }
  end
end
