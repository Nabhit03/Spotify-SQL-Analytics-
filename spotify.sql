
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
SELECT * FROM public.spotify


-- EDA
SELECT COUNT (*) FROM spotify

SELECT COUNT (DISTINCT ARTIST) FROM spotify;

select distinct album_type FROM spotify;

SELECT MAX(duration_min)from spotify
SELECT MIN (duration_min)from spotify

SELECT* from spotify
WHERE duration_min = 0 

DELETE FROM spotify 
Where duration_min=0

Select DISTINCT channel from spotify;
Select DISTINCT most_played_on from spotify;


-- Q1 Retrieve the names of all tracks that have more than 1 billion streams
 Select * from spotify
 WHERE stream >1000000000;

--Q2 List all the albums along with their respective artists
SELECT  DISTINCT album , artist from spotify
ORDER BY 1

-- Q3 Get the total number of comments for tracks where liscensed = TRUE
SELECT SUM(comments) as total_comments FROM spotify
WHERE licensed = 'true';

-- Q4 Find all tracks that belong to album type single
SELECT album_type FROM spotify
WHERE album_type = 'single';

--Q5 Count the total no. of tracks by each artist
Select artist, COUNT(*) AS total_songs from spotify
GROUP BY artist
ORDER BY 2 ASC

--Q6 Calculate the average the dancebility of each track
SELECT album,avg(danceability) as avg_danceability FROM spotify 
GROUP BY 1
ORDER BY 2 DESC

-- Q7 Find the top 5 tracks with the highest energy values
Select track , MAX(energy) from spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q8List all the tracks along with their views and likes where official videos+ 'true'
SELECT track , SUM(views) as total_views , SUM(likes) as total_likes 
FROM spotify
 WHERE official_video = true
GROUP BY 1 
ORDER BY 2 DESC

-- Q9 For each calculate the total views of all associated tracks
Select album , track , SUM(views) FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC

-- Q10 Retrieve the tracks names that have been streamed on spotify more than youtube
 (SELECT  track ,
        -- most_played_on , 
		COALESCE (SUM (CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube , 
		COALESCE (SUM(CASE WHEN most_played_on= 'Spotify' THEN stream END),0)as  streamed_on_spotify
 FROM spotify       
GROUP BY 1
) as t1
WHERE
streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0 

 --Q11  Fond the top 3 most viewed tracks foreach artist using window function
WITH ranking_artist
AS
 (SELECT 
 artist , 
 track , 
 SUM(views) as total_view , 
 DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views)DESC) as RANK
 FROM spotify
 GROUP BY 1,2 
 ORDER BY 1,3 DESC
 )
 SELECT * FROM ranking_artist
 WHERE rank<=3

 --Q12 Write a query to find tracks where the liveness score is above average
SELECT track , artist , liveness FROM spotify 
WHERE liveness> (SELECT AVG(liveness )FROM spotify)

SELECT AVG(liveness) FROM spotify


--Q13 Use a With clause to calculate the difference between the highest and lowest energy value for track in each album
WITH yaj
AS
(SELECT 
 album , MAX(energy) as highest_energy, MIN(energy) as lowest_energy
FROM spotify
GROUP BY 1
)
select 
album , highest_energy - lowest_energy as energy_diff 
from yaj
ORDER BY 2 DESC







 
 

