create database my_new_database;
select * from my_new_database.applestore2;

# 1.What are the different genres?
select distinct prime_genre from my_new_database.applestore2;

# 2. Which is the genre with the most apps rated?
select rating_count_tot, prime_genre from my_new_database.applestore2
order by rating_count_tot desc;

# 3. Which is the genre with most apps?  Games: 162
select prime_genre, count(prime_genre) from my_new_database.applestore2
group by prime_genre
order by count(prime_genre) desc;

# 4. Which is the one with least?  Medical: 1
select prime_genre, count(prime_genre)
from my_new_database.applestore2
group by prime_genre
order by count(prime_genre) asc;

# 5. Find the top 10 apps most rated.  Top10: Facebook, Pandora, ..., The Weather Channel
select track_name, rating_count_tot from my_new_database.applestore2
order by rating_count_tot desc limit 10;

# 6. Find the top 10 apps best rated by users.  
select track_name, user_rating from my_new_database.applestore2
order by user_rating desc limit 10;

# 7. Take a look at the data you retrieved in question 5. Give some insights.
select track_name, rating_count_tot, prime_genre, user_rating, price from my_new_database.applestore2
order by rating_count_tot desc limit 10;
# insights: most free; games as the most frequent genre; rating 4.5 as the mode

# 8. Take a look at the data you retrieved in question 6. Give some insights.
select track_name, user_rating, rating_count_tot, prime_genre, price from my_new_database.applestore2
order by user_rating desc limit 10;
# insights: most not free, games most frequent followed by Health & Fitness, rating count varies dramatically

# 9. Now compare the data from questions 5 and 6. What do you see?
# Popular apps tend to be free, with user rating at 4.5 or even lower. However, apps that need to pay can often offer very good user experience

# 10. How could you take the top 3 regarding both user ratings and number of votes?
select track_name, user_rating, rating_count_tot from my_new_database.applestore2
where user_rating = 5
order by rating_count_tot desc limit 3;

# 11. Do people care about the price of an app? Do some queries, comment why are you doing them and the results you retrieve. What is your conclusion?
select track_name, price, rating_count_tot, user_rating,
		case when price = 0 then 'Free'
			 when price <= 3 then 'Cheap'
             else 'Expensive'
		end as price_category
from my_new_database.applestore2
order by rating_count_tot desc limit 20;
# Answer: I use a descending order to see the price and rating of the most rated apps. The conclusion is that users do care about the price. 
# The main proof is the fact that most of the apps retrieved are free and that no expensive ones are included. 
# What's more, the cheap apps tend to be better rated than free ones, which implies that users have a higher expectation of the apps that are not free.

# More try which works
select track_name, price, rating_count_tot, user_rating
from my_new_database.applestore2
where price = 0
order by rating_count_tot desc limit 20;

# More try which does not work
select track_name, price, rating_count_tot, user_rating,
		case when price = 0 then 'Free'
			 when price <= 3 then 'Cheap'
             else 'Expensive'
		end as price_category
from my_new_database.applestore2
where price_category = 'Expensive'
order by rating_count_tot desc limit 20;

