--Crear base de datos llamada movies
CREATE DATABASE movies;

--Revisar los archivos peliculas.csv y reparto.csv para crear las tablas correspondientes,
--determinando la relación entre ambas tablas.
CREATE TABLE peliculas
(   
    id_peli SERIAL PRIMARY KEY, 
    pelicula_peli VARCHAR(80), 
    año_estreno_peli INT, 
    director_peli VARCHAR(50)
);

CREATE TABLE reparto
(   
    id_reparto INT, 
    actor_reparto VARCHAR(50),
    FOREIGN KEY (id_reparto) REFERENCES peliculas(id_peli)
);

--Cargar ambos archivos a su tabla correspondiente
\copy peliculas FROM '/home/pablo/Escritorio/top_100/peliculas.csv' CSV HEADER;

\copy reparto FROM '/home/pablo/Escritorio/top_100/reparto.csv' CSV HEADER;

--Listar todos los actores que aparecen en la película "Titanic", indicando el título de la película,
--año de estreno, director y todo el reparto.
SELECT
A.actor_reparto,
B.año_estreno_peli,
B.director_peli
From reparto AS A
INNER JOIN peliculas AS B ON A.id_reparto = B.id_peli
WHERE B.pelicula_peli = 'Titanic';

--Listar los titulos de las películas donde actúe Harrison Ford.
SELECT
A.pelicula_peli AS titulos
FROM peliculas AS A
INNER JOIN reparto AS B ON A.id_peli = B.id_reparto
WHERE B.actor_reparto = 'Harrison Ford';

--Listar los 10 directores mas populares, indicando su nombre y cuántas películas aparecen en el
--top 100.
SELECT
director_peli, count(id_peli) AS Top_100
From peliculas
GROUP BY director_peli
ORDER BY Top_100 Desc LIMIT 10;

--Indicar cuantos actores distintos hay
SELECT COUNT(DISTINCT actor_reparto) AS cantidad_de_actores_distintos FROM reparto;

--Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos) ordenadas por
--título de manera ascendente.
SELECT
pelicula_peli
From peliculas
WHERE año_estreno_peli BETWEEN 1990 AND 1999
ORDER BY pelicula_peli ASC;

--Listar el reparto de las películas lanzadas el año 2001
SELECT
actor_reparto
FROM reparto AS A
INNER JOIN peliculas AS B on A.id_reparto = B.id_peli
WHERE
B.año_estreno_peli = ( SELECT MAX(año_estreno_peli) FROM peliculas );

--Listar los actores de la película más nueva

SELECT
actor_reparto
FROM reparto 
WHERE id_reparto IN 
( SELECT id_peli From peliculas ORDER BY año_estreno_peli DESC LIMIT 1 );