USE sakila; -- (select the db that's going to be use for those exercices)

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title AS título-- using 'DISTINCT' we ensure that the elements selected will be different when displayed
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title AS título -- title will be displayed
FROM film 
WHERE rating = "PG-13"; -- the title displayed will be filtered under this condition 

-- 3.  Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title AS título, description AS Descripción 
FROM  film
WHERE title LIKE '%amazing%' OR description LIKE '%amazing%'; -- using where clause to filter under the condition indicated

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title AS título 
FROM  film
WHERE length > 120; -- where clause filsters those films with length bigger than 120 

-- 5. Recupera los nombres de todos los actores.

SELECT CONCAT(first_name, " ", last_name) AS NombreActor -- by using concat we can display the information under a unique column called "NombreActor" helping to show the info more clearly
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%"; -- we filter under the condition indicated: 'GIBSON' must be on actor's last_name 

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, last_name AS NombreActor
FROM actor
WHERE actor_id BETWEEN 10 AND 20; -- under this condition we're able to select those actor's whose id is between 10 and 20

-- 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
FROM film
WHERE rating NOT IN ("R","PG-13");

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.
SELECT rating AS Clasificacion, COUNT(rating) AS Recuento -- the colums have been renamed in order to show the info clearly
FROM film
GROUP BY Clasificacion;

--  REVISAR 10.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer.customer_id AS IDCliente, customer.first_name AS Nombre, customer.last_name AS Apellido, COUNT(*) AS CantidadPeliculasAlquiladas
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY  rental.customer_id;




-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT COUNT(*) AS RecuentoAlquileres, category.name  AS NombreCategoria
FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN film_category ON film_category.film_id = inventory.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY NombreCategoria;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración.
SELECT AVG(length) AS DuracionPromedio, rating AS Clasificacion
FROM film
GROUP BY Clasificacion HAVING AVG(length);

--  REVISAR 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT first_name AS Nombre, last_name AS Apellido 
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film.film_id = film_actor.film_id
WHERE title = "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title
FROM film 
WHERE description LIKE "%dog%" OR "%cat%";

--  REVISAR 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla `film_actor`.
SELECT first_name AS Nombre, last_name AS Apellido
FROM actor
WHERE NOT (SELECT film_actor.actor_id FROM film_actor);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title AS titulo 
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT title AS TITULO
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
WHERE film_category.category_id IN (SELECT category.category_id
FROM category
WHERE name = "Family");

-- REVISAR 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT CONCAT(first_name, " ", last_name) AS NombreActor
FROM actor
WHERE actor_id IN (
  SELECT actor_id
  FROM film_actor
  GROUP BY actor_id
  HAVING COUNT(film_id) > 10
);

-- REVISAR 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`.
SELECT title AS Titulo
FROM film
WHERE rating = "R" AND FLOOR(length/ 60) >= 2; -- using floor allows us to transform film lenght into hours and compare it to the amount indicated

--  REVISAR 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT AVG(length) AS MediaMinutos,  category.name AS Categoria
FROM film
INNER JOIN film_category ON film_category.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
HAVING AVG(length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT CONCAT(first_name, " ", last_name) AS NombreActor, COUNT(film_id) AS CantidadPeliculas
FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY NombreActor HAVING COUNT(film_id) > 5;

-- REVISAR 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

SELECT title
FROM film
WHERE film.film_id IN (
  SELECT film_id
  FROM rental
  WHERE DATEDIFF(dd, rental_date, return_date) > 5
);

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT CONCAT(first_name, " ", last_name) AS NombreActor
FROM actor
WHERE actor.actor_id NOT IN (
SELECT actor_id
FROM film_actor
INNER JOIN film_category ON film_actor.film_id = film_category.film_id
WHERE film_category.category_id = (SELECT category_id
FROM category
WHERE category.name = "Horror")
);

-- BONUS
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`.
WITH Peliculas_comedia AS (SELECT title
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON film_category.category_id = category.category_id
WHERE category.name = "Comedy")
SELECT title 
FROM Peliculas_comedia
WHERE title IN (
SELECT title
FROM film
WHERE film.length > 180);

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.

WITH PeliculasActores AS (
  SELECT COUNT(*) AS Peliculas
  FROM film_actor AS fa1
  INNER JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id
) -- cte calculates de number of movies starred by each actor 
SELECT -- selects the name of the actors giving A and B in order to avoid any row with same actor's name in both columns 
  CONCAT(A.first_name, ' ', A.last_name) AS NombreActorA,
  CONCAT(B.first_name, ' ', B.last_name) AS NombreActorB,
  (SELECT COUNT(DISTINCT fa1.film_id) -- calculation of the number of movies for each pair of actors
    FROM film_actor AS fa1
    INNER JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id
    WHERE fa1.actor_id = A.actor_id AND fa2.actor_id = B.actor_id) AS NumeroPeliculas
FROM actor AS A -- selects the name of the actors giving A and B in order to avoid any row with same actor's name in both columns
INNER JOIN actor AS B ON A.actor_id <> B.actor_id -- selects the name of the actors giving A and B in order to avoid any row with same actor's name in both columns
HAVING NumeroPeliculas > 1; -- this filter just displays the combination of actor that have already work toghether

