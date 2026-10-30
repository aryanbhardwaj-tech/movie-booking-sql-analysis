# Movie Booking SQL Project

This is a MySQL database I built for a movie ticket booking system, something like BookMyShow. I made it to practice SQL on a bigger dataset and to answer business-type questions like which movies earn the most and how many bookings get cancelled.

## What's inside

There are 4 tables:

| Table | Rows | What it stores |
|-------|------|----------------|
| customers | 20,000 | name, gender, city, signup date |
| movies | 500 | name, genre, language, duration |
| theatres | 200 | name, city, total seats |
| bookings | 20,000 | show date, seats, amount, status, payment method |

The `bookings` table connects to the other three using customer_id, movie_id and theatre_id.

Booking status can be Confirmed, Cancelled or Pending. Payment methods are UPI, Credit Card, Debit Card, Net Banking, Wallet and Cash.

All the data is randomly generated, so it's not real. Some things (like a male-sounding name marked Female) won't match up for that reason.

## How to run it

You need MySQL installed. Then:

```bash
git clone https://github.com/aryanbhardwaj-tech/movie-booking-sql-analysis.git
cd movie-booking-sql-analysis
mysql -u root -p < movie_booking_db.sql
```

Or just open `sql/movie_booking_db.sql` in MySQL Workbench and run it. It creates the database `movie_booking_db`, the tables, and inserts all the data.

## Some queries I tried

Total revenue from confirmed bookings:
```sql
SELECT SUM(ticket_amount) AS total_revenue
FROM bookings
WHERE booking_status = 'Confirmed';
```

Top 10 movies by revenue:
```sql
SELECT m.movie_name, SUM(b.ticket_amount) AS revenue
FROM bookings b
JOIN movies m ON b.movie_id = m.movie_id
WHERE b.booking_status = 'Confirmed'
GROUP BY m.movie_name
ORDER BY revenue DESC
LIMIT 10;
```

What percent of bookings got cancelled:
```sql
SELECT ROUND(100 * SUM(booking_status = 'Cancelled') / COUNT(*), 2) AS cancel_percent
FROM bookings;
```

Revenue by city:
```sql
SELECT t.city, SUM(b.ticket_amount) AS revenue
FROM bookings b
JOIN theatres t ON b.theatre_id = t.theatre_id
WHERE b.booking_status = 'Confirmed'
GROUP BY t.city
ORDER BY revenue DESC;
```

Which payment method is used the most:
```sql
SELECT payment_method, COUNT(*) AS total_bookings
FROM bookings
GROUP BY payment_method
ORDER BY total_bookings DESC;
```

Bookings per month:
```sql
SELECT DATE_FORMAT(show_date, '%Y-%m') AS month, COUNT(*) AS total_bookings
FROM bookings
GROUP BY month
ORDER BY month;
```

Top 10 customers by money spent:
```sql
SELECT c.customer_name,
       SUM(b.ticket_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(b.ticket_amount) DESC) AS spend_rank
FROM bookings b
JOIN customers c ON b.customer_id = c.customer_id
WHERE b.booking_status = 'Confirmed'
GROUP BY c.customer_id, c.customer_name
ORDER BY spend_rank
LIMIT 10;
```

## What I practiced

JOINs, GROUP BY, aggregate functions, subqueries, and window functions like RANK().

## Author

Aryan Bhardwaj - [GitHub](https://github.com/aryanbhardwaj-tech)

## License

MIT
