require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "requires a unique six-digit serial number" do
    assert Book.new(serial_number: "012345", title: "T", author: "A").valid?
    assert_not Book.new(serial_number: "12345", title: "T", author: "A").valid?
    assert_not Book.new(serial_number: books(:refactoring).serial_number, title: "T", author: "A").valid?
  end

  test "status is derived from the active borrowing" do
    assert_equal "available", books(:refactoring).status
    assert_equal "borrowed", books(:ddd).status
  end
end
