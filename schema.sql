-- Theatre Booking Database
-- PostgreSQL schema, sample data and example queries.
-- Run with: psql -d <database> -f schema.sql

DROP TABLE IF EXISTS Booking, Show_Event_Student, Show_Event, Show, Course_Registration, Course, Class, Guest_Actor_Staff, Tutor_Staff, Student, Customer CASCADE;

-- ---------------------------------------------------------------
-- Ticketing
-- ---------------------------------------------------------------

CREATE TABLE Customer (
    Customer_ID     INT PRIMARY KEY,
    Name            VARCHAR(100) NOT NULL,
    Email_Address   VARCHAR(100) NOT NULL,
    Phone_Number    VARCHAR(25)  NOT NULL
);

CREATE TABLE Show (
    Show_ID         INT PRIMARY KEY,
    Show_Name       VARCHAR(110) NOT NULL,
    Description     TEXT,
    Venue           VARCHAR(100),
    Ticket_Price    NUMERIC(8,2) CHECK (Ticket_Price > 0),
    Start_Date      DATE NOT NULL,
    End_Date        DATE
);

CREATE TABLE Show_Event (
    Show_Event_ID   INT PRIMARY KEY,
    Show_Date_Time  TIMESTAMP NOT NULL,
    Show_ID         INT NOT NULL,
    FOREIGN KEY (Show_ID) REFERENCES Show(Show_ID)
);

CREATE TABLE Booking (
    Booking_No      INT PRIMARY KEY,
    Show_Event_ID   INT NOT NULL,
    Customer_ID     INT NOT NULL,
    Ticket_Quantity INT CHECK (Ticket_Quantity BETWEEN 1 AND 10),
    FOREIGN KEY (Show_Event_ID) REFERENCES Show_Event(Show_Event_ID),
    FOREIGN KEY (Customer_ID)   REFERENCES Customer(Customer_ID)
);

-- ---------------------------------------------------------------
-- Students, courses and classes
-- ---------------------------------------------------------------

CREATE TABLE Student (
    Student_ID          INT PRIMARY KEY,
    Name                VARCHAR(100) NOT NULL,
    DOB                 DATE NOT NULL,
    Email_Address       VARCHAR(75)  NOT NULL,
    Phone_Number        VARCHAR(25),
    Adjustments_Needed  TEXT
);

CREATE TABLE Show_Event_Student (
    Show_Event_ID   INT NOT NULL,
    Student_ID      INT NOT NULL,
    PRIMARY KEY (Show_Event_ID, Student_ID),
    FOREIGN KEY (Show_Event_ID) REFERENCES Show_Event(Show_Event_ID),
    FOREIGN KEY (Student_ID)    REFERENCES Student(Student_ID)
);

CREATE TABLE Course (
    Course_ID   INT PRIMARY KEY,
    Course_Title VARCHAR(90) NOT NULL,
    Level       VARCHAR(20) CHECK (Level IN ('Beginner', 'Intermediate', 'Advanced')),
    Start_Date  DATE NOT NULL,
    End_Date    DATE NOT NULL,
    Description TEXT NOT NULL,
    Cost        NUMERIC(10,2) CHECK (Cost > 0)
);

CREATE TABLE Course_Registration (
    Course_ID   INT NOT NULL,
    Student_ID  INT NOT NULL,
    Grade       VARCHAR(20) CHECK (Grade IN ('Pass', 'Merit', 'Distinction')),
    PRIMARY KEY (Course_ID, Student_ID),
    FOREIGN KEY (Course_ID)  REFERENCES Course(Course_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
);

-- ---------------------------------------------------------------
-- Staff
-- ---------------------------------------------------------------

CREATE TABLE Tutor_Staff (
    Staff_ID        INT PRIMARY KEY,
    Name            VARCHAR(90) NOT NULL,
    DOB             DATE NOT NULL,
    Email_Address   VARCHAR(100) NOT NULL,
    Phone_Number    VARCHAR(25),
    Start_Date      DATE NOT NULL,
    Leaving_Date    DATE,
    NI_Number       VARCHAR(25) UNIQUE NOT NULL,
    Work_Adjustments TEXT,
    Annual_Salary   NUMERIC(10,2) CHECK (Annual_Salary > 0),
    Position        VARCHAR(50)
);

CREATE TABLE Guest_Actor_Staff (
    Staff_ID        INT PRIMARY KEY,
    Name            VARCHAR(50) NOT NULL,
    DOB             DATE NOT NULL,
    Email_Address   VARCHAR(50) NOT NULL,
    Phone_Number    VARCHAR(25),
    Start_Date      DATE NOT NULL,
    Leaving_Date    DATE,
    NI_Number       VARCHAR(25) UNIQUE NOT NULL,
    Work_Adjustments TEXT,
    Amount_Per_Class NUMERIC(10,2) CHECK (Amount_Per_Class > 0),
    Agent_Number    VARCHAR(20)
);

CREATE TABLE Class (
    Class_ID            INT PRIMARY KEY,
    Class_No            INT NOT NULL,
    Class_Title         VARCHAR(110) NOT NULL,
    Class_Date_Time     TIMESTAMP NOT NULL,
    Duration            INT CHECK (Duration >= 1),
    Venue               VARCHAR(100),
    Course_ID           INT NOT NULL,
    Staff_ID_Tutor      INT NULL,
    Staff_ID_Guest_Actor INT,
    FOREIGN KEY (Course_ID)            REFERENCES Course(Course_ID),
    FOREIGN KEY (Staff_ID_Tutor)       REFERENCES Tutor_Staff(Staff_ID),
    FOREIGN KEY (Staff_ID_Guest_Actor) REFERENCES Guest_Actor_Staff(Staff_ID)
);

-- ---------------------------------------------------------------
-- Sample data (fictional)
-- ---------------------------------------------------------------

INSERT INTO Show VALUES (13, 'The Gingerbread Prince', 'A baker''s magical gingerbread creation comes to life.', 'Woolf Theatre', 15.00, '2025-11-15', '2025-12-23');
INSERT INTO Show VALUES (7,  'The Christmas Cobbler', 'A poor shoemaker discovers enchanted boots that make anyone who wears them dance uncontrollably.', 'Gulbenkian Theatre', 20.00, '2026-01-02', '2026-01-11');
INSERT INTO Show VALUES (8,  'Snowdrop and the Sparkling Star', NULL, 'Gulbenkian Theatre', 24.50, '2026-11-12', NULL);

INSERT INTO Customer VALUES (21745325, 'Henry Walsh',   'henry@mail.com',          '07910000143');
INSERT INTO Customer VALUES (15363468, 'Carlos Mendes', 'carlos@mail.com',         '07710000262');
INSERT INTO Customer VALUES (25443003, 'Daniela Cruz',  'd.cruz@somedomain.com',   '07910000900');

INSERT INTO Show_Event VALUES (1, '2025-11-15 13:00', 13);
INSERT INTO Show_Event VALUES (2, '2025-11-15 18:30', 13);
INSERT INTO Show_Event VALUES (3, '2025-11-16 18:30', 13);
INSERT INTO Show_Event VALUES (4, '2026-01-02 13:30', 7);
INSERT INTO Show_Event VALUES (5, '2026-01-04 18:30', 7);

INSERT INTO Booking VALUES (102, 2, 21745325, 2);
INSERT INTO Booking VALUES (103, 4, 21745325, 4);
INSERT INTO Booking VALUES (104, 2, 15363468, 3);
INSERT INTO Booking VALUES (105, 3, 15363468, 4);

INSERT INTO Student VALUES (24373896, 'Sofia Rossi', '2004-10-08', 's.rossi@somedomain.com', '07910000307', 'Extra time');
INSERT INTO Student VALUES (24808485, 'Luka Ivanov', '2002-05-27', 'luka@mail.com', '0771-0000435', NULL);
INSERT INTO Student VALUES (24131268, 'Joe Bloggs', '2004-10-08', 'joe@mail.com', '07810000066', 'Dyslexia support');
INSERT INTO Student VALUES (24963990, 'Aisha Karim', '2004-10-08', 'aisha54@outlook.com', '0771 0047196', NULL);

INSERT INTO Show_Event_Student VALUES (1, 24808485);
INSERT INTO Show_Event_Student VALUES (2, 24808485);
INSERT INTO Show_Event_Student VALUES (3, 24808485);
INSERT INTO Show_Event_Student VALUES (2, 24131268);
INSERT INTO Show_Event_Student VALUES (4, 24131268);

INSERT INTO Tutor_Staff VALUES (17912380, 'Lucia Fernández', '1979-05-15', 'l.fernandez@dramacorner.ac.uk', '07733 112244', '2014-02-01', NULL, 'ST182736J', NULL, 41000.00, 'Musical Theatre Tutor');
INSERT INTO Tutor_Staff VALUES (15522422, 'Hiroshi Tanaka', '1980-08-22', 'h.tanaka@dramacorner.ac.uk', '07966889900', '2017-10-10', NULL, 'QR564738H', 'Does not work Mondays', 40500.00, 'Movement and Physical Theatre Tutor');

INSERT INTO Guest_Actor_Staff VALUES (17912381, 'Amelia Hart',   '1983-12-01', 'a.hart@guestactor.com',  '+44 07765334422', '2018-07-14', NULL, 'NP192837G', NULL, 720.00, '+44 02077890123');
INSERT INTO Guest_Actor_Staff VALUES (15522423, 'Kwesi Agyeman', '1981-08-07', 'k.agyeman@guestactor.com', '07899 223311', '2016-06-01', NULL, 'MR568438H', 'Mornings only', 620.55, '0207 890 1234');

INSERT INTO Course VALUES (1, 'Fundamentals of Acting Technique', 'Beginner', '2025-09-20', '2025-11-04', 'Foundational principles of stage performance, including voice, diction, physical awareness and emotional authenticity.', 1550.00);
INSERT INTO Course VALUES (2, 'Advanced Acting for the Camera', 'Advanced', '2025-10-27', '2025-12-23', 'Performance techniques for film and television, emphasising subtlety, continuity and emotional truth in close-up work.', 1750.00);

INSERT INTO Course_Registration VALUES (1, 24373896, 'Merit');
INSERT INTO Course_Registration VALUES (2, 24373896, NULL);
INSERT INTO Course_Registration VALUES (1, 24131268, 'Distinction');
INSERT INTO Course_Registration VALUES (2, 24131268, NULL);

INSERT INTO Class VALUES (1001, 1, 'Introduction to Stagecraft and Actor''s Presence', '2025-10-21 10:00', 2, 'Theatre 1', 1, 17912380, 15522423);
INSERT INTO Class VALUES (1002, 2, 'Breath Control and Vocal Projection', '2025-10-28 12:00', 2, 'Theatre 2', 1, 17912380, 15522423);
INSERT INTO Class VALUES (1003, 1, 'Global Inspirations', '2025-10-27 12:00', 2, 'Theatre 1', 2, 15522422, NULL);

-- ---------------------------------------------------------------
-- Example queries
-- ---------------------------------------------------------------

-- Classes held in Theatre 1, with their course title
SELECT c.Course_Title, cl.Class_Title, cl.Duration, cl.Class_Date_Time
FROM Class cl
JOIN Course c ON cl.Course_ID = c.Course_ID
WHERE cl.Venue = 'Theatre 1';

-- Total tickets booked by each customer
SELECT cu.Name, cu.Email_Address, SUM(b.Ticket_Quantity) AS Total_Tickets
FROM Booking b
JOIN Customer cu ON b.Customer_ID = cu.Customer_ID
GROUP BY cu.Name, cu.Email_Address;

-- Staff with recorded work adjustments, across both staff tables
SELECT Name, Phone_Number, Work_Adjustments
FROM Tutor_Staff
WHERE Work_Adjustments IS NOT NULL
UNION
SELECT Name, Phone_Number, Work_Adjustments
FROM Guest_Actor_Staff
WHERE Work_Adjustments IS NOT NULL;

-- Students registered on a course with classes from a given date
SELECT s.Name, s.Email_Address, c.Course_Title, cl.Class_Title, cl.Class_Date_Time
FROM Student s
JOIN Course_Registration cr ON s.Student_ID = cr.Student_ID
JOIN Course c ON c.Course_ID = cr.Course_ID
JOIN Class cl ON cl.Course_ID = c.Course_ID
WHERE s.Email_Address LIKE '%@mail.com'
  AND cl.Class_Date_Time >= '2025-10-25';
