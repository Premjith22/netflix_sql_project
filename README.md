# netflix_sql_project

![](https://github.com/Premjith22/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix_db;
CREATE TABLE netflix_db
(
Show_ID int,
Title varchar(150),
Director varchar(200),
Cast text,
Country varchar(150),
DATE_ADDED varchar(30),
Released_Year varchar(10),
Rating varchar(10),
Duration varchar(20),
Category_of_Movie text,
Description_of_Movie text,
Type_of_show varchar(100)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 5. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select *from netflix_db 
where director="Rajiv Chilaka"

```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 6. Count the Number of Content Items in Each Genre

```sql
select category_of_movie,count(*) as content_count
from netflix_db
group by 1
order by content_count desc;

```

**Objective:** Count the number of content items in each genre.

### 7. List All TV Shows with More Than 5 Seasons

```sql
SELECT title, duration 
FROM netflix_db
WHERE type_of_show LIKE 'TV Show%' 
AND CAST(REPLACE(REPLACE(LOWER(duration), 'seasons', ''), 'season', '') AS UNSIGNED) > 5;

```

**Objective:** Identify TV shows with more than 5 seasons.

### 8. Identify the Longest Movie

```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

**Objective:** Find the movie with the longest duration

### 9.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select released_year ,avg(content_count)
from
(select released_year,count(*) as content_count
from netflix_db
where country= "India"
group by released_year
order by released_year desc )as year_data
group by released_year;
```

**Objective:** Calculate and rank years by the average number of content releases by India

### 10. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries

### 11. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```

**Objective:** Identifies the content having the presence of kill and violence.

### 15. Compare the number of movies and tv shows added before and after 2015 

```sql
select 
	case when released_year <2015 then "before 2015" else "After 2015" end as period,
    type_of_show,
    count(*) as count
    from netflix_db
    group by period,type_of_show;
```
**Objective:** Lists the movies and Tv shows that were added before and after 2015.

### 16. Identify the most active month for adding movies/tv shows (by count)

```sql
select *from 
(select month(str_to_date(date_added,'%M %d,%Y'))as month,count(*) as content_count 
from netflix_db
group by month
order by content_count desc)as result_data
where month is not null
limit 1;
```

**Objective:** identifies the most number of movies or tv shows added in a month

### 17.Identify the top 3 most common gener in the dataset.

```sql
select category_of_movie as gener,count(*) as content_count
from netflix_db
group by gener
order by content_count desc
limit 3;
```

**Objective:** Identify Top 3 gener from the dataset

### 18.group the records by year and count the number of movies/tv shows added each year

```sql
select released_year ,count(*)as content_count from netflix_db
group by released_year
order by released_year desc;
```

**Objective:** Lists the total number if movies/Tv shows Added each year 
