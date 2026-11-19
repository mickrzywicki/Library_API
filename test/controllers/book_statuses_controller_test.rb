require "test_helper"

class BookStatusesControllerTest < ActionDispatch::IntegrationTest
  test "borrows an available book" do
    patch book_status_url("000001"), params: { status: "borrowed", card_number: "100001" }, as: :json

    assert_equal "borrowed", response.parsed_body.dig("book", "status")
  end

  test "does not borrow an already borrowed book" do
    patch book_status_url("000002"), params: { status: "borrowed", card_number: "100001" }, as: :json

    assert_response :conflict
  end

  test "returns a borrowed book" do
    patch book_status_url("000002"), params: { status: "available" }, as: :json

    assert_equal "available", response.parsed_body.dig("book", "status")
  end
end
