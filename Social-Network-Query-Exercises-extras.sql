-- SQL Social-Network Query Exercises Extras
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_extra/


-- Question 1:
-- For every situation where student A likes student B, but student B likes a different student C, 
-- return the names and grades of A, B, and C. 
SELECT distinct hs1.name, hs1.grade, hs2.name, hs2.grade, hs3.name, hs3.grade
FROM Highschooler hs1, Highschooler hs2, Highschooler hs3, Likes L1, Likes L2
WHERE L1.ID1 = hs1.ID AND L1.ID2 = hs2.ID AND L2.ID2 = hs3.ID AND L1.ID2 = L2.ID1 AND NOT L2.ID2 = L1.ID1


-- Question 2:
-- Find those students for whom all of their friends are in different grades from themselves. 
-- Return the students' names and grades. 
SELECT name, grade 
FROM Highschooler 
WHERE NOT name IN (
    SELECT distinct hs1.name
    FROM Friend, highschooler hs1, Highschooler hs2
    WHERE ID1 = hs1.ID AND ID2 = hs2.ID AND hs1.grade = hs2.grade)


-- Question 3:
-- What is the average number of friends per student? (Your result should be just one number.) 
SELECT AVG(friends) FROM
    (SELECT name, COUNT(ID2) AS friends
    FROM Highschooler hs, Friend f
    WHERE ID1 = ID
    GROUP BY ID)


-- Question 4:
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. 
-- Do not count Cassandra, even though technically she is a friend of a friend. 
SELECT distinct COUNT(ID2)
FROM (
    SELECT ID2
    FROM Friend f, Highschooler hs
    WHERE f.ID1 = hs.ID AND name = 'Cassandra' 
    UNION
    SELECT ID2 
    FROM Friend f, Highschooler hs1, highschooler hs2
    WHERE f.ID1 = hs1.ID AND f.ID2 = hs2.ID AND NOT hs2.name = 'Cassandra' AND ID1 IN (
        SELECT ID2
        FROM Friend f, Highschooler hs
        WHERE f.ID1 = hs.ID AND name = 'Cassandra'
        )
    )


-- Question 5:
-- Find the name and grade of the student(s) with the greatest number of friends. 
SELECT hs.name, hs.grade
FROM Highschooler hs, Friend f
WHERE hs.ID = f.ID1
GROUP BY f.ID1 
HAVING COUNT(ID2) = (
    SELECT MAX(friends)
    FROM (
        SELECT COUNT(ID2) as friends
        FROM Friend f, Highschooler hs
        WHERE f.ID1 = hs.ID 
        GROUP BY ID
        )
    )
    
