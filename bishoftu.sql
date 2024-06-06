CREATE DATABASE bishoftu;
USE bishoftu;

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
    Status VARCHAR(10) DEFAULT 'Awaited',
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
('Small meeting hall', 700.00, 100),
('Small auditorium', 1000.00, 150),
('Medium sized auditorium', 2000.00, 300),
('Large auditorium', 3000.00, 200),
('X large auditorium', 5000.00, 1000);

-- Inserting records into Owner
INSERT INTO Owner (FullName, Email, Phone, Password) VALUES
('Oumer Wassu', 'Oumer.was@example.com', '555-1234', 'password1'),
('Biruk Mekonen', 'Biruk.mek@example.com', '555-5678', 'password2'),
('Abdulahi Seid', 'Abdulahi.sei@example.com', '555-8765', 'password3'),
('Kidus kidus', 'Kidus.kid@example.com', '555-4321', 'password4'),
('Bereket bereket', 'Bereket.ber@example.com', '555-6789', 'password5'),
('Naol naol', 'Naol.nao@example.com', '555-6789', 'password6');

-- Inserting records into AdminEmployee
INSERT INTO AdminEmployee (FullName, Email, Password) VALUES
('Admin', 'admin@example.com', 'adminkp');

-- Inserting records into Employee
INSERT INTO Employee (Name, Experience, Age) VALUES
('Naol Abebe', 5, 30),
('Bereket Samson', 10, 40),
('Kidus Paulos', 3, 25);








                    --  hey here are all the commands neede for each function that need QUERY

                    
-- -- Function: admin()
-- -- Fetch events and employees:
-- SELECT ce.EventID, ce.Name AS EventName, o.Email AS OwnerEmail,
--        CASE WHEN e.Name IS NOT NULL THEN 'Assigned' ELSE 'Awaited' END AS Status
-- FROM ConferenceEvent ce
-- JOIN Owner o ON ce.OwnerID = o.OwnerID
-- LEFT JOIN Event_Employee ee ON ce.EventID = ee.EventID
-- LEFT JOIN Employee e ON ee.EmployeeID = e.EmployeeID;
-- SELECT EmployeeID, Name FROM Employee;



-- -- Function: event_list()
-- -- Fetch events owned by the logged-in user:
-- SELECT ce.EventID, ce.Name AS EventName, ce.Type AS EventType, ce.EventDate, ce.StartTime, ce.EndTime,
--        ce.NumberOfAttendees, ch.Name AS ConferenceHall, ch.Price AS HallPrice, ch.Size AS HallSize,
--        e.Name AS EventManager
-- FROM ConferenceEvent ce
-- JOIN Event_Hall eh ON ce.EventID = eh.EventID
-- JOIN ConferenceHall ch ON eh.HallID = ch.HallID
-- LEFT JOIN Event_Employee ee ON ce.EventID = ee.EventID
-- LEFT JOIN Employee e ON ee.EmployeeID = e.EmployeeID
-- WHERE ce.OwnerID = %s;



-- -- Function: submit_event()
-- -- Insert a new conference event and associate it with a conference hall:
-- INSERT INTO ConferenceEvent (Name, Type, EventDate, StartTime, EndTime, NumberOfAttendees, OwnerID, AdminEmployeeID)
-- VALUES (%s, %s, %s, %s, %s, %s, %s, (SELECT AdminEmployeeID FROM AdminEmployee LIMIT 1));
-- INSERT INTO Event_Hall (EventID, HallID)
-- VALUES ((SELECT LAST_INSERT_ID()), (SELECT HallID FROM ConferenceHall WHERE Name = %s));



-- -- Function: assign_employee()
-- -- Assign an employee to an event:
-- INSERT INTO Event_Employee (EventID, EmployeeID) VALUES (%s, %s);



-- -- Function: hall_list()
-- -- Fetch all conference halls:
-- SELECT * FROM ConferenceHall;



-- -- Function: employee_list()
-- -- Fetch all employees:
-- SELECT * FROM Employee;



-- -- Function: delete_event(event_id)
-- -- Delete an event and associated records:
-- DELETE FROM Event_Employee WHERE EventID = %s;
-- DELETE FROM Event_Hall WHERE EventID = %s;
-- DELETE FROM ConferenceEvent WHERE EventID = %s;



-- -- Function: update_event(event_id)
-- -- Update an existing event:
-- UPDATE ConferenceEvent 
-- SET Name = %s, Type = %s, EventDate = %s, StartTime = %s, EndTime = %s, NumberOfAttendees = %s
-- WHERE EventID = %s;