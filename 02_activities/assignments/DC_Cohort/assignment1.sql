 /* ASSIGNMENT 1 */
--Please write responses between the QUERY # and END QUERY blocks
/* SECTION 2 */


--SELECT
/* 1. Write a query that returns everything in the customer table. */
--QUERY 1
SELECT * FROM customer; 

--END QUERY


/* 2. Write a query that displays all of the columns and 10 rows from the customer table, 
sorted by customer_last_name, then customer_first_ name. */
--QUERY 2
SELECT * FROM customer -- displays all columns
ORDER BY customer_last_name, customer_first_name --sorted by the last name and then the first name
LIMIT 10; -- 10 rows

--END QUERY


--WHERE
/* 1. Write a query that returns all customer purchases of product IDs 4 and 9. 
Limit to 25 rows of output. */
--QUERY 3
SELECT * FROM customer_purchases -- customer purchases
WHERE product_id IN (4, 9) -- return product id of 4 and 9
LIMIT 25; -- 25 rows

--END QUERY



/*2. Write a query that returns all customer purchases and a new calculated column 'price' (quantity * cost_to_customer_per_qty), 
filtered by customer IDs between 8 and 10 (inclusive) using either:
	1.  two conditions using AND
	2.  one condition using BETWEEN
Limit to 25 rows of output.
*/
--QUERY 4
SELECT *, (quantity * cost_to_customer_per_qty) AS price -- make new column 'price'
FROM customer_purchases
WHERE customer_id >= 8 AND customer_id <= 10 -- using AND
LIMIT 25; -- limit output to 25 lines 

SELECT *, (quantity * cost_to_customer_per_qty) AS price -- make new column 'price'
FROM customer_purchases
WHERE customer_id BETWEEN 8 AND 10 -- using BETWEEN
LIMIT 25; -- limit output to 25 lines 

--END QUERY


--CASE
/* 1. Products can be sold by the individual unit or by bulk measures like lbs. or oz. 
Using the product table, write a query that outputs the product_id and product_name
columns and add a column called prod_qty_type_condensed that displays the word “unit” 
if the product_qty_type is “unit,” and otherwise displays the word “bulk.” */
--QUERY 5
SELECT product_id, product_name, -- need these 2 columns for output
    CASE WHEN product_qty_type = 'unit' 
	THEN 'unit' -- if the product_qty_type is "unit", display "unit"
        ELSE 'bulk' -- in all other cases, display "bulk"
    END AS prod_qty_type_condensed -- new (temporary) column for displaying 
FROM product; -- the table with the required columns

--END QUERY


/* 2. We want to flag all of the different types of pepper products that are sold at the market. 
add a column to the previous query called pepper_flag that outputs a 1 if the product_name 
contains the word “pepper” (regardless of capitalization), and otherwise outputs 0. */
--QUERY 6
SELECT product_id, product_name,
    CASE WHEN product_qty_type = 'unit' 
	THEN 'unit'
        ELSE 'bulk'
    END AS prod_qty_type_condensed, -- previous query (Query 5)
    CASE WHEN product_name LIKE '%pepper%' -- if product_name includes the word 'pepper'
	THEN 1 -- add flag 1
        ELSE 0 -- in all other cases, flag 0
    END AS pepper_flag -- the new (temporary) column for pepper flag
FROM product;

--END QUERY


--JOIN
/* 1. Write a query that INNER JOINs the vendor table to the vendor_booth_assignments table on the 
vendor_id field they both have in common, and sorts the result by market_date, then vendor_name.
Limit to 24 rows of output. */
--QUERY 7
SELECT v.vendor_id, vba.vendor_id, -- columns used for joining
	 v.vendor_name, vba.market_date -- used for sorting
FROM vendor AS v -- read vendor table as v (SQL reads this first before the 'select' part)
INNER JOIN vendor_booth_assignments AS vba -- read vendor_booth_assignments table as vba
    ON v.vendor_id = vba.vendor_id -- INNER JOIN: bring the rows in which values are present in BOTH tables
ORDER BY vba.market_date, v.vendor_name -- sort the result
LIMIT 24;

--END QUERY



/* SECTION 3 */

-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */
--QUERY 8
SELECT 
    vendor_id,
    COUNT(*) AS booth_rental_count --display the count of booth rentals for each vendor_id
FROM vendor_booth_assignments
GROUP BY vendor_id; --group the result by vendor_id to get the count for each vendor

--END QUERY


/* 2. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $2000 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 

HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword. */
--QUERY 9
SELECT 
    c.customer_first_name,
    c.customer_last_name -- need these columns for output
FROM customer as c -- read customer table as c (SQL reads this first before the 'select' part)
INNER JOIN customer_purchases as cp
    ON c.customer_id = cp.customer_id -- bring the rows in which values are present in BOTH tables
GROUP BY c.customer_id, -- group by customer_id to get the total spent for each customer
         c.customer_last_name, 
         c.customer_first_name -- also group by last name and first name for sorting and output
HAVING SUM(cp.quantity * cp.cost_to_customer_per_qty) > 2000 -- filter for customers who spent more than $2000
ORDER BY c.customer_last_name, 
         c.customer_first_name; -- sort the result by last name, then first name
	 
--END QUERY


--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal

HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) 

-> To insert the new row use VALUES, specifying the value you want for each column:
VALUES(col1,col2,col3,col4,col5) 
*/
--QUERY 10
-- Create the temp table
DROP TABLE IF EXISTS temp.new_vendor;
CREATE TABLE temp.new_vendor AS 
SELECT * FROM vendor;

-- Insert the new 10th vendor
INSERT INTO temp.new_vendor
    (vendor_id, vendor_name, vendor_type, vendor_owner_first_name, vendor_owner_last_name)
VALUES
    (10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas', 'Rosenthal');

--END QUERY


-- Date
/*1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.

HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month 
and year are! 
Limit to 25 rows of output. */
--QUERY 11



--END QUERY


/* 2. Using the previous query as a base, determine how much money each customer spent in April 2022. 
Remember that money spent is quantity*cost_to_customer_per_qty. 

HINTS: you will need to AGGREGATE, GROUP BY, and filter...
but remember, STRFTIME returns a STRING for your WHERE statement...
AND be sure you remove the LIMIT from the previous query before aggregating!! */
--QUERY 12



--END QUERY
