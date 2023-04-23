-- Lesson of Subqueries and Temp Tables

SELECT stores.stor_name AS Store, COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
FROM publications.sales sales
INNER JOIN publications.stores stores 
ON stores.stor_id = sales.stor_id
GROUP BY Store;

select * from Publications.sales;
select * from Publications.stores;

SELECT stores.stor_name AS Store, COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
FROM publications.stores stores
Left JOIN publications.sales sales
ON stores.stor_id = sales.stor_id
GROUP BY Store;

SELECT Store, Items/Orders AS AvgItems, Qty/Items AS AvgQty
FROM (
    SELECT stores.stor_name AS Store, COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
    FROM publications.sales sales
    INNER JOIN publications.stores stores 
    ON stores.stor_id = sales.stor_id
    GROUP BY Store
) summary;

SELECT Store, ord_num AS OrderNumber, ord_date AS OrderDate, 
title AS Title, sales.qty AS Qty, price AS Price, type as Type
FROM (
	SELECT stores.stor_id AS StoreID, stores.stor_name AS Store, 
    COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
	FROM publications.sales sales
	INNER JOIN publications.stores stores 
    ON stores.stor_id = sales.stor_id
	GROUP BY StoreID, Store
) summary
INNER JOIN publications.sales sales ON summary.StoreID = sales.stor_id
INNER JOIN publications.titles ON sales.title_id = titles.title_id
WHERE Items / Orders > 1;

SELECT stores.stor_id AS StoreID, stores.stor_name AS Store, 
COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
FROM publications.sales sales
INNER JOIN publications.stores stores ON stores.stor_id = sales.stor_id
GROUP BY StoreID, Store;

CREATE TEMPORARY TABLE publications.store_sales_summary
SELECT stores.stor_id AS StoreID, stores.stor_name AS Store, 
COUNT(DISTINCT(ord_num)) AS Orders, COUNT(title_id) AS Items, SUM(qty) AS Qty
FROM publications.sales sales
INNER JOIN publications.stores stores ON stores.stor_id = sales.stor_id
GROUP BY StoreID, Store;

SELECT * FROM publications.store_sales_summary;

SELECT Store, ord_num AS OrderNumber, ord_date AS OrderDate, 
title AS Title, sales.qty AS Qty, price AS Price, type as Type
FROM publications.store_sales_summary summary
INNER JOIN publications.sales sales ON summary.StoreID = sales.stor_id
INNER JOIN publications.titles ON sales.title_id = titles.title_id
WHERE Items / Orders > 1;



-- Challenge 1 - Most Profiting Authors

select * from Publications.titles;
select * from Publications.titleauthor;
select * from Publications.sales;

-- Step 1: Calculate the royalty of each sale for each author 
-- and the advance for each author and publication
SELECT titles.title_id, authors.au_id, titles.advance*titleauthor.royaltyper/100 AS advance,
titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
FROM Publications.titles AS titles
INNER JOIN Publications.sales AS sales ON sales.title_id = titles.title_id
INNER JOIN Publications.titleauthor AS titleauthor ON titleauthor.title_id = titles.title_id
INNER JOIN Publications.authors AS authors ON authors.au_id = titleauthor.au_id;

-- Step 2: Aggregate the total royalties for each title and author
SELECT title_id, au_id, sum(advance), sum(sales_royalty)
FROM (
	SELECT titles.title_id, authors.au_id, titles.advance*titleauthor.royaltyper/100 AS advance,
	titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
	FROM Publications.titles AS titles
	INNER JOIN Publications.sales AS sales ON sales.title_id = titles.title_id
	INNER JOIN Publications.titleauthor AS titleauthor ON titleauthor.title_id = titles.title_id
	INNER JOIN Publications.authors AS authors ON authors.au_id = titleauthor.au_id
) profits
GROUP BY title_id, au_id;

-- Step 3: Calculate the total profits of each author

# an error occurs
SELECT au_id, sum(sum(advance)+sum(sales_royalty)) AS total_profits
FROM (
	SELECT title_id, au_id, sum(advance), sum(sales_royalty)
	FROM (
		SELECT titles.title_id, authors.au_id, titles.advance*titleauthor.royaltyper/100 AS advance,
		titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
		FROM Publications.titles AS titles
		INNER JOIN Publications.sales AS sales ON sales.title_id = titles.title_id
		INNER JOIN Publications.titleauthor AS titleauthor ON titleauthor.title_id = titles.title_id
		INNER JOIN Publications.authors AS authors ON authors.au_id = titleauthor.au_id
	) profits
	group by title_id, au_id
) profits_sum
ORDER BY total_profits desc limit 3;


# still doesn't work
CREATE TEMPORARY TABLE Publications.profits_sum
SELECT title_id, au_id, sum(advance), sum(sales_royalty)
FROM (
	SELECT titles.title_id, authors.au_id, titles.advance*titleauthor.royaltyper/100 AS advance,
	titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 AS sales_royalty
	FROM Publications.titles AS titles
	INNER JOIN Publications.sales AS sales ON sales.title_id = titles.title_id
	INNER JOIN Publications.titleauthor AS titleauthor ON titleauthor.title_id = titles.title_id
	INNER JOIN Publications.authors AS authors ON authors.au_id = titleauthor.au_id
) profits
GROUP BY title_id, au_id;

SELECT * FROM Publications.profits_sum;
 
SELECT au_id, sum(advance)+sum(sales_royalty) AS total_profits
FROM Publications.profits_sum
ORDER BY total_profits desc limit 3;



 










