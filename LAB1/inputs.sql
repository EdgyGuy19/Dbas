INSERT INTO Users (userID, fullName)
VALUES 
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie'),
    (4, 'Diana'),
    (5, 'Eve'),
    (6, 'Frank');

INSERT INTO Friendship (userID1, userID2)
VALUES
    (1,2)
    (1,3)
    (1,4)
    (1,5)

INSERT INTO Post(postID,userID,title,date,place,tags)
VALUES
    (1, 1, 'Exploring Crypto', '2023-10-01', 'Online', ARRAY['crypto']),
    (2, 2, 'Study Tips', '2023-10-02', 'University Library', ARRAY['studying', 'question']),
    (3, 3, 'Amazing Sunset', '2023-10-03', 'Beach', ARRAY['social']);

INSERT INTO ImagePost (postID, imageURL, filter)
VALUES
    (3, https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.hdqwalls.com%2Fwallpapers%2Fbeach-north-sea-sunset-8a.jpg&f=1&nofb=1&ipt=f69d7c148bf2c5ba7ca9ee5252452681183637833e8003a7dd98407fd0b5c579&ipo=images, 'Sunset')

INSERT INTO TextPost (postID, textContent)
VALUES
    (2, 'Does anyone have any good study tips?')

INSERT INTO VideoPost (postID, videoURL, codec)
VALUES
    (1, https://www.youtube.com/watch?v=dQw4w9WgXcQ, 'H.264')

INSERT INTO Like(postID, userID, timestamp)
VALUES
    (1, 2, '2023-10-01'), 
    (1, 3, '2023-10-01'), 
    (2, 1, '2023-10-02'), 
    (2, 3, '2023-10-02'),  
    (3, 1, '2023-10-03'),  
    (3, 2, '2023-10-03');

INSERT INTO Event(eventID, userID, title, place, startDate, endDate, attendees)
VALUES
    (1, 1, 'Crypto Conference', 'Online', '2023-10-01', '2023-10-02', ARRAY[1,2,3,4,5])

INSERT INTO Subscription(subscriptionID, userID, dateOfPayment, paymentMethod)
VALUES
    (1, 1, '2023-10-01', 'Credit Card'),
    (2, 2, '2023-10-01', 'PayPal'),
    (3, 3, '2023-10-01', 'Bitcoin');