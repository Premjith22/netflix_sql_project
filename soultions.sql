Table creation---
create table Netflix_db(
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


Select *from Netflix_db


load datasets----
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles_nov_2019.csv'
INTO TABLE netflix_db
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(show_id, title, director, cast, country, date_added, released_year, rating, duration, category_of_movie, description_of_movie, type_of_show);

Business Scenarios---
1.Count the number of movies and Tv shows?

select type_of_show ,count(*)as total_content from netflix_db
group by type_of_show;

2.FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENTS ON NETFLIX--
SELECT COUNTRY, COUNT(*)AS TOTAL_CONTENT FROM NETFLIX_DB
group by COUNTRY ORDER BY TOTAL_CONTENT DESC
LIMIT 5;

3 identify the longest movie---
select title, duration,type_of_show from netflix_db 
where type_of_show like "movie%"
order by duration desc
limit 1;

4.count the no.of content items in each gener
select category_of_movie,count(*) as content_count
from netflix_db
group by 1
order by content_count desc;

5.List all movies in a specific year (eg.2019)

select title,type_of_show ,released_year from netflix_db where released_year =2019;

6.find the content added in the last 5years----
SELECT title
FROM netflix_db
WHERE TIMESTAMPDIFF(YEAR, STR_TO_DATE(date_added, '%M %d, %Y'), CURDATE()) >= 5;

7 find all the movies/tv shows by director 'Rajiv Chilaka'
select *from netflix_db 
where director="Rajiv Chilaka"

8.list all the tv shoes with more than 5 seasons----

SELECT title, duration 
FROM netflix_db
WHERE type_of_show LIKE 'TV Show%' 
AND CAST(REPLACE(REPLACE(LOWER(duration), 'seasons', ''), 'season', '') AS UNSIGNED) > 5;


9 find all contents without a director--

select *from netflix_db
where director = null or director ="";


10.find how many movies actor "salman khan" released in last 10years---
SELECT COUNT(*) AS total_movies
FROM netflix_db
WHERE type_of_show = 'Movie'
AND LOWER(cast) LIKE '%salman khan%' 
AND YEAR(released_year) >= YEAR(CURDATE()) - 10;

11.identify movies/tv shows featuriing a specific actors(eg,"Robert de niro")---
select title,type_of_show ,cast from netflix_db where cast like 'robert%';

12.group the records by year and count the number of movies/tv shows added each year--
select released_year ,count(*)as content_count from netflix_db
group by released_year
order by released_year desc;

13 find each year and the average number of content releaseed in India  on netflix---
select released_year ,avg(content_count)
from
(select released_year,count(*) as content_count
from netflix_db
where country= "India"
group by released_year
order by released_year desc )as year_data
group by released_year;

14.Identify the top 3 most common gener in the dataset---
select category_of_movie as gener,count(*) as content_count
from netflix_db
group by gener
order by content_count desc
limit 3;

15.Identify the most active month for adding movies/tv shows (by count)----
select *from 
(select month(str_to_date(date_added,'%M %d,%Y'))as month,count(*) as content_count 
from netflix_db
group by month
order by content_count desc)as result_data
where month is not null
limit 1;


16 Compare the number of movies and tv shows added before and after 2015---
select 
	case when released_year <2015 then "before 2015" else "After 2015" end as period,
    type_of_show,
    count(*) as count
    from netflix_db
    group by period,type_of_show



