USE movie_booking_db;

-- 1. Total Bookings
select count(*) as total_bookings
from bookings;

-- 2. Total Tickets Sold
select sum(seats_booked) as total_tickets_sold
from bookings
where booking_status = "confirmed";

select * from bookings limit 10;

-- 3. Total Revenue
select sum(ticket_amount) as total_rev
from bookings
where booking_status = "confirmed";

-- 4. Average Ticket Price
select round (sum(ticket_amount) / sum(seats_booked),2) as avg_ticket_price
from bookings
where booking_status = "confirmed";

-- 5. Average Booking Value
select round (avg (ticket_amount),2) as avg_booking_value
from bookings
where booking_status = "confirmed";

-- 6. Booking Cancellation Rate
select round(count(case when booking_status = 'cancelled' then 1 end) * 100 / count(*), 2) as cancellation_rate_pct
from bookings;

-- 7. Occupancy Rate
select sum(b.seats_booked) * 100 / sum(t.total_seats) as occupancy_rate_pct
from bookings b
join theatres t on t.theatre_id = b.theatre_id
where b.booking_status = "confirmed";

-- 8. Revenue by Movie
select m.movie_name ,sum(b.ticket_amount) as revenue
from bookings b
join movies m on m.movie_id = b.movie_id
where b.booking_status = "confirmed"
group by m.movie_name
order by revenue desc;

-- 10. Revenue by City
select t.city ,sum(b.ticket_amount) as revenue
from bookings b
join theatres t on b.theatre_id = t.theatre_id
where b.booking_status = "confirmed"
group by t.city
order by revenue desc;

-- 11. Most Popular Movie
select m.movie_name, count(*) as total_bookings
from bookings b
join movies m on m.movie_id = b.movie_id
where b.booking_status = "confirmed"
group by m.movie_name
order by total_bookings desc
limit 1;

-- 12. Most Popular Genre
select m.genre, count(*) as total_bookings
from bookings b
join movies m on m.movie_id = b.movie_id
group by m.genre
order by total_bookings
limit 1;

-- 13. Peak Booking Hours
select time(show_date) as bookings_hour, count(*) as total_bookings
from bookings
group by time(show_date)
order by total_bookings desc
limit 10;

-- 14. Peak Show Timings
select time(show_date) as show_time, count(*) as total_bookings
from bookings
group by time(show_date)
order by total_bookings desc
limit 10;


-- 15. Weekend vs Weekday Bookings
select case when dayofweek(show_date) in (1,7) then 'weekend' else 'weekday' end as day_type,
count(*) as total_bookings
from bookings
group by day_type;

-- 16. Payment Method Distribution
select payment_method, count(*) as total_bookings
from bookings
group by payment_method
order by total_bookings desc;

-- 17. Customer Retention Rate
select count(distinct case when bookings_count > 1 then customer_id end) *100 / count(distinct customer_id) as retention_rate_pct from (
select customer_id,count(*) as bookings_count
from bookings
group by customer_id) t;

-- 18. Repeat Customers
select count(*) as repeat_customers
from (
select customer_id
from bookings
group by customer_id
having count(*) > 1) t;

-- 19. Top Spending Customers
select c.customer_name, sum(b.ticket_amount) as total_spent
from bookings b
join customers c on b.customer_id = c.customer_id
where b.booking_status = "confirmed"
group by c.customer_name
order by total_spent desc
limit 10;

-- 20. Theatre Utilization
select t.theatre_name, sum(b.seats_booked) * 100 / t.total_seats as utilization_rate_pct
from bookings b
join theatres t on t.theatre_id = b.theatre_id
where b.booking_status = 'confirmed'
group by t.theatre_name , t.total_seats
order by utilization_rate_pct desc;

-- 21. Language-wise Revenue
select m.language, sum(b.ticket_amount) as total_rev
from bookings b
join movies m on m.movie_id = b.movie_id
where b.booking_Status = "confirmed"
group by m.language
order by total_rev desc;

-- 22. Monthly Revenue Trend
select date_format(show_Date,'%y-%m') as month,sum(ticket_Amount) as rev
from bookings
where booking_status = 'confirmed'
group by month
order by month;


-- 23. Movie Performance Dashboard
select m.movie_name,
count(b.booking_id) as total_bookings,
sum(b.ticket_amount) as total_revenue,
sum(b.seats_booked) as total_ticket,
avg(b.ticket_amount) as avg_ticket_value
from bookings b
join movies m on m.movie_id = b.movie_id
where b.booking_status = 'confirmed'
group by m.movie_name
order by total_revenue desc;


-- 24. Executive Booking Dashboard
select 
count(*) as total_bookings,
sum(case when booking_status = 'confirmed' then ticket_amount else 0 end )as total_revenue,
sum(case when booking_status = 'confirmed' then 1 else 0 end)*100/count(*) as cancellation_rate_pct,
sum(case when booking_status = 'confirmed' then seats_booked else 0 end) as total_tickets_sold
from bookings;

