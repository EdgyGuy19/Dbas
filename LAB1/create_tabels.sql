CREATE TABLE Users (
    userID INT PRIMARY KEY,
    fullName TEXT NOT NULL
);

CREATE TABLE Post (
    postID INT PRIMARY KEY,
    userID INT REFERENCES Users(userID),
    title TEXT NOT NULL,
    date DATE NOT NULL,
    place TEXT,
    tags TEXT[] CONSTRAINT check_tags CHECK (tags <@ ARRAY['crypto', 'studying', 'question', 'social'])
);

-- ImagePost Table (inherits from Post)
CREATE TABLE ImagePost (
    postID INT PRIMARY KEY,
    imageURL TEXT NOT NULL,
    filter TEXT,
    FOREIGN KEY (postID) REFERENCES Post(postID)
);

-- TextPost Table (inherits from Post)
CREATE TABLE TextPost (
    postID INT PRIMARY KEY,
    textContent TEXT NOT NULL,
    FOREIGN KEY (postID) REFERENCES Post(postID)
);

-- VideoPost Table (inherits from Post)
CREATE TABLE VideoPost (
    postID INT PRIMARY KEY,
    videoURL TEXT NOT NULL,
    codec TEXT NOT NULL,
    FOREIGN KEY (postID) REFERENCES Post(postID)
);

CREATE TABLE Likes (
    postID INT NOT NULL,
    userID INT NOT NULL,
    timestamp DATE NOT NULL,
    FOREIGN KEY (postID) REFERENCES Post(postID),
    FOREIGN KEY (userID) REFERENCES Users(userID),
    PRIMARY KEY (postID, userID)
);

-- Friendship Table (symmetric relationship)
CREATE TABLE Friendship (
    userID1 INT NOT NULL REFERENCES Users(userID),
    userID2 INT NOT NULL REFERENCES Users(userID),
    PRIMARY KEY (userID1, userID2),
    CONSTRAINT check_different_users CHECK (userID1 != userID2)
);

CREATE TABLE Event (
    eventID INT PRIMARY KEY REFERENCES Users(userID),
    userID INT NOT NULL,
    title TEXT NOT NULL,
    place TEXT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    attendees INT[],
    CHECK (startDate <= endDate)
);

CREATE TABLE Subscription (
    subscriptionID INT PRIMARY KEY,
    userID INT NOT NULL REFERENCES Users(userID),
    dateOfPayment DATE NOT NULL,
    paymentMethod TEXT CHECK (paymentMethod <@ ARRAY['Klarna', 'Swish', 'Card', 'Bitcoin'])
);
