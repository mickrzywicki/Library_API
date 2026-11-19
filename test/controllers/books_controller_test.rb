require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "creates a book" do
    post books_url, params: { book: { serial_number: "123456", title: "T", author: "A" } }, as: :json

    assert_response :created
  end

  test "deletes only an available book" do
    delete book_url("000001")
    assert_response :no_content

    delete book_url("000002")
    assert_response :conflict
  end

  test "lists books with their status" do
    get books_url

    assert_equal %w[available borrowed], response.parsed_body["books"].pluck("status")
  end

  test "shows a book with its borrowing history" do
    get book_url("000002")

    assert_equal "100002", response.parsed_body.dig("book", "borrowings", 0, "reader", "card_number")
  end
end
