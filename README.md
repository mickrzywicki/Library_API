# Library API

Simple Rails API for managing library books. Readers get email reminders 3 days before and on the due date.

## Running the app

```bash
docker compose up
```

App is available at http://localhost:3000. On first start the database is seeded with two readers
(card numbers 100001 and 100002) and three books (000001, 000002, 000003).
If you want different DB credentials, copy `.env.example` to `.env` and change them there.

Tests:

```bash
docker compose exec web bin/rails test
```

To send reminders right away (normally the job runs every day at 8:00):

```bash
docker compose exec web bin/rails runner SendBorrowingRemindersJob.perform_now
```

## Endpoints

| Request                              | Description                                    |
|--------------------------------------|------------------------------------------------|
| `GET /books`                         | list of books with status (available/borrowed) |
| `GET /books/:serial_number`          | book details with borrowing history            |
| `POST /books`                        | add a book                                     |
| `DELETE /books/:serial_number`       | delete a book (not possible while borrowed)    |
| `PATCH /books/:serial_number/status` | borrow or return a book                        |

Examples:

```bash
curl -X POST localhost:3000/books -H 'Content-Type: application/json' \
  -d '{"book": {"serial_number": "123456", "title": "Refactoring", "author": "Martin Fowler"}}'
curl -X PATCH localhost:3000/books/123456/status -H 'Content-Type: application/json' \
  -d '{"status": "borrowed", "card_number": "100001"}'
curl -X PATCH localhost:3000/books/123456/status -H 'Content-Type: application/json' \
  -d '{"status": "available"}'
curl localhost:3000/books
curl localhost:3000/books/123456
curl -X DELETE localhost:3000/books/123456
```

## Reminders

Books are borrowed for 30 days. `SendBorrowingRemindersJob` runs daily with Solid Queue and sends
a reminder 3 days before the due date and on the due date. Emails are not really sent, you can see
them in the `docker compose up` logs.

## Design decisions

- I implemented only what the task asked for, so there are no endpoints for readers. They are created in seeds.
- Book status isn't stored in a column. A book is borrowed when it has a borrowing without `returned_at`,
  so status and history can't get out of sync.
- Main rules are also in the database: unique serial numbers, card numbers and emails,
  six-digit format checks, and a partial unique index that allows only one active borrowing per book
  (this also covers two requests coming at the same time).
- Serial and card numbers are strings, so leading zeros like `000123` stay.
- Borrowing and returning are handled in the controller. Each one is a single DB write, so I didn't
  see a reason for service objects yet.
- I used Solid Queue on the same Postgres database and run it inside Puma, so there's no Redis
  or separate worker container.
- Each borrowing saves when a reminder was sent, so running the job twice won't send the same email again.

## Limitations

- No authentication/authorization (not required in the task).
- If the job doesn't run on the due date, the "due today" reminder won't be sent.
- Two return requests for the same book at the same time will both pass, and the second one
  overwrites the return date.
- Deleting a book removes its borrowing history too.
- Docker setup runs in development mode. It's meant for local review, not production.

## Ideas for improvement

- Endpoints for readers, pagination for the books list.
- Reminders for overdue books.
- Moving borrow/return to a service with row locking when more rules come (loan limits, fees etc.).
- Soft delete for books, so the history stays.
- Production Dockerfile, separate `bin/jobs` process and real email delivery.
- `rack-cors` if a frontend on another domain needs to call the API.
