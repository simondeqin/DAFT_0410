-- Challenge 1 - Who Have Published What At Where?

select au_id, concat(au_fname, ' ', au_lname) as au_fullname from Publications.authors;

select * from Publications.publishers;
-- pub_id, pub_name
select * from Publications.titles;
-- title_id, title, pub_id
select * from Publications.titleauthor;
-- au_id, title_id

select publishers.pub_name, titles.title 
from Publications.publishers publishers
left join Publications.titles titles
    on publishers.pub_id = titles.pub_id;
    
/*
Your output should have at least the following columns:
AUTHOR ID - the ID of the author
LAST NAME - author last name
FIRST NAME - author first name
TITLE - name of the published title
PUBLISHER - name of the publisher where the title was published
*/

select authors.au_id, authors.au_fname, authors.au_lname, titles.title, publishers.pub_name 
from Publications.authors as authors
left join Publications.titleauthor as titleauthor
	on authors.au_id = titleauthor.au_id
left join Publications.titles as titles
	on titles.title_id = titleauthor.title_id
left join Publications.publishers as publishers
	on publishers.pub_id = titles.pub_id;
    
    
-- Challenge 2 - Who Have Published How Many At Where?

/*
Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher.
To check if your output is correct, sum up the TITLE COUNT column. 
The sum number should be the same as the total number of records in Table titleauthor.
*/

select count(au_id), count(title_id) from Publications.titleauthor;  # total number of records is 25


select authors.au_id, authors.au_fname, authors.au_lname, publishers.pub_name, count(publishers.pub_name)
from Publications.authors as authors
left join Publications.titleauthor as titleauthor
	on authors.au_id = titleauthor.au_id
left join Publications.titles as titles
	on titles.title_id = titleauthor.title_id
left join Publications.publishers as publishers
	on publishers.pub_id = titles.pub_id
group by authors.au_id, publishers.pub_name;  # total item number is 25 (but don't know how to use 'sum' function)


-- Challenge 3 - Best Selling Authors

/* 
Who are the top 3 authors who have sold the highest number of titles? Write a query to find out.

Requirements:

Your output should have the following columns:
AUTHOR ID - the ID of the author
LAST NAME - author last name
FIRST NAME - author first name
TOTAL - total number of titles sold from this author
Your output should be ordered based on TOTAL from high to low.
Only output the top 3 best selling authors.
*/

select authors.au_id, authors.au_fname, authors.au_lname, count(titles.title)
from Publications.authors as authors
left join Publications.titleauthor as titleauthor
	on authors.au_id = titleauthor.au_id
left join Publications.titles as titles
	on titles.title_id = titleauthor.title_id
group by authors.au_id
order by count(titles.title) desc limit 3;
# answer: there are six authors who have sold 2 titles, who are Marjorie Green, Michael O'Leary, ...


-- Challenge 4 - Best Selling Authors Ranking

/*
Now modify your solution in Challenge 3 so that the output will display all 23 authors instead of the top 3. 
Note that the authors who have sold 0 titles should also appear in your output 
(ideally display 0 instead of NULL as the TOTAL). Also order your results based on TOTAL from high to low.
*/

select count(distinct authors.au_id) from Publications.authors as authors;  # there are 23 au_id

select authors.au_id, authors.au_fname, authors.au_lname, count(titles.title)
from Publications.authors as authors
left join Publications.titleauthor as titleauthor
	on authors.au_id = titleauthor.au_id
left join Publications.titles as titles
	on titles.title_id = titleauthor.title_id
group by authors.au_id
order by count(titles.title) desc; 


 
