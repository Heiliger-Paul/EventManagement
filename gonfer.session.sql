select * from conferenceevent;


-- DELETE FROM Event_Hall  
-- WHERE EventID IN (SELECT EventID FROM (SELECT EventID FROM ConferenceEvent WHERE EventID = (SELECT EventID FROM ConferenceEvent WHERE Name = 'bob')) 
-- AS subquery);