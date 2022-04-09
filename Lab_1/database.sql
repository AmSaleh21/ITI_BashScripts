CREATE DATABASE IF NOT EXISTS BashLabOne;
USE BashLabOne;

CREATE TABLE Invoices (
    inv_id INT PRIMARY KEY,
    inv_date DATE,
    cust_name VARCHAR(15),
    inv_total INT
);

CREATE TABLE Invoices_details(
    seq INT  PRIMARY KEY,
    item_name VARCHAR(15),
    item_quantity INT,
    item_unit_price INT,
    inv_id INT,
    FOREIGN KEY (inv_id) REFERENCES Invoices(inv_id)
)