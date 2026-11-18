require "test_helper"

class ReaderTest < ActiveSupport::TestCase
  test "requires a six-digit card number and a unique, case-insensitive email" do
    reader = Reader.new(card_number: "12345", full_name: "X", email: " ANNA@example.com ")

    assert_not reader.valid?
    assert_equal "anna@example.com", reader.email
    assert reader.errors.of_kind?(:card_number, :invalid)
    assert reader.errors.of_kind?(:email, :taken)
  end
end
