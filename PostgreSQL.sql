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


