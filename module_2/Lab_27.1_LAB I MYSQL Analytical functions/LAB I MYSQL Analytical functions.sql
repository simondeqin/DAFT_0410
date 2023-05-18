/* 
1. find the running total of rental payments for each customer in the payment table, ordered by payment date. 
By selecting the customer_id, payment_date, and amount columns from the payment table, 
and then applying the SUM function to the amount column within each customer_id partition, ordering by payment_date.
Hint: using SUM()  window function
*/

select * from sakila.payment;

select customer_id, payment_date, amount
, sum(amount) over (partition by customer_id order by payment_date) as running_total_rental
from payment limit 50;


/*
2.  find the rank and dense rank of each payment amount within each payment date by selecting 
the payment_date and amount columns from the payment table, and then applying the RANK and DENSE_RANK functions 
to the amount column within each payment_date partition, ordering by amount in descending order.
Hint: you need to extract only the date from the payment_date
*/

select date(payment_date) as payment_date2, amount
, rank() over (partition by date(payment_date) order by amount desc) as rank_payment
, dense_rank() over (partition by date(payment_date) order by amount desc) as dense_rank_payment
from payment limit 50;	
-- "date(payment_date) as payment_date2" will not work because this rename is temporary and will not be rememberd
-- without having created a column based on it

select date(payment_date) as date from payment limit 50;

select date_format(payment_date, '%Y-%m-%d') as payment_date2, amount
, rank() over (partition by date_format(payment_date, '%Y-%m-%d') order by amount desc) as rank_payment
, dense_rank() over (partition by date_format(payment_date, '%Y-%m-%d') order by amount desc) as dense_rank_payment
from payment limit 50;


/*
3. find the ranking of each film based on its rental rate, within its respective category. 
Hint: you need to extract the information from the film,film_category and category tables 
after applying join on them.
*/

select * from film;
select * from film_category;
select * from category;

select name, title, rental_rate 
, rank() over (partition by name order by rental_rate desc) as rnk
, dense_rank() over (partition by name order by rental_rate desc) as dens_rank
from film f
inner join film_category fc using (film_id)
inner join category c using (category_id);


/*
4.(OPTIONAL) update the previous query from above to retrieve only the top 5 films within each category
Hint: you can use ROW_NUMBER function in order to limit the number of rows.
*/
with row_by_category as
(
	select name, title, rental_rate 
	, rank() over (partition by name order by rental_rate desc) as rnk
	, row_number() over (partition by name order by rental_rate desc) as rw
	from film f
    inner join film_category fc using (film_id)
	inner join category c using (category_id)
)
select name, title, rental_rate, rnk, rw
from row_by_category
where rw < 6;


/*
5. find the difference between the current and previous payment amount and the difference between 
the current and next payment amount, for each customer in the payment table
Hint: select the payment_id, customer_id, amount, and payment_date columns from the payment table, 
and then applying the LAG and LEAD functions to the amount column, 
partitioning by customer_id and ordering by payment_date.
*/

select * from payment;

select payment_id, customer_id, payment_date, amount
, lag(amount) over (partition by customer_id order by payment_date) as prev_amount
, lead(amount) over (partition by customer_id order by payment_date) as next_amount
, amount - "prev_amount" as diff_from_prev
, amount - "next_amount" as diff_from_next
from payment; 

-- The solution below does not work for now; should ask Andy
with prev_amount, next_amount as (
select payment_id, customer_id, payment_date, amount
, lag(amount) over (partition by customer_id order by payment_date) as prev_amount
, lead(amount) over (partition by customer_id order by payment_date) as next_amount
from payment)

select payment_id, customer_id, payment_date, amount, prev_amount, next_amount
, amount - "prev_amount" as diff_from_prev
, amount - "next_amount" as diff_from_next
from payment; 


 
