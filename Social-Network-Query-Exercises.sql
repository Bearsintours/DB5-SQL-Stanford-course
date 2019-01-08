-- SQL Social-Network Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/


-- Question 1:
-- Find the names of all students who are friends with someone named Gabriel. 
SELECT distinct name
FROM Highschooler, Friend
WHERE ID IN (SELECT ID2 FROM Highschooler, Friend WHERE name = "Gabriel" AND ID = ID1) 


-- Question 2:
-- For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like. 
SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM Highschooler hs1, Highschooler hs2, Likes
WHERE (
    hs1.ID = Likes.ID1 AND hs2.ID = Likes.ID2 AND (hs1.grade - hs2.grade) >= 2
) OR (
    hs1.ID = Likes.ID2 AND hs2.ID = Likes.ID1 AND (hs1.grade - hs2.grade) >= 2
)


-- Question 3:
-- For every pair of students who both like each other, return the name and grade of both students. 
Include each pair only once, with the two names in alphabetical order. 
SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM Highschooler hs1, Highschooler hs2, Likes l1, Likes l2
WHERE L1.ID1 = hs1.ID AND L1.ID2 = hs2.ID AND l1.ID1 = l2.ID2 AND l1.ID2 = l2.ID1 AND hs1.name < hs2.name


-- Question 4:
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. 
-- Sort by grade, then by name within each grade. 
SELECT distinct name, grade
FROM Highschooler hs, Likes
WHERE NOT ID IN (
    SELECT ID1 FROM Likes) 
AND ID NOT IN (
    SELECT ID2 FROM Likes)
ORDER BY grade, name


-- Question 5:
-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), 
-- return A and B's names and grades. 
SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM Highschooler hs1, Highschooler hs2, Likes
WHERE ID1 = hs1.ID AND ID2 = hs2.ID AND ID2 NOT IN (SELECT ID1 FROM Likes)


-- Question 6:
-- Find names and grades of students who only have friends in the same grade. 
-- Return the result sorted by grade, then by name within each grade. 
SELECT distinct hs1.name, hs1.grade
FROM Highschooler hs1, Highschooler hs2, Friend
WHERE ID1 = hs1.ID AND ID2 = hs2.ID AND hs1.ID NOT IN (
    SELECT hs1.ID 
    FROM Highschooler hs1, Highschooler hs2, Friend
    WHERE hs1.ID = Friend.ID1 AND hs2.ID = Friend.ID2 AND hs1.grade != hs2.grade)
ORDER BY hs1.grade, hs1.name


-- Question 7:
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). 
-- For all such trios, return the name and grade of A, B, and C. 
SELECT distinct hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM Highschooler hs1, Highschooler hs2, highschooler hs3, Friend, Likes
WHERE hs1.ID = Likes.ID1 AND hs2.ID = Likes.ID2  AND Likes.ID1 NOT IN (
    SELECT ID1 FROM Friend WHERE ID2 = Likes.ID2)
AND hs3.ID = Friend.ID1 AND Friend.ID1 IN (
    SELECT f1.ID1
    FROM Friend f1, Friend f2
    WHERE f1.ID2 = Likes.ID1 AND f2.ID2 = Likes.ID2 AND f1.ID1 = f2.ID1)


-- Question 8:
-- Find the difference between the number of students in the school and the number of different first names. 
SELECT
    (SELECT COUNT(ID) 
    FROM Highschooler) -
    (SELECT COUNT(distinct hs1.name)
    FROM Highschooler hs1, Highschooler hs2 
    WHERE NOT hs1.name = hs2.name)


-- Question 9:
-- Find the name and grade of all students who are liked by more than one other student. 
SELECT distinct hs1.name, hs1.grade
FROM Highschooler hs1, Highschooler hs2, Likes l1
WHERE l1.ID2 = hs1.ID AND l1.ID2 IN (
    SELECT ID2
    FROM Likes l2
    WHERE l2.ID2 = l1.ID2 AND NOT l2.ID1 = l1.ID1)

