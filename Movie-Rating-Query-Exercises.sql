-- SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/


-- Question 1:
-- Find the titles of all movies directed by Steven Spielberg.
SELECT title 
FROM Movie
WHERE director = 'Steven Spielberg'


-- Question 2:
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
SELECT distinct year
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
AND stars >= 4
ORDER by year ASC


-- Question 3:
-- Find the titles of all movies that have no ratings. 
SELECT title
FROM Movie
WHERE mID not IN (SELECT mID FROM Rating)


-- Question 4:
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 
SELECT name
FROM Reviewer, Rating
WHERE Reviewer.rID = Rating.rID
AND ratingDate IS NULL

-- Question 5:
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. 
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 
SELECT name, title, stars, ratingDate
FROM Movie, Reviewer, Rating
WHERE Reviewer.rID = Rating.rID AND Movie.mID = Rating.mID
ORDER BY name, title, stars    


-- Question 6:
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie. 
SELECT distinct name, title
FROM Rating R1, Rating R2, Movie, Reviewer
WHERE R1.mID = R2.mID 
AND R1.rID = R2.rID 
AND R1.stars > R2.stars 
AND R1.ratingDate > R2.ratingDate
AND Movie.mID = R1.mID
AND Reviewer.rID = R1.rID


-- Question 7:
-- For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title. 
SELECT title, MAX(stars)
FROM Movie, Rating
WHERE Movie.mID = Rating.mID 
GROUP BY title


-- Question 8:
-- For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title. 
SELECT title, abs(MAX(stars) - MIN(stars)) AS spread
FROM Movie, Rating
WHERE Movie.mID = Rating.mID
GROUP BY title
ORDER BY spread DESC, title


-- Question 9:
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
SELECT AVG(stars_1)-AVG(stars_2)
FROM (  
        SELECT AVG(stars) AS stars_1
        FROM Movie JOIN Rating USING(mID)
        GROUP BY mID
        HAVING year < 1980),
    (
        SELECT AVG(stars) AS stars_2
        FROM Movie JOIN Rating USING(mID)
        GROUP BY mID
        HAVING year >= 1980)
        
