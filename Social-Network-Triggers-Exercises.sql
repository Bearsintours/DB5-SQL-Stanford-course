-- SQL Social-Network Triggers Exercises
-- https://lagunita.stanford.edu/courses/DB/Constraints/SelfPaced/courseware/ch-constraints_and_triggers/seq-exercise-triggers/


-- Question 1: Write a trigger that makes new students named 'Friendly' automatically like everyone else in their grade. 
-- That is, after the trigger runs, we should have ('Friendly', A) in the Likes table for every other Highschooler A in the same grade as 'Friendly'.
Create Trigger T
after insert on Highschooler
when New.name = 'Friendly'
begin
    Insert into Likes
    select new.ID, ID from Highschooler where grade = new.grade and name <> 'Friendly';
end;


-- Question 2: Write one or more triggers to manage the grade attribute of new Highschoolers. 
-- If the inserted tuple has a value less than 9 or greater than 12, change the value to NULL. 
-- On the other hand, if the inserted tuple has a null value for grade, change it to 9. 
Create Trigger T
after insert on Highschooler
when new.grade < 9 or new.grade > 12
begin
    update Highschooler
    set grade = null
    where id = New.ID;
end;
|
Create Trigger T2
after insert on Highschooler
when new.grade is null
begin
    update Highschooler
    set grade = 9
    where id = New.ID;
end;


-- Question 3:  Write one or more triggers to maintain symmetry in friend relationships. 
-- Specifically, if (A,B) is deleted from Friend, then (B,A) should be deleted too. 
-- If (A,B) is inserted into Friend then (B,A) should be inserted too. 
Create Trigger T1
after insert on Friend
begin
    insert into Friend
    values(New.ID2, New.ID1);
end;
|
Create Trigger T2
after delete on Friend
begin
    delete from Friend
    where ID1 = Old.ID2 and ID2 = Old.ID1;
end;


-- Question 4: Write a trigger that automatically deletes students when they graduate, 
-- i.e., when their grade is updated to exceed 12. 
Create Trigger T
after update on Highschooler
when New.grade > 12
begin
    delete from Highschooler
    where id = New.ID;
end;


-- Question 5: Write a trigger that automatically deletes students when they graduate, 
-- i.e., when their grade is updated to exceed 12 (same as Question 4). 
-- In addition, write a trigger so when a student is moved ahead one grade, then so are all of his or her friends. 
Create Trigger T1
after update on Highschooler
when New.grade > 12
begin     
    delete from Highschooler where grade = New.grade;
end;
|
Create Trigger T2
after update on Highschooler
when New.grade - Old.grade = 1
begin
    update Highschooler
    set grade = grade + 1
    where ID in (
        select ID2 from Friend where ID1 = New.ID);
end;


-- Question 6: Write a trigger to enforce the following behavior: 
-- If A liked B but is updated to A liking C instead, and B and C were friends, make B and C no longer friends. 
-- Don't forget to delete the friendship in both directions, 
-- and make sure the trigger only runs when the "liked" (ID2) person is changed but the "liking" (ID1) person is not changed.
Create Trigger T
after update on Likes
when New.ID1 = Old.ID1 and New.ID2 <> Old.ID2
begin
    delete from Friend where ID1 = Old.ID2 and ID2 = New.ID2;
    delete from Friend where ID1 = New.ID2 and ID2 = Old.ID2;
end;



