use sakila;

-- 1a --
select  first_name, last_name
	from actor;

-- 1b --
select concat(first_name, " ", last_name) as "Actor Name" 
	from actor;

-- 2a --
select a.actor_id, a.first_name, a.last_name 
	from actor a
	where (first_name = "Joe");

-- 2b --
select last_name
	from actor 
    where (last_name like "%gen%");

-- 2c --
select last_name, first_name 
	from actor 
	where (last_name like "%li%")
	order by last_name, first_name;

-- 2d --
select country_id, country
	from country
	where country
    in ('Afghanistan', 'Bangladesh', 'China');

-- 3a --
alter table actor
add column description blob;

-- 3b --
alter table actor
drop column description;

-- 4a --
select last_name, count(last_name) as last_nameappears
	from actor
	group by last_name;

-- 4b --
select last_name, count(last_name) as last_nameappears
	from actor
	group by last_name
	having last_nameappears >= 2;

-- 4c --
update actor
set first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';

select * 
	from actor
	where last_name = 'WILLIAMS';

-- 4d --
update actor
set first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';

select *
	from actor
	where last_name = 'WILLIAMS';

-- 5a --
-- create table if not exists address
show COLUMNS from address;

-- 6a --
SELECT s.first_name, s.last_name, a.address
	FROM staff s
	JOIN address a on
    s.address_id = a.address_id;

-- 6b --
SELECT p.staff_id, s.first_name, s.last_name, sum(p.amount), p.payment_date
	FROM payment p
	JOIN staff s on
    p.staff_id = s.staff_id
	where p.payment_date
	between '2005-8-1' and '2005-8-31'
	group by p.staff_id;

-- 6c --
SELECT f.film_id, f.title, count(fa.actor_id)
	FROM film f
	INNER JOIN film_actor fa ON
	f.film_id = fa.film_id
	group by f.film_id;

-- 6d --
SELECT f.film_id, f.title, count(*)
	FROM film f
	INNER JOIN inventory i ON
	f.film_id = i.film_id
	where f.title = 'Hunchback Impossible';

-- 6e --
SELECT c.first_name, c.last_name, sum(p.amount) as "Total Amount Paid"
	FROM payment p
	JOIN customer c ON
	p.customer_id = c.customer_id
	group by p.customer_id
	order by c.last_name asc;

-- 7a --
select f.title
	from film f
    where (f.title like "K%" or f.title like "Q%")
	and language_id =
		(select l.language_id
			from language l
            where name = "English");

-- 7b --
select a.first_name, a.last_name 
	from actor a
    where a.actor_id in
		(select fa.actor_id
			from film_actor fa
			where fa.film_id =
				(select f.film_id
					from film f
                    where f.title = "Alone Trip"));

-- 7c --
SELECT cust.first_name, cust.last_name, cust.email, cn.country
	FROM customer cust
	JOIN address a ON
	cust.address_id = a.address_id
    JOIN city c on
    a.city_id = c.city_id
    join country cn on
    c.country_id = cn.country_id
    where cn.country = "Canada";

-- 7d --
SELECT f.title, c.name
	FROM film f
	JOIN film_category fc ON
	f.film_id = fc.film_id
    join category c on
    fc.category_id = c.category_id
    where c.name = "Family";
    
-- 7e --
select f.title, count(f.title) as "Frequently Rented Movies"
	from payment p
    join rental r on
    p.rental_id = r.rental_id     
    join inventory i on
    r.inventory_id = i.inventory_id    
    join film f on
    i.film_id = f.film_id
    group by f.film_id
    order by count(f.title) desc;
    
-- 7f --
select st.store_id, sum(p.amount) as "Total Dollars"
	from payment p
    join staff s on
    p.staff_id = s.staff_id
	join store st on
	s.store_id = st.store_id
	group by st.store_id
	order by sum(p.amount);
    
select sbs.store, sbs.total_sales
	from sales_by_store sbs;
    
-- 7g --
select s.store_id, c.city, cntry.country
	from store s
    inner join address a on
    s.address_id = a.address_id
	inner join city c on
    a.city_id = c.city_id
    inner join country cntry on
    c.country_id = cntry.country_id;
    
-- 7h --
select c.name, sum(p.amount) as "Gross Revenue"
	from payment p
    inner join rental r on
    p.rental_id = r.rental_id
	inner join inventory i on
    r.inventory_id = i.inventory_id
    inner join film_category fc on
    i.film_id = fc.film_id
    inner join category c on
    fc.category_id = c.category_id
    group by c.name
    order by sum(p.amount) desc limit 5;
    
-- 8a --
Create view TOPFiveGenres as
select c.name, sum(p.amount) as "Gross Revenue"
	from payment p
    inner join rental r on
    p.rental_id = r.rental_id
	inner join inventory i on
    r.inventory_id = i.inventory_id
    inner join film_category fc on
    i.film_id = fc.film_id
    inner join category c on
    fc.category_id = c.category_id
    group by c.name
    order by sum(p.amount) desc limit 5;

-- 8b --    
select * from TopFiveGenres;

-- 8c --
drop view if exists TopFiveGenres;