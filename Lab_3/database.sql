create database if not EXISTS invoice;
use invoice;
create table IF NOT EXISTS inv_master(
    invID INT PRIMARY KEY,
    custName VARCHAR(100),
    invDate DATE,
    invTotal FLOAT
);

create table IF NOT EXISTS inv_detail(
    seq INT AUTO_INCREMENT PRIMARY KEY,
    invID INT,
    itemName VARCHAR(50),
    unitPrice INT,
    quantity INT,
    FOREIGN KEY (invID) 
        REFERENCES inv_master (invID) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE
);