USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title,count(inventory_id) FROM inventory
JOIN film 
USING (film_id)
WHERE film_id = (
SELECT film_id FROM film
WHERE title = 'Hunchback Impossible')
GROUP BY film_id; -- Done

-- 2. List all films whose length is longer than the average of all the films.
SELECT title FROM film
WHERE length > (SELECT avg(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM film_actor
JOIN actor
USING (actor_id)
WHERE film_id = (
	SELECT film_id FROM film
	WHERE title = 'Alone Trip'
	); -- Done

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title FROM film_category
JOIN film
USING (film_id)
WHERE category_id = (
	SELECT category_id FROM category AS family
	WHERE name = 'family'
	); -- Done
    
-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- With queries
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (    
		SELECT city_id FROM city
		WHERE country_id = (
			SELECT country_id FROM country
			WHERE country = 'Canada'
			)
        )
	);
    
-- With joins
SELECT first_name, last_name, email FROM customer
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country 
USING (country_id)
WHERE country = 'Canada'; -- Done

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.  
SELECT title FROM film_actor
JOIN film 
USING (film_id)
WHERE actor_id = (
	SELECT actor_id FROM (
		SELECT actor_id, count(film_id) AS count FROM film_actor
		GROUP BY actor_id
		) sub1
	ORDER BY count DESC
	LIMIT 1); -- Done

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer 
-- that has made the largest sum of payments
SELECT distinct title FROM inventory
JOIN film
USING (film_id)
WHERE inventory_id IN (
	SELECT inventory_id FROM rental 
	WHERE customer_id = (
		SELECT customer_id FROM payment
		GROUP BY customer_id
		ORDER BY sum(amount) DESC
		LIMIT 1
		)
	); -- Done


-- 8. Customers who spent more than the average payments.
SELECT distinct customer_id, sum(amount) AS total FROM payment
GROUP BY customer_id
HAVING total > (
	SELECT avg(sum) FROM (
		SELECT customer_id, sum(amount) AS sum FROM payment
		GROUP BY customer_id
		) sub1
	); -- avg is 112.54

    

