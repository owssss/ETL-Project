-- Here you will find the queries, functions, alters, etc that I did for this project

-- Creating table where the csv will be loaded
CREATE DATABASE 

CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title TEXT,
    vote_average NUMERIC,
    vote_count NUMERIC,
    status TEXT,
    release_date DATE,
    revenue NUMERIC,
    runtime NUMERIC,
    budget NUMERIC,
    imdb_id TEXT UNIQUE,
    original_language TEXT,
    original_title TEXT,
    overview TEXT,
    popularity NUMERIC,
    tagline TEXT,
    genres TEXT,
    production_companies TEXT,
    production_countries TEXT,
    spoken_languages TEXT,
    "cast" TEXT, --this one is a reserve keyword reason why it has quote
    director TEXT,
    director_of_photography TEXT,
    writers TEXT,
    producers TEXT,
    music_composer TEXT,
    imdb_rating NUMERIC,
    imdb_votes NUMERIC,
    poster_path TEXT
);

-- Altering release_date from timestamp to date
ALTER TABLE movies 
ALTER COLUMN release_date TYPE DATE;

-- Looking to normalize this database and make the movies a staging table
-- AND !! TADAHHH after almost a month, I came back with this little project of mine.

-- let's create fact and dim tables inside the database.

CREATE TABLE dim_genres(   -- this is for genres
	genre_id SERIAL PRIMARY KEY,
	genre_name TEXT UNIQUE
);  

CREATE TABLE dim_production_companies(  -- this is for production companies
	company_id SERIAL PRIMARY KEY,
	company_name TEXT UNIQUE
);

CREATE TABLE dim_directors(  -- directors dim table
	director_id SERIAL PRIMARY KEY,
	director_name TEXT UNIQUE
);

CREATE TABLE dim_actors (  -- for the actors 
	actor_id SERIAL PRIMARY KEY,
	actor_name TEXT UNIQUE
);

CREATE TABLE dim_languages (  -- and for the languages
	language_id SERIAL PRIMARY KEY,
	language_code TEXT UNIQUE,
	language_name TEXT
);

-- FACT TABLE --
CREATE TABLE fact_movies (
	movie_id SERIAL PRIMARY KEY,
	title TEXT,
	release_date DATE,
	budget NUMERIC,
	revenue NUMERIC,
	vote_average FLOAT,
	vote_count INT,
	popularity FLOAT,
	imdb_rating FLOAT,
	imdb_votes FLOAT,
	genre_id INT,
	production_company_id INT,
	FOREIGN KEY (genre_id) REFERENCES dim_genres(genre_id),
	FOREIGN KEY (production_company_id) REFERENCES dim_production_companies(company_id)
);

-- TIME TO INSERT data from the movies table

INSERT INTO dim_genres (genre_name)
SELECT DISTINCT unnest(string_to_array(genres,', '))
FROM movies
WHERE genres IS NOT NULL
ON CONFLICT (genre_name) DO NOTHING;

INSERT INTO dim_production_companies (company_name)
SELECT DISTINCT unnest(string_to_array(production_companies,', '))
FROM movies
WHERE production_companies IS NOT NULL
ON CONFLICT (company_name) DO NOTHING;

INSERT INTO dim_actors (actor_name)
SELECT DISTINCT unnest(string_to_array(m.cast,', '))
FROM movies m
WHERE m.cast IS NOT NULL
ON CONFLICT (actor_name) DO NOTHING;

-- inserting data to the fact_table
INSERT INTO fact_movies (
		title,
		release_date,
		budget,
		revenue,
		vote_average,
		vote_count,
		popularity,
		imdb_rating,
		imdb_votes,
		genre_id,
		production_company_id
)
SELECT
	m.title,
	m.release_date::DATE,
	m.budget,
	m.revenue,
	m.vote_average,
	m.vote_count,
	m.popularity,
	m.imdb_rating,
	m.imdb_votes,
	g.genre_id,
	pc.company_id
FROM movies m
LEFT JOIN dim_genres g ON g.genre_name = split_part(m.genres,',', 1)
LEFT JOIN dim_production_companies pc ON pc.company_name = split_part(m.production_companies,',', 1);

-- hmmmmm, I think I need the actors to this fact table? let me think, and come back again in a month? hehe


