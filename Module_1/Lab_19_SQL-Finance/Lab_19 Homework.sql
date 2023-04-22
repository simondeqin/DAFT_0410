-- 1. From the order_items table, find the price of the highest priced order and lowest price order.
select * from olist.order_items;

select order_id, price from olist.order_items
order by price desc;
# highest price: 6735

select order_id, price from olist.order_items
order by price asc;
# lowest price: 0.85


-- 2. From the order_items table, what is range of the shipping_limit_date of the orders?
select order_id, shipping_limit_date from olist.order_items
order by shipping_limit_date desc;  -- 2020-04-10

select order_id, shipping_limit_date from olist.order_items
order by shipping_limit_date asc;  -- 2016-09-19

# range: [2016-09-19, 2020-04-10]


-- 3. From the customers table, find the states with the greatest number of customers.
select * from olist.customers;

select customer_state, count(customer_state) from olist.customers
group by customer_state
order by count(customer_state) desc;
# answer: SP


-- 4. From the customers table, within the state with the greatest number of customers, 
-- find the cities with the greatest number of customers.
select customer_city, count(customer_city) from olist.customers
where customer_state = "SP"
group by customer_city
order by count(customer_city) desc;
# answer: Sao Paolo, Campinas, Guarulhos, ...


-- 5. From the closed_deals table, 
-- how many distinct business segments are there (not including null)?
select * from olist.closed_deals;

select count(distinct business_segment) from olist.closed_deals;
# answer: 33


-- 6. From the closed_deals table, sum the declared_monthly_revenue for duplicate row values 
-- in business_segment and find the 3 business segments with the highest declared monthly revenue 
-- (of those that declared revenue).
select business_segment, count(declared_monthly_revenue) from olist.closed_deals
group by business_segment
order by count(declared_monthly_revenue) desc limit 10;
# answer: home_decor, health_beauty, car_accessories


-- 7. From the order_reviews table, find the total number of distinct review score values.
select * from olist.order_reviews;

select count(distinct review_score) from olist.order_reviews;
# answer: 5


-- 8. In the order_reviews table, create a new column with a description 
-- that corresponds to each number category for each review score from 1 - 5, 
-- then find the review score and category occurring most frequently in the table.
select review_score, count(review_score),
		case when review_score = 5 then 'Very satisfied'
			 when review_score = 4 then 'Satisfied'
             when review_score = 3 then 'Acceptable'
             when review_score = 2 then 'Not satisfied'
             else 'Highly unsatisfied'
		end as review_feedback
from olist.order_reviews
group by review_score
order by count(review_score) desc;
# answer: 5, 'Very satisfied'


-- 9. From the order_reviews table, find the review value occurring most frequently 
-- and how many times it occurs.
# answer: 5, which occurs 57420 times



