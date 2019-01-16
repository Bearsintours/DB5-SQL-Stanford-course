-- SQL Movie-Rating Modification Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_mod


-- Question 1:
-- Add the reviewer Roger Ebert to your database, with an rID of 209. 
Insert into Reviewer
values(209, 'Roger Ebert')


-- Question 2:
-- Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
Insert into Rating
select rID, mID, 5, null 
from Reviewer, Movie 
where name = 'James Cameron' and mID in (select mID from Movie)
 

-- Question 3:
-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
Update Movie
set year = year + 25
where mID in (
    select mID from Movie natural join Rating
    group by mID
    having avg(stars) >= 4)


-- Question 4:
-- Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
Delete from Rating
where mID in (
    SELECT mID 
    from Movie
    where year < 1970 or year > 2000) 
and stars < 4
