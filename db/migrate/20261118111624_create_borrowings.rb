class CreateBorrowings < ActiveRecord::Migration[8.1]
  def change
    create_table :borrowings do |t|
      t.references :book, null: false, foreign_key: { on_delete: :cascade }
      t.references :reader, null: false, foreign_key: true
      t.datetime :borrowed_at, null: false
      t.date :due_on, null: false
      t.datetime :returned_at

      t.timestamps
    end

    # A book can have at most one open (not returned) borrowing at a time.
    # This guards against race conditions that application-level validation alone cannot.
    add_index :borrowings, :book_id, unique: true, where: "returned_at IS NULL",
                                     name: "index_borrowings_on_book_id_active"
    add_check_constraint :borrowings, "returned_at IS NULL OR returned_at >= borrowed_at",
                         name: "borrowings_returned_after_borrowed"
  end
end
