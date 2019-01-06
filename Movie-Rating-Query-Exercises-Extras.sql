-- SQL Movie-Rating Query Exercises Extras
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/


-- Question 1:
-- Find the names of all reviewers who rated Gone with the Wind. 
SELECT distinct name
FROM Rating, Reviewer, Movie 
WHERE Rating.rID = Reviewer.rID AND Rating.mID = Movie.mID AND title = 'Gone with the Wind'


-- Question 2:
-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 
SELECT distinct name, title, stars 
FROM Reviewer, Movie, Rating
WHERE Reviewer.rID = Rating.rID AND Reviewer.name = Movie.director AND Movie.mID = Rating.mID


-- Question 3:
-- Return all reviewer names and movie names together in a single list, alphabetized. 
SELECT name
FROM Reviewer
UNION 
SELECT title
FROM Movie


-- Question 4:
-- Find the titles of all movies not reviewed by Chris Jackson. 
SELECT distinct title 
FROM Movie
WHERE NOT mID IN (
    SELECT mID 
    FROM Rating natural join Reviewer
    WHERE name = 'Chris Jackson')
    


-- Question 5:
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
-- Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
-- For each pair, return the names in the pair in alphabetical order. 
SELECT distinct R1.name, R2.name
FROM (Reviewer natural JOIN Rating) R1, (Reviewer natural JOIN Rating) R2
WHERE R1.name < R2.name AND R1.mID = R2.mID
ORDER BY R1.name, R2.name


-- Question 6:
-- For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars. 
SELECT name, title, stars 
FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID AND Rating.rID = Reviewer.rID AND stars = (SELECT MIN(stars) FROM Rating)


-- Question 7:
-- List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order. 
SELECT title, AVG(stars)
FROM Movie natural JOIN Rating
GROUP BY title
ORDER BY AVG(stars) DESC


-- Question 8:
-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
SELECT name
FROM Reviewer natural JOIN Rating
GROUP BY name
HAVING COUNT(mID) >= 3


-- Question 9:
-- Some directors directed more than one movie. For all such directors, 
return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.
SELECT distinct title, director
FROM Movie
WHERE director IN (
    SELECT director
    FROM Movie
    GROUP BY director
    HAVING COUNT(mID) > 1)
ORDER BY director


-- Question 10:
-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
SELECT title, AVG(stars) 
FROM Movie natural JOIN Rating
GROUP BY title
HAVING AVG(stars) = (
  SELECT MAX(avg_rating) FROM (
    SELECT AVG(stars) as avg_rating
    FROM Rating natural JOIN Movie
    GROUP BY title) as max_rating)


-- Question 11:
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
SELECT title, AVG(stars) 
FROM Movie natural JOIN Rating
GROUP BY title
HAVING AVG(stars) = (
  SELECT MIN(avg_rating) FROM (
    SELECT AVG(stars) as avg_rating
    FROM Rating natural JOIN Movie
    GROUP BY title) as max_rating)


-- Question 12:
-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, 
-- and the value of that rating. Ignore movies whose director is NULL. 
SELECT distinct director, title, stars
FROM Movie m1, Rating
WHERE m1.mID = Rating.mID AND stars IN (
    SELECT MAX(stars) 
    FROM Movie m2, Rating
    WHERE m2.mID = Rating.mID AND m1.director = m2.director)
    
