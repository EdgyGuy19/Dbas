CREATE TABLE account(
    accountNumber INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    joined DATE NOT NULL,
    expires DATE NOT NULL,
    paid DATE,
    bill INT NOT NULL
);
