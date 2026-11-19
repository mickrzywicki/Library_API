return if Reader.exists?

anna = Reader.create!(card_number: "100001", full_name: "Anna Kowalska", email: "anna@example.com")
jan = Reader.create!(card_number: "100002", full_name: "Jan Nowak", email: "jan@example.com")

Book.create!(serial_number: "000001", title: "Refactoring", author: "Martin Fowler")
  .borrowings.create!(reader: anna, borrowed_at: 27.days.ago)
Book.create!(serial_number: "000002", title: "Domain-Driven Design", author: "Eric Evans")
  .borrowings.create!(reader: jan, borrowed_at: 30.days.ago)
Book.create!(serial_number: "000003", title: "Clean Code", author: "Robert C. Martin")
