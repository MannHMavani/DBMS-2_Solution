--LAB-1
-- Create Tables
CREATE TABLE Artists (
    Artist_id INT PRIMARY KEY,
    Artist_name NVARCHAR(50)
);

CREATE TABLE Albums (
    Album_id INT PRIMARY KEY,
    Album_title NVARCHAR(50),
    Artist_id INT,
    Release_year INT,
    FOREIGN KEY (Artist_id) REFERENCES Artists(Artist_id)
);

CREATE TABLE Songs (
    Song_id INT PRIMARY KEY,
    Song_title NVARCHAR(50),
    Duration DECIMAL(4, 2),
    Genre NVARCHAR(50),
    Album_id INT,
    FOREIGN KEY (Album_id) REFERENCES Albums(Album_id)
);

-- Insert Data into Artists Table
INSERT INTO Artists (Artist_id, Artist_name) VALUES
(1, 'Aparshakti Khurana'),
(2, 'Ed Sheeran'),
(3, 'Shreya Ghoshal'),
(4, 'Arijit Singh'),
(5, 'Tanishk Bagchi');

-- Insert Data into Albums Table
INSERT INTO Albums (Album_id, Album_title, Artist_id, Release_year) VALUES
(1001, 'Album1', 1, 2019),
(1002, 'Album2', 2, 2015),
(1003, 'Album3', 3, 2018),
(1004, 'Album4', 4, 2020),
(1005, 'Album5', 2, 2020),
(1006, 'Album6', 1, 2009);

-- Insert Data into Songs Table
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id) VALUES
(101, 'Zaroor', 2.55, 'Feel good', 1001),
(102, 'Espresso', 4.10, 'Rhythmic', 1002),
(103, 'Shayad', 3.20, 'Sad', 1003),
(104, 'Roar', 4.05, 'Pop', 1002),
(105, 'Everybody Talks', 3.35, 'Rhythmic', 1003),
(106, 'Dwapara', 3.54, 'Dance', 1002),
(107, 'Sa Re Ga Ma', 4.20, 'Rhythmic', 1004),
(108, 'Tauba', 4.05, 'Rhythmic', 1005),
(109, 'Perfect', 4.23, 'Pop', 1002),
(110, 'Good Luck', 3.55, 'Rhythmic', 1004);

SELECT *From Albums
SELECT *From Artists
SELECT *From Songs
--Part-A
-- 1. Retrieve a unique genre of songs.
SELECT DISTINCT Genre FROM Songs;

-- 2. Find top 2 albums released before 2010.
SELECT TOP 2 Album_title, Release_year
FROM Albums
WHERE Release_year < 2010;

-- 3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
INSERT INTO Songs (Song_id, Song_title, Duration, Genre, Album_id)
VALUES (1245, 'Zaroor', 2.55, 'Feel good', 1005);

-- 4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
UPDATE Songs
SET Genre = 'Happy'
WHERE Song_title = 'Zaroor';

-- 5. Delete an Artist ‘Ed Sheeran’
DELETE FROM Artists
WHERE Artist_name = 'Ed Sheeran';

-- 6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
ALTER TABLE Songs
ADD Rating DECIMAL(3, 2);

-- 7. Retrieve songs whose title starts with 'S'.
SELECT * FROM Songs
WHERE Song_title LIKE 'S%';

-- 8. Retrieve all songs whose title contains 'Everybody'.
SELECT * FROM Songs
WHERE Song_title LIKE '%Everybody%';

-- 9. Display Artist Name in Uppercase.
SELECT UPPER(Artist_name) AS Artist_Name_Uppercase
FROM Artists;

-- 10. Find the Square Root of the Duration of a Song ‘Good Luck’
SELECT Song_title, SQRT(Duration) AS Duration_SquareRoot
FROM Songs
WHERE Song_title = 'Good Luck';

-- 11. Find Current Date.
SELECT GETDATE() AS CurrentDate;

-- 12. Retrieve the total duration of songs by each artist where total duration exceeds 100 minutes.
SELECT AL.Artist_id, SUM(S.Duration) AS Total_Duration
FROM Songs S
Left JOIN Albums AL ON S.Album_id = AL.Album_id
GROUP BY AL.Artist_id
HAVING SUM(S.Duration) > 100;

-- 13. Find the number of albums for each artist.
SELECT Artist_id, COUNT(Album_id) AS Album_Count
FROM Albums
GROUP BY Artist_id;

-- 14. Retrieve the Album_id which has more than 5 songs in it.
SELECT Album_id
FROM Songs
GROUP BY Album_id
HAVING COUNT(Song_id) > 5;

-- 15. Retrieve all songs from the album 'Album1'. (using Subquery)
SELECT * FROM Songs
WHERE Album_id = (SELECT Album_id FROM Albums WHERE Album_title = 'Album1');

-- 16. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
SELECT Album_title FROM Albums
WHERE Artist_id = (SELECT Artist_id FROM Artists WHERE Artist_name = 'Aparshakti Khurana');

-- 17. Find all the songs which are released in 2020.
SELECT S.*
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
WHERE AL.Release_year = 2020;

-- 18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
CREATE VIEW Fav_Songs AS
SELECT * FROM Songs
WHERE Song_id BETWEEN 101 AND 105;

-- 19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
UPDATE Fav_Songs
SET Song_title = 'Jannat'
WHERE Song_id = 101;

-- 20. Find all artists who have released an album in 2020. (using Joins)
SELECT DISTINCT A.Artist_name
FROM Artists A
JOIN Albums AL ON A.Artist_id = AL.Artist_id
WHERE AL.Release_year = 2020;

-- 21. Retrieve all songs by 'Artist1' and order them by duration. (using Joins)
SELECT S.*
FROM Songs S
Left JOIN Albums AL ON S.Album_id = AL.Album_id
Left JOIN Artists A ON AL.Artist_id = A.Artist_id
WHERE A.Artist_name='Artist1'
ORDER BY S.Duration;

-- 22. Retrieve all song titles by artists who have more than one album. (using Joins)
SELECT S.Song_title
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
JOIN Artists A ON AL.Artist_id = A.Artist_id
WHERE A.Artist_id IN (
    SELECT Artist_id
    FROM Albums
    GROUP BY Artist_id
    HAVING COUNT(Album_id) > 1
);
--Part-B

-- 23. Retrieve all albums along with the total number of songs. (using Joins)
SELECT AL.Album_title, COUNT(S.Song_id) AS Total_Songs
FROM Albums AL
LEFT JOIN Songs S 
ON AL.Album_id = S.Album_id
GROUP BY AL.Album_title;

-- 24. Retrieve all songs and release year and sort them by release year. (using Joins)
SELECT S.Song_title, AL.Release_year
FROM Songs S
JOIN Albums AL 
ON S.Album_id = AL.Album_id
ORDER BY AL.Release_year;

-- 26. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
SELECT Genre, COUNT(Song_id) AS Song_Count
FROM Songs
GROUP BY Genre
HAVING COUNT(Song_id) > 2;

-- 27. List all artists who have albums that contain more than 3 songs.
SELECT A.Artist_name
FROM Artists A
JOIN Albums AL ON A.Artist_id = AL.Artist_id
JOIN Songs S ON AL.Album_id = S.Album_id
GROUP BY A.Artist_name, AL.Album_id
HAVING COUNT(S.Song_id) > 3;

--Part-C
-- 28. Retrieve albums that have been released in the same year as 'Album2'
SELECT AL2.Album_title
FROM Albums AL1
JOIN Albums AL2 
ON AL1.Release_year = AL2.Release_year
WHERE AL1.Album_title = 'Album2' AND AL1.Album_id <> AL2.Album_id;

-- 29. Find the longest song in each genre
SELECT Genre, MAX(Duration) AS Longest_Duration
FROM Songs
GROUP BY Genre;

-- 30. Retrieve the titles of songs released in albums that contain the word 'Album' in the title
SELECT S.Song_title
FROM Songs S
JOIN Albums AL ON S.Album_id = AL.Album_id
WHERE AL.Album_title LIKE '%Album%';

--LAB-2
-- Create Department Table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
    DesignationID INT PRIMARY KEY,
    DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
    PersonID INT PRIMARY KEY IDENTITY(101,1),
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATETIME NOT NULL,
    DepartmentID INT NULL,
    DesignationID INT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);

-- Insert Data into Department Table
INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(1, 'Admin'),
(2, 'IT'),
(3, 'HR'),
(4, 'Account');

-- Insert Data into Designation Table
INSERT INTO Designation (DesignationID, DesignationName) VALUES
(11, 'Jobber'),
(12, 'Welder'),
(13, 'Clerk'),
(14, 'Manager'),
(15, 'CEO');

-- Insert Data into Person Table
INSERT INTO Person (FirstName, LastName, Salary, JoiningDate, DepartmentID, DesignationID) VALUES
('Rahul', 'Anshu', 56000, '1990-01-01', 1, 12),
('Hardik', 'Hinsu', 18000, '1990-09-25', 2, 11),
('Bhavin', 'Kamani', 25000, '1991-05-14', NULL, 11),
('Bhoomi', 'Patel', 39000, '2014-02-20', 1, 13),
('Rohit', 'Rajgor', 17000, '1990-07-23', 2, 15),
('Priya', 'Mehta', 25000, '1990-10-18', 2, NULL),
('Neha', 'Trivedi', 18000, '2014-02-20', 3, 15);

-- Part-A

-- 1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures

-- Department INSERT Procedure
CREATE PROCEDURE PR_Department_Insert
    @DepartmentID INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    INSERT INTO Department (DepartmentID, DepartmentName)
    VALUES (@DepartmentID, @DepartmentName);
END;

-- Department UPDATE Procedure
CREATE PROCEDURE PR_Department_Update
    @DepartmentID INT,
    @DepartmentName VARCHAR(100)
AS
BEGIN
    UPDATE Department
    SET DepartmentName = @DepartmentName
    WHERE DepartmentID = @DepartmentID;
END;

-- Department DELETE Procedure
CREATE PROCEDURE PR_Department_Delete
    @DepartmentID INT
AS
BEGIN
    DELETE FROM Department
    WHERE DepartmentID = @DepartmentID;
END;

-- Designation INSERT Procedure
CREATE PROCEDURE PR_Designation_Insert
    @DesignationID INT,
    @DesignationName VARCHAR(100)
AS
BEGIN
    INSERT INTO Designation (DesignationID, DesignationName)
    VALUES (@DesignationID, @DesignationName);
END;

-- Designation UPDATE Procedure
CREATE PROCEDURE PR_Designation_Update
    @DesignationID INT,
    @DesignationName VARCHAR(100)
AS
BEGIN
    UPDATE Designation
    SET DesignationName = @DesignationName
    WHERE DesignationID = @DesignationID;
END;

-- Designation DELETE Procedure
CREATE PROCEDURE PR_Designation_Delete
    @DesignationID INT
AS
BEGIN
    DELETE FROM Designation
    WHERE DesignationID = @DesignationID;
END;

-- Person INSERT Procedure
CREATE PROCEDURE PR_Person_Insert
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Salary DECIMAL(8, 2),
    @JoiningDate DATETIME,
    @DepartmentID INT = NULL,
    @DesignationID INT = NULL
AS
BEGIN
    INSERT INTO Person (FirstName, LastName, Salary, JoiningDate, DepartmentID, DesignationID)
    VALUES (@FirstName, @LastName, @Salary, @JoiningDate, @DepartmentID, @DesignationID);
END;

-- Person UPDATE Procedure
CREATE PROCEDURE PR_Person_Update
    @PersonID INT,
    @FirstName VARCHAR(100),
    @LastName VARCHAR(100),
    @Salary DECIMAL(8, 2),
    @JoiningDate DATETIME,
    @DepartmentID INT = NULL,
    @DesignationID INT = NULL
AS
BEGIN
    UPDATE Person
    SET FirstName = @FirstName, LastName = @LastName, Salary = @Salary, JoiningDate = @JoiningDate,
        DepartmentID = @DepartmentID, DesignationID = @DesignationID
    WHERE PersonID = @PersonID;
END;

-- Person DELETE Procedure
CREATE PROCEDURE PR_Person_Delete
    @PersonID INT
AS
BEGIN
    DELETE FROM Person
    WHERE PersonID = @PersonID;
END;

-- 2. SELECTBYPRIMARYKEY Procedures

-- Department SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Department_SelectByPrimaryKey
    @DepartmentID INT
AS
BEGIN
    SELECT * FROM Department
    WHERE DepartmentID = @DepartmentID;
END;

-- Designation SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Designation_SelectByPrimaryKey
    @DesignationID INT
AS
BEGIN
    SELECT * FROM Designation
    WHERE DesignationID = @DesignationID;
END;

-- Person SELECTBYPRIMARYKEY Procedure
CREATE PROCEDURE PR_Person_SelectByPrimaryKey
    @PersonID INT
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.PersonID = @PersonID;
END;

-- 3. Department, Designation & Person Table’s Select with Foreign Key Joins
-- Department SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Department_SelectAllWithDetails
AS
BEGIN
    SELECT * FROM Department
    END;

-- Designation SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Designation_SelectAllWithDetails
AS
BEGIN
    SELECT * FROM Designation
END;

-- Person SelectAllWithDetails Procedure
CREATE PROCEDURE PR_Person_SelectAllWithDetails
AS
BEGIN
    SELECT P.PersonID, P.FirstName, P.LastName, P.Salary, P.JoiningDate, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID;
END;



-- 4. Procedure that shows details of the first 3 persons
CREATE PROCEDURE PR_Person_ShowFirstThree
AS
BEGIN
    SELECT TOP 3 * FROM Person;
END;

-- Part-B

-- 5. Procedure that takes department name as input and returns all workers in that department
CREATE PROCEDURE PR_Person_GetWorkersByDepartment
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT P.*
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentName = @DepartmentName;
END;

-- 6. Procedure that takes department name & designation name as input and returns worker details
CREATE PROCEDURE PR_Person_GetWorkersByDeptAndDesig
    @DepartmentName VARCHAR(100),
    @DesignationName VARCHAR(100)
AS
BEGIN
    SELECT P.FirstName, P.Salary, P.JoiningDate, D.DepartmentName
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE D.DepartmentName = @DepartmentName AND G.DesignationName = @DesignationName;
END;

-- 7. Procedure that takes first name as input and displays worker details with department & designation
CREATE PROCEDURE PR_Person_GetWorkerDetailsByFirstName
    @FirstName VARCHAR(100)
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.FirstName = @FirstName;
END;

-- 8. Procedure that displays department-wise max, min & total salaries
CREATE PROCEDURE PR_Department_GetSalaryStats
AS
BEGIN
    SELECT D.DepartmentName, MAX(P.Salary) AS MaxSalary, MIN(P.Salary) AS MinSalary, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    GROUP BY D.DepartmentName;
END;

-- 9. Procedure that displays designation-wise average & total salaries
CREATE PROCEDURE PR_Designation_GetSalaryStats
AS
BEGIN
    SELECT G.DesignationName, AVG(P.Salary) AS AvgSalary, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Designation G ON P.DesignationID = G.DesignationID
    GROUP BY G.DesignationName;
END;

-- Part-C

-- 10. Procedure that accepts Department Name and returns Person Count
CREATE PROCEDURE PR_Department_GetPersonCount
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS PersonCount
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentName = @DepartmentName;
END;

-- 11. Procedure that takes a salary value as input and returns workers with salary > 25000
CREATE PROCEDURE PR_Person_GetWorkersWithSalaryAbove
    @Salary DECIMAL(8,2)
AS
BEGIN
    SELECT P.*, D.DepartmentName, G.DesignationName
    FROM Person P
    LEFT JOIN Department D ON P.DepartmentID = D.DepartmentID
    LEFT JOIN Designation G ON P.DesignationID = G.DesignationID
    WHERE P.Salary > @Salary;
END;

-- 12. Procedure to find the department with the highest total salary
CREATE PROCEDURE PR_Department_GetHighestTotalSalary
AS
BEGIN
    SELECT TOP 1 D.DepartmentName, SUM(P.Salary) AS TotalSalary
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    GROUP BY D.DepartmentName
    ORDER BY TotalSalary DESC;
END;

-- 13. Procedure that takes a designation name and returns workers under that designation who joined within the last 10 years
CREATE PROCEDURE PR_Designation_GetRecentWorkers
    @DesignationName VARCHAR(100)
AS
BEGIN
    SELECT P.*, D.DepartmentName
    FROM Person P
    JOIN Designation G ON P.DesignationID = G.DesignationID
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE G.DesignationName = @DesignationName AND P.JoiningDate >= DATEADD(YEAR, -10, GETDATE());
END;

-- 14. Procedure to list the number of workers in each department without a designation
CREATE PROCEDURE PR_Department_GetWorkersWithoutDesignation
AS
BEGIN
    SELECT D.DepartmentName, COUNT(P.PersonID) AS WorkerCount
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE P.DesignationID IS NULL
    GROUP BY D.DepartmentName;
END;

-- 15. Procedure to retrieve details of workers in departments where average salary is above 12000
CREATE PROCEDURE PR_Department_GetHighAvgSalaryWorkers
AS
BEGIN
    SELECT P.*, D.DepartmentName
    FROM Person P
    JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentID IN (
        SELECT DepartmentID
        FROM Person
        GROUP BY DepartmentID
        HAVING AVG(Salary) > 12000
    );
END;

--Lab-3

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    ManagerID INT NOT NULL,
    Location VARCHAR(100) NOT NULL
);

-- Create Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DoB DATETIME NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    HireDate DATETIME NOT NULL,
    DepartmentID INT NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);



-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert Dummy Data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES 
    (1, 'IT', 101, 'New York'),
    (2, 'HR', 102, 'San Francisco'),
    (3, 'Finance', 103, 'Los Angeles'),
    (4, 'Admin', 104, 'Chicago'),
    (5, 'Marketing', 105, 'Miami');

-- Insert Dummy Data into Employee
INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID, Salary)
VALUES 
    (101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
    (102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
    (103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
    (104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
    (105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);

-- Insert Dummy Data into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES 
    (201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
    (202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
    (203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
    (204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
    (205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);

-- Part A

-- 1. Retrieve EmployeeID, DoB, Gender, and HireDate based on First Name or Last Name
Alter PROCEDURE PR_Employee_GetByName
    @FirstName VARCHAR(100) = NULL,
    @LastName VARCHAR(100) = NULL
AS
BEGIN
    SELECT EmployeeID, DoB, Gender, HireDate
    FROM Employee
    WHERE (@FirstName IS NOT NULL AND FirstName = @FirstName)
        OR 
        (@LastName IS NOT NULL AND LastName = @LastName);
END;

-- 2. Retrieve employees list based on Department Name
CREATE PROCEDURE PR_Employee_GetByDepartmentName
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.DoB, e.Gender, e.HireDate, e.Salary
    FROM Employee e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE d.DepartmentName = @DepartmentName;
END;

PR_Employee_GetByDepartmentName 'IT'

-- 3. Retrieve project-related details based on Project Name & Department Name
CREATE PROCEDURE PR_Project_GetByProjectAndDepartment
    @ProjectName VARCHAR(100),
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT p.ProjectID, p.ProjectName, p.StartDate, p.EndDate, d.DepartmentName
    FROM Projects p
    JOIN Departments d ON p.DepartmentID = d.DepartmentID
    WHERE p.ProjectName = @ProjectName AND d.DepartmentName = @DepartmentName;
END;

PR_Project_GetByProjectAndDepartment 'Project Gamma','Finance'

-- 4. Retrieve employees list based on Salary within the specified range
ALTER PROCEDURE PR_Employee_GetBySalaryRange
    @MinSalaryRange INT,
	@MaxSalaryRange INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE Salary BETWEEN @MinSalaryRange AND @MaxSalaryRange; -- Adjust range as needed
END;

PR_Employee_GetBySalaryRange 80000,100000

-- 5. Retrieve employees who were hired on a specific date
CREATE PROCEDURE PR_Employee_GetByHireDate
    @HireDate DATETIME
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE HireDate = @HireDate;
END;
PR_Employee_GetByHireDate '2012-07-18'
-- Part B

-- 6. Retrieve employee details based on Gender’s first letter
CREATE PROCEDURE PR_Employee_GetByGenderLetter
    @GenderLetter CHAR(1)
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DoB, Gender, HireDate, Salary
    FROM Employee
    WHERE LEFT(Gender, 1) = @GenderLetter;
END;
PR_Employee_GetByGenderLetter 'F'

-- 7. Retrieve employee data based on First Name or Department Name
CREATE PROCEDURE PR_Employee_GetByFirstNameOrDepartment
    @FirstName VARCHAR(100) = NULL,
    @DepartmentName VARCHAR(100) = NULL
AS
BEGIN
    SELECT e.EmployeeID, e.FirstName, e.LastName, e.DoB, e.Gender, e.HireDate, e.Salary, d.DepartmentName
    FROM Employee e
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    WHERE 
	   (@FirstName IS NOT NULL AND e.FirstName = @FirstName)
        OR 
       (@DepartmentName IS NOT NULL AND d.DepartmentName = @DepartmentName);
END;

PR_Employee_GetByFirstNameOrDepartment @DepartmentName='Finance'

-- 8. Retrieve departments based on Location containing certain characters
CREATE PROCEDURE PR_Department_GetByLocation
    @Location VARCHAR(100)
AS
BEGIN
    SELECT DepartmentID, DepartmentName, ManagerID, Location
    FROM Departments
    WHERE Location LIKE '%' + @Location + '%';
END;

PR_Department_GetByLocation 'a'

-- Part C

-- 9. Retrieve project-related data based on From Date and To Date
CREATE PROCEDURE PR_Project_GetByDateRange
    @FromDate DATETIME,
    @ToDate DATETIME
AS
BEGIN
    SELECT ProjectID, ProjectName, StartDate, EndDate, DepartmentID
    FROM Projects
    WHERE StartDate BETWEEN @FromDate AND @ToDate;
END;

PR_Project_GetByDateRange '2022-01-01','2023-03-15'

-- 10. Retrieve project and department details based on Project Name and Location
CREATE PROCEDURE PR_Project_GetByProjectAndLocation
    @ProjectName VARCHAR(100),
    @Location VARCHAR(100)
AS
BEGIN
    SELECT p.ProjectName, d.DepartmentName, m.FirstName AS ManagerFirstName, m.LastName AS ManagerLastName,
           p.StartDate, p.EndDate
    FROM Projects p
    JOIN Departments d ON p.DepartmentID = d.DepartmentID
    JOIN Employee m ON d.ManagerID = m.EmployeeID
    WHERE p.ProjectName = @ProjectName AND d.Location = @Location;
END;

PR_Project_GetByProjectAndLocation 'Project Epsilon','Miami'

--LAB-4

-- Part A

-- 1. Function to Print "Hello World"
CREATE FUNCTION fn_PrintHelloWorld()
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 'Hello World'
END;

Select dbo.fn_PrintHelloWorld()

-- 2. Function for Addition of Two Numbers
CREATE FUNCTION fn_AddTwoNumbers(@Num1 INT, @Num2 INT)
RETURNS INT
AS
BEGIN
    RETURN @Num1 + @Num2
END;

Select dbo.fn_AddTwoNumbers(9,8)

-- 3. Function to Check if a Number is ODD or EVEN
CREATE FUNCTION fn_IsOddOrEven(@Number INT)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CASE 
               WHEN @Number % 2 = 0 THEN 'Even' 
               ELSE 'Odd' 
           END
END;

Select dbo.fn_IsOddOrEven(10)


-- 4. Function to Return a Table with Details of Persons with First Name Starting with "B"
CREATE FUNCTION fn_GetPersonsStartingWithB()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE FirstName LIKE 'B%'
);

Select *From dbo.fn_GetPersonsStartingWithB()
-- 5. Function to Return Unique First Names from Person Table
CREATE FUNCTION fn_GetUniqueFirstNames()
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT FirstName FROM Person
);

Select *From dbo.fn_GetUniqueFirstNames()


-- 6. Function to Print Numbers from 1 to N Using WHILE Loop
Alter FUNCTION fn_PrintNumbersToN(@N INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Result VARCHAR(MAX) = '';
    DECLARE @i INT = 1;

    WHILE @i <= @N
    BEGIN
        SET @Result = @Result + CAST(@i AS VARCHAR) + ' ';
        SET @i = @i + 1;
    END

    RETURN @Result; 
END;

Select dbo.fn_PrintNumbersToN(12)

-- 7. Function to Find Factorial of a Given Integer
CREATE FUNCTION fn_Factorial(@Number INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @Number
    BEGIN
        SET @Result = @Result * @i;
        SET @i = @i + 1;
    END

    RETURN @Result;
END;

Select dbo.fn_Factorial(5)

--Part-B

-- 8. Function to Compare Two Integers Using CASE Statement
CREATE FUNCTION fn_CompareIntegers(@Num1 INT, @Num2 INT)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE 
               WHEN @Num1 > @Num2 THEN 'First is greater' 
               WHEN @Num1 < @Num2 THEN 'Second is greater' 
               ELSE 'Both are equal' 
           END;
END;

Select dbo.fn_CompareIntegers(2,4)


-- 9. Function to Print Sum of Even Numbers Between 1 and 20
CREATE FUNCTION fn_SumOfEvens()
RETURNS INT
AS
BEGIN
    DECLARE @Sum INT = 0;
    DECLARE @i INT = 2;

    WHILE @i <= 20
    BEGIN
        SET @Sum = @Sum + @i;
        SET @i = @i + 2;
    END

    RETURN @Sum;
END;
SELECT dbo.fn_SumOfEvens(); 

-- 10. Function to Check if a Given String is a Palindrome
CREATE FUNCTION fn_IsPalindrome(@Text VARCHAR(100))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @ReversedText VARCHAR(100) = REVERSE(@Text);

    RETURN CASE 
               WHEN @Text = @ReversedText THEN 'Palindrome' 
               ELSE 'Not a Palindrome' 
           END;
END;
SELECT dbo.fn_IsPalindrome('madam'); 


-- Part-C

-- 11. Function to Check if a Given Number is Prime
CREATE FUNCTION fn_IsPrime(@Number INT)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @i INT = 2;

    IF @Number <= 1
        RETURN 'Not Prime';

    WHILE @i <= @Number/2
    BEGIN
        IF @Number % @i = 0
            RETURN 'Not Prime';

        SET @i = @i + 1;
    END

    RETURN 'Prime';
END;
SELECT dbo.fn_IsPrime(17);

-- 12. Function to Get Difference in Days Between Two Dates
CREATE FUNCTION fn_DateDifference(@StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate);
END;
SELECT dbo.fn_DateDifference('2023-01-01', '2023-01-31'); 

-- 13. Function to Get Total Days in a Given Month and Year
CREATE FUNCTION fn_TotalDaysInMonth(@Year INT, @Month INT)
RETURNS INT
AS
BEGIN
    RETURN DAY(EOMONTH(DATEFROMPARTS(@Year, @Month, 1)));
END;
SELECT dbo.fn_TotalDaysInMonth(2024, 2);

-- 14. Function to Get Details of Persons by Department ID
CREATE FUNCTION fn_GetPersonsByDepartment(@DepartmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE DepartmentID = @DepartmentID
);
SELECT * FROM fn_GetPersonsByDepartment(1); 

-- 15. Function to Get Details of Persons Who Joined After 1-Jan-1991
CREATE FUNCTION fn_GetPersonsJoinedAfter1991()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person
    WHERE JoiningDate > '1991-01-01'
);
SELECT * FROM fn_GetPersonsJoinedAfter1991();

--Lab-5
-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    Salary DECIMAL(8,2) NOT NULL,
    JoiningDate DATETIME NULL,
    City VARCHAR(100) NOT NULL,
    Age INT NULL,
    BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
    PLogID INT PRIMARY KEY IDENTITY(1,1),
    PersonID INT NOT NULL,
    PersonName VARCHAR(250) NOT NULL,
    Operation VARCHAR(50) NOT NULL,
    UpdateDate DATETIME NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES PersonInfo(PersonID) ON DELETE CASCADE
);



-- Part A

-- 1. Trigger to display "Record is Affected" when an INSERT, UPDATE, or DELETE operation occurs on PersonInfo.

CREATE TRIGGER tr_PersonInfo_RecordAffected
ON PersonInfo
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    PRINT 'Record is Affected.'
END;


-- 2. Trigger to log operations After (INSERT, UPDATE, DELETE) performed on PersonInfo into PersonLog table.

-- a. Trigger for Insert Operation

Create TRIGGER tr_Person_after_Insert
ON PersonInfo
AFTER INSERT
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);
    
    SELECT @PersonID = PersonID From inserted 
	Select @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE());
END;


-- b. Trigger for Update Operation

Create TRIGGER tr_Person_after_Update
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
	SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;


-- c. Trigger for Delete Operation

Create TRIGGER tr_Person_after_Delete
ON PersonInfo
AFTER DELETE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM deleted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE());
END;

-- 3. Trigger to log operations Intead Of (INSERT, UPDATE, DELETE) performed on PersonInfo into PersonLog table.

-- a. Trigger for Insert Operation

Create TRIGGER tr_Person_InsteadOf_Insert
ON PersonInfo
Instead of INSERT
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(100);
    
    SELECT @PersonID = PersonID From inserted 
	Select @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog (PersonID, PersonName, Operation, UpdateDate)
    VALUES (@PersonID, @PersonName, 'INSERT', GETDATE());
END;


-- b. Trigger for Update Operation

Create TRIGGER tr_Person_InsteadOf_Update
ON PersonInfo
Instead Of UPDATE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
	SELECT @PersonID = PersonID, @PersonName = PersonName FROM inserted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'UPDATE', GETDATE());
END;


-- c. Trigger for Delete Operation

Create TRIGGER tr_Person_InsteadOf_Delete
ON PersonInfo
Instead Of DELETE
AS
BEGIN
    DECLARE @PersonID INT;
    DECLARE @PersonName VARCHAR(50);
    
    SELECT @PersonID = PersonID, @PersonName = PersonName FROM deleted;
    
    INSERT INTO PersonLog
    VALUES (@PersonID, @PersonName, 'DELETE', GETDATE());
END;

-- 4. Trigger to convert PersonName to uppercase on INSERT into PersonInfo
CREATE TRIGGER tr_Person_NameUpper_Inset
ON PersonInfo
AFTER INSERT
AS
BEGIN
	DECLARE @Uname VARCHAR(50)
	DECLARE @PersonID int

	select @Uname=PersonName from inserted
	select @PersonID=PersonID from inserted

	UPDATE PersonInfo
	SET PersonName=Upper(@Uname)
	WHERE PersonID=@PersonID
END

Drop Trigger tr_PersonInfo_PreventDuplicateName
-- 5. Trigger to prevent duplicate PersonName entries in PersonInfo
CREATE TRIGGER tr_PersonInfo_PreventDuplicateName
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT 
        PersonID, 
        PersonName, 
        Salary, 
        JoiningDate, 
        City, 
        Age, 
        BirthDate
    FROM inserted
    WHERE PersonName NOT IN (SELECT PersonName FROM PersonInfo);
END;

-- 6. Trigger to prevent Age below 18 in PersonInfo
CREATE TRIGGER tr_PersonInfo_PreventUnderage
ON PersonInfo
INSTEAD OF INSERT
AS
BEGIN

    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT 
        PersonID, 
        PersonName, 
        Salary, 
        JoiningDate, 
        City, 
        Age, 
        BirthDate
    FROM inserted
    WHERE Age >= 18;
END;

-- Part B

-- 7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update that age in Person table.
CREATE TRIGGER tr_Person_CalculateAge
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET Age = DATEDIFF(YEAR, i.BirthDate, GETDATE())
    FROM PersonInfo p
    JOIN inserted i ON p.PersonID = i.PersonID
END;



-- 8. Create a Trigger to Limit Salary Decrease by a 10%.
CREATE TRIGGER tr_Person_LimitSalaryDecrease
ON PersonInfo
AFTER UPDATE
AS
BEGIN
    DECLARE @OldSalary DECIMAL(8,2), @NewSalary DECIMAL(8,2);
    
	SELECT @OldSalary = d.Salary, @NewSalary = i.Salary
    FROM deleted d
    JOIN inserted i ON d.PersonID = i.PersonID;

    IF @NewSalary < @OldSalary * 0.9
    BEGIN
        UPDATE PersonInfo
        SET Salary = @OldSalary
        WHERE PersonID IN (SELECT PersonID FROM inserted);
    END
END;



-- Part C

-- 9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL during an INSERT.
CREATE TRIGGER tr_Person_UpdateJoiningDate
ON PersonInfo
AFTER INSERT
AS
BEGIN
    UPDATE PersonInfo
    SET JoiningDate = GETDATE()
    FROM PersonInfo p
    JOIN inserted i ON p.PersonID = i.PersonID
    WHERE i.JoiningDate IS NULL;
END;


-- 10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints ‘Record deleted successfully from PersonLog’.
CREATE TRIGGER tr_PersonLog_Delete
ON PersonLog
AFTER DELETE
AS
BEGIN
    PRINT 'Record deleted successfully from PersonLog';
END;
--Lab-6
--  Create the Products table
CREATE TABLE Products (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

--  Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);

-- Part A

-- 1. Create a cursor Product_Cursor to fetch all the rows from the Products table.
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
    
DECLARE Product_Cursor CURSOR
FOR SELECT
    Product_id,
    Product_Name,
    Price
FROM
    Products;

OPEN Product_Cursor;

FETCH NEXT FROM Product_Cursor INTO
    @ProductID,
    @ProductName,
    @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @ProductID AS ProductID, @ProductName AS ProductName, @Price AS Price;
    FETCH NEXT FROM Product_Cursor INTO
        @ProductID,
        @ProductName,
        @Price;
END;

CLOSE Product_Cursor;
DEALLOCATE Product_Cursor;

-- 2. Create a cursor Product_Cursor_Fetch to fetch the records in the form of ProductID_ProductName.
DECLARE Product_Cursor_Fetch CURSOR
FOR SELECT 
    CAST(Product_id AS VARCHAR) + '_' + Product_Name AS ProductInfo
FROM 
    Products;

OPEN Product_Cursor_Fetch;

DECLARE @ProductInfo VARCHAR(300);

FETCH NEXT FROM Product_Cursor_Fetch INTO @ProductInfo;

WHILE @@FETCH_STATUS = 0
BEGIN
    Print @ProductInfo;
    FETCH NEXT FROM Product_Cursor_Fetch INTO @ProductInfo;
END;

CLOSE Product_Cursor_Fetch;
DEALLOCATE Product_Cursor_Fetch;

-- 3. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
DECLARE @ProductID INT
DECLARE Product_CursorDelete CURSOR
FOR SELECT
    Product_id
FROM 
    Products;

OPEN Product_CursorDelete;

FETCH NEXT FROM Product_CursorDelete INTO @ProductID;

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM Products WHERE Product_id = @ProductID;
    FETCH NEXT FROM Product_CursorDelete INTO @ProductID;
END;

CLOSE Product_CursorDelete;
DEALLOCATE Product_CursorDelete;



-- 4. Create a Cursor to Find and Display Products Above Price 30,000
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
DECLARE Product_Cursor_Above_30000 CURSOR
FOR SELECT 
    Product_id, 
    Product_Name, 
    Price 
FROM 
    Products 
WHERE 
    Price > 30000;

OPEN Product_Cursor_Above_30000;

FETCH NEXT FROM Product_Cursor_Above_30000 INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @ProductID AS ProductID, @ProductName AS ProductName, @Price AS Price;
    FETCH NEXT FROM Product_Cursor_Above_30000 INTO @ProductID, @ProductName, @Price;
END;

CLOSE Product_Cursor_Above_30000;
DEALLOCATE Product_Cursor_Above_30000;

-- Part B

-- 5. Create a cursor Product_CursorUpdate that retrieves all the data from the Products table and increases the price by 10%.
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
DECLARE Product_CursorUpdate CURSOR
FOR SELECT 
    Product_id, 
    Price 
FROM 
    Products;

OPEN Product_CursorUpdate;

FETCH NEXT FROM Product_CursorUpdate INTO @ProductID, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products
    SET Price = Price * 1.10
    WHERE Product_id = @ProductID;

    FETCH NEXT FROM Product_CursorUpdate INTO @ProductID, @Price;
END;

CLOSE Product_CursorUpdate;
DEALLOCATE Product_CursorUpdate;

Select * From Products

-- 6. Create a Cursor to Round the Price of Each Product to the Nearest Whole Number.
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
DECLARE Product_Cursor_Round CURSOR
FOR SELECT 
    Product_id, 
    Price 
FROM 
    Products;

OPEN Product_Cursor_Round;

FETCH NEXT FROM Product_Cursor_Round INTO @ProductID, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products
    SET Price = ROUND(Price, 0)
    WHERE Product_id = @ProductID;

    FETCH NEXT FROM Product_Cursor_Round INTO @ProductID, @Price;
END;

CLOSE Product_Cursor_Round;
DEALLOCATE Product_Cursor_Round;

-- Part C

-- 7. Create a NewProducts table
CREATE TABLE NewProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);
-- Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”.
DECLARE Product_Cursor_Insert_Laptop CURSOR
FOR SELECT 
    Product_id, 
    Product_Name, 
    Price 
FROM 
    Products 
WHERE 
    Product_Name = 'Laptop';

OPEN Product_Cursor_Insert_Laptop;

FETCH NEXT FROM Product_Cursor_Insert_Laptop INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NewProducts (Product_id, Product_Name, Price) 
    VALUES (@ProductID, @ProductName, @Price);
    
    FETCH NEXT FROM Product_Cursor_Insert_Laptop INTO @ProductID, @ProductName, @Price;
END;

CLOSE Product_Cursor_Insert_Laptop;
DEALLOCATE Product_Cursor_Insert_Laptop;

Select *From NewProducts

-- 8. Create an ArchivedProducts table
CREATE TABLE ArchivedProducts (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(250) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);
DECLARE
    @ProductID INT,
    @ProductName VARCHAR(250),
    @Price DECIMAL(10, 2);

-- Create a Cursor to Archive High-Price Products in a New Table
DECLARE Product_Cursor_Archive CURSOR
FOR SELECT 
    Product_id, 
    Product_Name, 
    Price 
FROM 
    Products 
WHERE 
    Price > 50000;

OPEN Product_Cursor_Archive;

FETCH NEXT FROM Product_Cursor_Archive INTO @ProductID, @ProductName, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO ArchivedProducts (Product_id, Product_Name, Price) 
    VALUES (@ProductID, @ProductName, @Price);

    DELETE FROM Products WHERE Product_id = @ProductID;

    FETCH NEXT FROM Product_Cursor_Archive INTO @ProductID, @ProductName, @Price;
END;

CLOSE Product_Cursor_Archive;
DEALLOCATE Product_Cursor_Archive;

Select *From ArchivedProducts	

--Lab-7
-- Create the Customers table
CREATE TABLE Customers (
    Customer_id INT PRIMARY KEY,                
    Customer_Name VARCHAR(250) NOT NULL,        
    Email VARCHAR(50) UNIQUE                    
);

-- Create the Orders table
CREATE TABLE Orders (
    Order_id INT PRIMARY KEY,                   
    Customer_id INT,                            
    Order_date DATE NOT NULL,                   
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id) 
);

--Part – A
--1.
--Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
    DECLARE @num1 INT = 10, @num2 INT = 0, @result INT;
    SET @result = @num1 / @num2;
END TRY
BEGIN CATCH
    PRINT 'Error occurs that is - Divide by zero error.';
END CATCH;

--2.
--Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
    DECLARE @strValue VARCHAR(10) = 'ABC';
    DECLARE @intValue INT;
    SET @intValue = CAST(@strValue AS INT);
END TRY
BEGIN CATCH
    PRINT 'Error: Unable to convert string to integer.';
END CATCH;

--3.
--Create a procedure that prints the sum of two numbers: take both numbers as integer & handle exception with all error functions if any one enters string value in numbers otherwise print result.
CREATE PROCEDURE PR_Calculation_SumWithErrorHandling
    @num1 NVARCHAR(50),
    @num2 NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        DECLARE @intNum1 INT = CAST(@num1 AS INT);
        DECLARE @intNum2 INT = CAST(@num2 AS INT);
        PRINT 'Sum is: ' + CAST(@intNum1 + @intNum2 AS VARCHAR(50));
    END TRY
    BEGIN CATCH
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH;
END;


--4.
--Handle a Primary Key Violation while inserting data into customers table and print the error details such as the error message, error number, severity, and state.
BEGIN TRY
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (1, 'John Doe', 'john@example.com'); -- Assuming ID 1 already exists
    END TRY
    BEGIN CATCH
        PRINT 'Primary Key Violation Error Occurred';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH;
--5.
--Throw custom exception using stored procedure which accepts Customer_id as input & that throws Error like no Customer_id is available in database.
CREATE PROCEDURE PR_Customers_CheckCustomerId
    @CustomerId INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @CustomerId)
    BEGIN
        THROW 50001, 'No Customer_id is available in database.', 1;
    END
    ELSE
    BEGIN
        PRINT 'Customer ID exists.';
    END
END;


--Part – B
--6.
--Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error message.
BEGIN TRY
    INSERT INTO Orders (Order_id, Customer_id, Order_date)
    VALUES (1, 999, GETDATE());
END TRY
BEGIN CATCH
    PRINT 'Foreign Key Violation Error Occurred: Invalid Customer_id.';
END CATCH;
--7.
--Throw custom exception that throws error if the data is invalid.
CREATE PROCEDURE PR_DataValidation_CheckPositiveValue
    @value INT
AS
BEGIN
    IF @value < 0
    BEGIN
        THROW 50002, 'Invalid data: Value cannot be negative.', 1;
    END
    ELSE
    BEGIN
        PRINT 'Data is valid.';
    END
END;

PR_DataValidation_CheckPositiveValue 2
--8.
--Create a Procedure to Update Customer’s Email with Error Handling
CREATE PROCEDURE PR_Customers_UpdateEmailWithErrorHandling
    @CustomerId INT,
    @NewEmail VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        UPDATE Customers
        SET Email = @NewEmail
        WHERE Customer_id = @CustomerId;
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while updating email.';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
    END CATCH;
END;
--Part – C
--9.
--Create a procedure which prints the error message that “The Customer_id is already taken. Try another one”.

CREATE PROCEDURE PR_Customers_InsertWithDuplicateCheck
    @CustomerId INT,
    @CustomerName VARCHAR(250),
    @Email VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Customers WHERE Customer_id = @CustomerId)
    BEGIN
        PRINT 'The Customer_id is already taken. Try another one.';
    END
    ELSE
    BEGIN
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@CustomerId, @CustomerName, @Email);

        PRINT 'Customer record inserted successfully.';
    END
END;
PR_Customers_InsertWithDuplicateCheck 2,'dgv','adfa'
--10.
--Handle Duplicate Email Insertion in Customers Table.

CREATE PROCEDURE PR_Customers_HandleDuplicateEmail
    @CustomerId INT,
    @CustomerName VARCHAR(250),
    @Email VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Customers WHERE Email = @Email)
    BEGIN
        PRINT 'The Email is already taken. Try another one.';
    END
    ELSE
    BEGIN
        INSERT INTO Customers (Customer_id, Customer_Name, Email)
        VALUES (@CustomerId, @CustomerName, @Email);

        PRINT 'Customer record inserted successfully.';
    END
END;
PR_Customers_HandleDuplicateEmail 4,'dgv','ad4fa'
















