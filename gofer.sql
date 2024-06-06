CREATE DATABASE gonfer;
USE gonfer;

CREATE TABLE ConferenceHall (
    HallID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Size INT NOT NULL
);

CREATE TABLE Owner (
    OwnerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Experience INT NOT NULL,
    Age INT NOT NULL
);

CREATE TABLE AdminEmployee (
    AdminEmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE ConferenceEvent (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Type VARCHAR(255) NOT NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    NumberOfAttendees INT NOT NULL,
    OwnerID INT,
    AdminEmployeeID INT,
    FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID),
    FOREIGN KEY (AdminEmployeeID) REFERENCES AdminEmployee(AdminEmployeeID)
);

CREATE TABLE Event_Hall (
    EventID INT,
    HallID INT,
    PRIMARY KEY (EventID, HallID),
    FOREIGN KEY (EventID) REFERENCES ConferenceEvent(EventID),
    FOREIGN KEY (HallID) REFERENCES ConferenceHall(HallID)
);

CREATE TABLE Event_Employee (
    EventID INT,
    EmployeeID INT,
    PRIMARY KEY (EventID, EmployeeID),
    FOREIGN KEY (EventID) REFERENCES ConferenceEvent(EventID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);


-- Inserting records into ConferenceHall
INSERT INTO ConferenceHall (Name, Price, Size) VALUES
('Small meeting hall', 500.00, 100),
('Small auditorium', 750.00, 150),
('Medium sized auditorium', 1000.00, 200),
('Large auditorium', 1250.00, 250),
('X large auditorium', 1500.00, 300);

-- Inserting records into Owner
INSERT INTO Owner (FullName, Email, Phone, Password) VALUES
('John Doe', 'john.doe@example.com', '555-1234', 'password1'),
('Jane Smith', 'jane.smith@example.com', '555-5678', 'password2'),
('Alice Johnson', 'alice.johnson@example.com', '555-8765', 'password3'),
('Bob Brown', 'bob.brown@example.com', '555-4321', 'password4'),
('Charlie Davis', 'charlie.davis@example.com', '555-6789', 'password5');

-- Inserting records into AdminEmployee
INSERT INTO AdminEmployee (FullName, Email, Password) VALUES
('Admin User', 'admin@example.com', 'adminpassword');

-- Inserting records into Employee
INSERT INTO Employee (Name, Experience, Age) VALUES
('Emily Evans', 5, 30),
('Daniel Lee', 10, 40),
('Sophia Turner', 3, 25);


-- ##################################### sign up
INSERT INTO Owner (FullName, Email, Phone, Password) VALUES ('kidus', 'kidus@gmail.com', '009999000', 'kidus8998');

-- ##################################### sign in
SELECT OwnerID FROM Owner WHERE Email = 'kidus@gmail.com' AND Password = 'kidus8998';

-- ##################################### retrive account information (my account)
SELECT FullName, Email, Phone
FROM Owner
WHERE Email = 'kidus@gmail.com';

-- ##################################### Create an event and insert its details (reservation form)
INSERT INTO ConferenceEvent (
    Name, Type, EventDate, StartTime, EndTime, NumberOfAttendees, OwnerID, AdminEmployeeID)
VALUES ('zim', 'birthday', '2024-07-06', '10:45', '12:45', 500,
       (SELECT OwnerID FROM Owner WHERE Email = 'kidus@gmail.com'),
       (SELECT AdminEmployeeID FROM AdminEmployee LIMIT 1));
-- ******************************** Link Event to Conference Hall
INSERT INTO Event_Hall (EventID, HallID)
VALUES ((SELECT EventID FROM ConferenceEvent WHERE Name = 'zim' AND OwnerID = (SELECT OwnerID FROM Owner WHERE Email = 'kidus@gmail.com') 
        ORDER BY EventID DESC LIMIT 1), 
        (SELECT HallID FROM ConferenceHall WHERE Name = 'Hall A'));


-- ##################################### Admin assigns employee to an event (adimn actions)
INSERT INTO Event_Employee (EventID, EmployeeID) 
VALUES ((SELECT EventID FROM ConferenceEvent WHERE Name = 'zim' AND OwnerID = (SELECT OwnerID FROM Owner WHERE Email = 'kidus@gmail.com') 
    ORDER BY EventID DESC LIMIT 1),
    (SELECT EmployeeID FROM Employee WHERE Name = 'Daniel Lee'));

-- ##################################### display all the event information (event list)
SELECT 
    ce.EventID,
    ce.Name AS EventName, 
    ce.Type AS EventType, 
    ce.EventDate, 
    ce.StartTime, 
    ce.EndTime, 
    ce.NumberOfAttendees, 
    ch.Name AS ConferenceHall, 
    ch.Price AS HallPrice, 
    ch.Size AS HallSize,
    e.Name AS EventManager
FROM ConferenceEvent ce
JOIN Event_Hall eh ON ce.EventID = eh.EventID
JOIN ConferenceHall ch ON eh.HallID = ch.HallID
LEFT JOIN Event_Employee ee ON ce.EventID = ee.EventID
LEFT JOIN Employee e ON ee.EmployeeID = e.EmployeeID
WHERE ce.OwnerID = (SELECT OwnerID FROM Owner WHERE Email = 'kidus@gmail.com');

-- ##################################### delete employee
DELETE FROM employee WHERE EmployeeID = 3;

-- ##################################### Update specific cells for an employee
UPDATE Employee SET 
    Name = 'bob dwal',  -- text
    Experience = 10,    -- number
    Age = 25            -- number
WHERE EmployeeID = 1;

-- ##################################### delete hall
DELETE FROM conferencehall WHERE HallID = 4;

-- ##################################### Update specific cells for a hall
UPDATE ConferenceHall SET 
    Name = 'Auditorium', 
    Price = 2000, 
    Size = 500 
WHERE HallID = 5;

-- ##################################### delete the event
DELETE FROM Event_Hall  
WHERE EventID IN (SELECT EventID FROM (SELECT EventID FROM ConferenceEvent WHERE EventID = (SELECT EventID FROM ConferenceEvent WHERE Name = 'bob')) 
AS subquery);
-- ##################################### update the event
UPDATE Event_Hall AS eh
JOIN (
    SELECT eh.EventID, ce.Name AS EventName
    FROM Event_Hall AS eh
    JOIN ConferenceEvent AS ce ON eh.EventID = ce.EventID
    WHERE ce.Name = 'zim'
) AS subquery ON eh.EventID = subquery.EventID
JOIN ConferenceEvent AS ce ON eh.EventID = ce.EventID
JOIN ConferenceHall AS ch ON eh.HallID = ch.HallID
SET 
    ce.Name = 'New_Event_Name',
    ce.Type = 'New_Event_Type',
    ce.EventDate = '2024-07-06',
    ce.StartTime = '10:45',
    ce.EndTime = '12:34',
    ce.NumberOfAttendees = 10,
    ch.Name = 'Hall C';

      
-- ##################################### Debugger
select * from conferencehall;
select * from adminemployee;
select * from conferenceevent;
select * from employee;
select * from event_employee;
select * from event_hall;
select * from owner; 