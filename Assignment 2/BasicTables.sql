drop database if exists sales_catalog_management;
create database sales_catalog_management;
\c sales_catalog_management;


/* Commands for create table */
CREATE TABLE Sales_Company (
Name varchar(255),
ID varchar(10) not null,
PRIMARY KEY (ID)
);

CREATE TABLE Sales_Person (
Name varchar(255),
ID varchar(10) not null,
Gender varchar(1),
Date_of_Birth DATE,
Date_of_joining DATE,
Salary int,
Mgr_ID varchar(10),
Sales_Company_ID varchar(10),
PRIMARY KEY (ID)
);

CREATE TABLE Product_Catalog (
Name varchar(255),
ID varchar(10) not null,
Price float,
Available_QTY int,
Description TEXT,
Sales_Company_ID varchar(10),
Sales_Person_ID varchar(10),
Product_Warehouse_ID varchar(10),
Transportation_Company_ID varchar(10),
Warehouse_ID varchar(10),
PRIMARY KEY (ID)
);

CREATE TABLE Product_Warehouse (
Name varchar(255),
ID varchar(10) not null,
Location TEXT,
PRIMARY KEY (ID)
);

CREATE TABLE Product_Produced (
Product_Warehouse_ID varchar(10) not null,
Product_ID varchar(10),
PRIMARY KEY (Product_Warehouse_ID, Product_ID)
);

CREATE TABLE Warehouse_Location (
Name varchar(255),
ID varchar(10) not null,
Location TEXT,
PRIMARY KEY (ID)
);

CREATE TABLE Product_Stored (
Warehouse_ID varchar(10) not null,
Product_ID varchar(10),
PRIMARY KEY (Warehouse_ID, Product_ID)
);

CREATE TABLE ProductLine_Workers (
Name varchar(255),
ID varchar(10) not null,
Gender varchar(1),
Date_of_Birth DATE,
Date_of_joining DATE,
Salary int,
Mgr_ID varchar(10),
PRIMARY KEY (ID)
);

CREATE TABLE Transportation_Drivers (
Name varchar(255),
ID varchar(10) not null,
Gender varchar(1),
Date_of_Birth DATE,
Date_of_joining DATE,
Salary int,
Transportation_Company_ID varchar(10),
PRIMARY KEY (ID)
);

CREATE TABLE Transportation_Company (
Name varchar(255),
ID varchar(10) not null,
PRIMARY KEY (ID)
);

CREATE TABLE Product_Transported (
Transportation_Company_ID varchar not null,
Product_ID varchar not null,
PRIMARY KEY (Transportation_Company_ID, Product_ID)
);

CREATE TABLE Customers (
Name varchar(255),
ID varchar not null,
Gender varchar(1),
Date_of_Birth DATE,
Address TEXT,
PRIMARY KEY (ID)
);

CREATE TABLE Customer_Orders (
Customer_ID varchar,
ID varchar not null,
Payment_Method varchar(255),
Payment_Status TEXT,
Product_ID varchar,
Quantity int,
PRIMARY KEY (ID)
);

CREATE TABLE Product_Assigned_To (
Product_ID varchar(10) not null,
ProductLine_Workers_ID varchar(10) not null,
PRIMARY KEY (Product_ID, ProductLine_Workers_ID)
);

CREATE TABLE Order_Delivered_By (
Transportation_Driver_ID varchar not null,
Customer_Order_ID varchar not null,
PRIMARY KEY (Transportation_Driver_ID, Customer_Order_ID)
);


/* Commands for adding foreign key constraints */

ALTER TABLE Sales_Person ADD CONSTRAINT fk_cid FOREIGN KEY(Sales_Company_ID)
                  REFERENCES Sales_Company(ID);
ALTER TABLE Sales_Person ADD CONSTRAINT fk_mgrssn FOREIGN KEY(Mgr_ID)
                  REFERENCES Sales_Person(ID);

ALTER TABLE Product_Catalog ADD CONSTRAINT fk_cid FOREIGN KEY(Sales_Company_ID)
                  REFERENCES Sales_Company(ID);
ALTER TABLE Product_Catalog ADD CONSTRAINT fk_sid FOREIGN KEY(Sales_Person_ID)
                  REFERENCES Sales_Person(ID);
ALTER TABLE Product_Catalog ADD CONSTRAINT fk_pwid FOREIGN KEY(Product_Warehouse_ID)
                  REFERENCES Product_Warehouse(ID);
ALTER TABLE Product_Catalog ADD CONSTRAINT fk_tid FOREIGN KEY(Transportation_Company_ID)
                  REFERENCES Transportation_Company(ID);
ALTER TABLE Product_Catalog ADD CONSTRAINT fk_wid FOREIGN KEY(Warehouse_ID)
                  REFERENCES Warehouse_Location(ID);

ALTER TABLE Product_Produced ADD CONSTRAINT fk_pwid FOREIGN KEY(Product_Warehouse_ID)
                  REFERENCES Product_Warehouse(ID);

ALTER TABLE Product_Stored ADD CONSTRAINT fk_wid FOREIGN KEY(Warehouse_ID)
                  REFERENCES Warehouse_Location(ID);

ALTER TABLE Transportation_Drivers ADD CONSTRAINT fk_tid FOREIGN KEY(Transportation_Company_ID)
                  REFERENCES Transportation_Company(ID);

ALTER TABLE Product_Transported ADD CONSTRAINT fk_tid FOREIGN KEY(Transportation_Company_ID)
                  REFERENCES Transportation_Company(ID);

ALTER TABLE Customer_Orders ADD CONSTRAINT fk_pid FOREIGN KEY(Product_ID)
                  REFERENCES Product_Catalog(ID);
ALTER TABLE Customer_Orders ADD CONSTRAINT fk_cstid FOREIGN KEY(Customer_ID)
                  REFERENCES Customers(ID);

ALTER TABLE Product_Assigned_To ADD CONSTRAINT fk_pid FOREIGN KEY(Product_ID)
                  REFERENCES Product_Catalog(ID);
ALTER TABLE Product_Assigned_To ADD CONSTRAINT fk_prodlineid FOREIGN KEY(ProductLine_Workers_ID)
                  REFERENCES ProductLine_Workers(ID);

ALTER TABLE Order_Delivered_By ADD CONSTRAINT fk_did FOREIGN KEY(Transportation_Driver_ID)
                  REFERENCES Transportation_Drivers(ID);
ALTER TABLE Order_Delivered_By ADD CONSTRAINT coid FOREIGN KEY(Customer_Order_ID)
                  REFERENCES Customer_Orders(ID);



/* Commands for Inserting records in each table */

INSERT INTO Sales_Company VALUES('Amway', 'sc_1');
INSERT INTO Sales_Company VALUES('Reliance Digital', 'sc_2');
INSERT INTO Sales_Company VALUES('D-Mart', 'sc_3');

INSERT INTO Sales_Person VALUES('Augustine Ronaldo', 'sp_103', 'M', '1964-01-12', '2000-03-30', 50000, NULL, 'sc_1');
INSERT INTO Sales_Person VALUES('Amit Kumar', 'sp_101', 'M', '1984-10-12', '2020-03-31', 20000, 'sp_103', 'sc_1');
INSERT INTO Sales_Person VALUES('Rajeev Shukhla', 'sp_102', 'M', '1980-10-15', '2015-08-20', 30000, 'sp_103', 'sc_1');

INSERT INTO Sales_Person VALUES('Ravi Ash', 'sp_203', 'M', '1980-10-02', '2000-07-13', 35000, NULL, 'sc_2');
INSERT INTO Sales_Person VALUES('Anushka Viswas', 'sp_202', 'F', '1980-11-08', '2018-04-21', 25000, 'sp_203', 'sc_2');
INSERT INTO Sales_Person VALUES('Ravi Kumar', 'sp_201', 'M', '1977-11-12', '2020-03-31', 15000, 'sp_202', 'sc_2');

INSERT INTO Sales_Person VALUES('Amanni Usha', 'sp_302', 'F', '1960-01-07', '2010-04-01', 25000, NULL, 'sc_3');
INSERT INTO Sales_Person VALUES('Amit Kumar', 'sp_301', 'M', '1967-08-15', '2020-03-31', 10000, 'sp_302', 'sc_3');
INSERT INTO Sales_Person VALUES('Arnab Ladwani', 'sp_303', 'M', '1997-09-24', '2000-01-30', 15000, 'sp_302', 'sc_3');

INSERT INTO Product_Warehouse VALUES('Product Warehouse 1', 'Pware_1', '3rd floor Revannas');
INSERT INTO Product_Warehouse VALUES('Product Warehouse 2', 'Pware_2', 'Electronic City Ph-2');
INSERT INTO Product_Warehouse VALUES('Product Warehouse 3', 'Pware_3', 'Rajajinagar');

INSERT INTO Warehouse_Location VALUES('Professional Warehouse & Storage Services', 'ware_1', 'Mangamma Palya Rd');
INSERT INTO Warehouse_Location VALUES('North South Warehouse Storage', 'ware_2', '13th main, Begur main Rd');
INSERT INTO Warehouse_Location VALUES('SPOYL Warehouse', 'ware_3', 'Kudlu Gate');
INSERT INTO Warehouse_Location VALUES('Professional Logistics Warehouse & Storage', 'ware_4', 'shop no.34, 3rd floor, Mangamma Palya Rd');
INSERT INTO Warehouse_Location VALUES('CB Warehouse', 'ware_5', 'Mangamma Palya Rd');

INSERT INTO Transportation_Company VALUES('Company A', 'tc_1');
INSERT INTO Transportation_Company VALUES('Company B', 'tc_2');
INSERT INTO Transportation_Company VALUES('Company C', 'tc_3');

INSERT INTO Product_Catalog VALUES('Glister Toothpaste', 'pc_1', 200.0, 15, 'Multi-Action Toothpaste With Herbals', 'sc_1', 'sp_103', 'Pware_1', 'tc_1', 'ware_3');
INSERT INTO Product_Catalog VALUES('Hamam Soap', 'pc_2', 100.0, 12, 'Herbal Soap', 'sc_1', 'sp_101', 'Pware_1', 'tc_1', 'ware_1');
INSERT INTO Product_Catalog VALUES('Shampoo', 'pc_3', 150.0, 25, 'Hairfall Control With Conditioner', 'sc_1', 'sp_103', 'Pware_1', 'tc_2', 'ware_1');
INSERT INTO Product_Catalog VALUES('Air pods', 'pc_4', 799.0, 5, 'Wired', 'sc_2', 'sp_201', 'Pware_2', 'tc_1', 'ware_5');
INSERT INTO Product_Catalog VALUES('Nutrilite', 'pc_5', 1735.0, 25, 'Multivitamin and Multimineral Tablets', 'sc_1', 'sp_101', 'Pware_1', 'tc_1', 'ware_4');
INSERT INTO Product_Catalog VALUES('Duracell', 'pc_6', 75.0, 500, 'AAA batteries', 'sc_2', 'sp_203', 'Pware_2', 'tc_3', 'ware_3');
INSERT INTO Product_Catalog VALUES('Rice', 'pc_7', 102.0, 12, 'Red rice (1 qty = 2Kg Sac)','sc_3', 'sp_301', 'Pware_3', 'tc_2', 'ware_4');
INSERT INTO Product_Catalog VALUES('Cereal', 'pc_8', 200.0, 7, 'Breakfast Cereal Protein & Fiber', 'sc_3', 'sp_303', 'Pware_3', 'tc_3', 'ware_3');
INSERT INTO Product_Catalog VALUES('Laptop PC', 'pc_9', 74999.0, 8, 'HP Envy Ryzen 5', 'sc_2', 'sp_202', 'Pware_2', 'tc_2', 'ware_4');
INSERT INTO Product_Catalog VALUES('Apples', 'pc_10', 359.0, 9, 'Kashmiri Fresh Fruit Apples (1 qty = 2 apples)', 'sc_3', 'sp_303', 'Pware_3', 'tc_3', 'ware_5');

INSERT INTO Product_Transported VALUES('tc_1', 'pc_1');
INSERT INTO Product_Transported VALUES('tc_1', 'pc_2');
INSERT INTO Product_Transported VALUES('tc_1', 'pc_4');

INSERT INTO Product_Transported VALUES('tc_2', 'pc_7');
INSERT INTO Product_Transported VALUES('tc_2', 'pc_9');

INSERT INTO Product_Transported VALUES('tc_3', 'pc_6');
INSERT INTO Product_Transported VALUES('tc_3', 'pc_10');

INSERT INTO Product_Produced VALUES('Pware_1','pc_1');
INSERT INTO Product_Produced VALUES('Pware_1','pc_2');
INSERT INTO Product_Produced VALUES('Pware_1','pc_3');
INSERT INTO Product_Produced VALUES('Pware_2','pc_4'); 
INSERT INTO Product_Produced VALUES('Pware_1','pc_5');
INSERT INTO Product_Produced VALUES('Pware_2','pc_6');
INSERT INTO Product_Produced VALUES('Pware_3','pc_7');
INSERT INTO Product_Produced VALUES('Pware_3','pc_8');
INSERT INTO Product_Produced VALUES('Pware_2','pc_9');
INSERT INTO Product_Produced VALUES('Pware_3','pc_10');

INSERT INTO Product_Stored VALUES('ware_1','pc_1');
INSERT INTO Product_Stored VALUES('ware_1','pc_2');
INSERT INTO Product_Stored VALUES('ware_1','pc_3');
INSERT INTO Product_Stored VALUES('ware_5','pc_4');
INSERT INTO Product_Stored VALUES('ware_4','pc_5');
INSERT INTO Product_Stored VALUES('ware_3','pc_6');
INSERT INTO Product_Stored VALUES('ware_3','pc_7');
INSERT INTO Product_Stored VALUES('ware_3','pc_8');
INSERT INTO Product_Stored VALUES('ware_4','pc_9');
INSERT INTO Product_Stored VALUES('ware_5','pc_10');

INSERT INTO ProductLine_Workers VALUES('Koothrapalli', 'w_2','M', '1984-12-08', '2008-03-31', 80000, NULL);
INSERT INTO ProductLine_Workers VALUES('Rajesh S', 'w_1','M', '1984-10-08', '2021-03-31', 8000, 'w_2');
INSERT INTO ProductLine_Workers VALUES('Rakesh', 'w_3','M', '1980-12-15', '2011-07-14', 7500, 'w_2');
INSERT INTO ProductLine_Workers VALUES('Shyam Sundar', 'w_6','M', '1964-11-27', '2000-03-31', 6000000, NULL);
INSERT INTO ProductLine_Workers VALUES('Ferrha', 'w_5','F', '1994-09-07', '2020-03-17', 9000, 'w_6');
INSERT INTO ProductLine_Workers VALUES('Sheela Jhunjhunwala', 'w_4','F', '1988-05-09', '2017-09-27', 80000, 'w_5');
INSERT INTO ProductLine_Workers VALUES('Manjrekar', 'w_9','M', '1965-07-12', '1987-12-15', 2000, NULL);
INSERT INTO ProductLine_Workers VALUES('Alia', 'w_8','F', '1954-06-11', '1972-03-31', 100000, 'w_9');
INSERT INTO ProductLine_Workers VALUES('Shilpa', 'w_7','F', '1991-01-04', '2021-02-15', 12000, 'w_8');

INSERT INTO Transportation_Drivers VALUES('Kumar', 'td_1', 'M', '1984-10-12', '2020-03-31', 20000, 'tc_1');
INSERT INTO Transportation_Drivers VALUES('Shukhla', 'td_2', 'M', '1980-10-15', '2015-08-20', 30000, 'tc_2');
INSERT INTO Transportation_Drivers VALUES('Shreya', 'td_3', 'F', '1964-01-12', '2000-03-30', 50000, 'tc_1');
INSERT INTO Transportation_Drivers VALUES('Ravi', 'td_4', 'M', '1977-11-12', '2020-03-31', 15000, 'tc_3');
INSERT INTO Transportation_Drivers VALUES('Anushka', 'td_5', 'F', '1980-11-08', '2018-04-21', 25000, 'tc_2');
INSERT INTO Transportation_Drivers VALUES('Ash', 'td_6', 'M', '1980-10-02', '2000-07-13', 35000, 'tc_1');
INSERT INTO Transportation_Drivers VALUES('Amit Kumar', 'td_7', 'M', '1967-08-15', '2020-03-31', 10000, 'tc_1');
INSERT INTO Transportation_Drivers VALUES('Aman', 'td_8', 'M', '1960-01-07', '2010-04-01', 25000, 'tc_2');
INSERT INTO Transportation_Drivers VALUES('Arnab', 'td_9', 'M', '1997-09-24', '2000-01-30', 15000, 'tc_3');

INSERT INTO Product_Assigned_To VALUES('pc_1','w_1');
INSERT INTO Product_Assigned_To VALUES('pc_1','w_2');
INSERT INTO Product_Assigned_To VALUES('pc_2','w_1');
INSERT INTO Product_Assigned_To VALUES('pc_3','w_3');
INSERT INTO Product_Assigned_To VALUES('pc_3','w_2');
INSERT INTO Product_Assigned_To VALUES('pc_4','w_5');
INSERT INTO Product_Assigned_To VALUES('pc_5','w_2');
INSERT INTO Product_Assigned_To VALUES('pc_5','w_4');
INSERT INTO Product_Assigned_To VALUES('pc_6','w_7');
INSERT INTO Product_Assigned_To VALUES('pc_7','w_7');
INSERT INTO Product_Assigned_To VALUES('pc_8','w_5');
INSERT INTO Product_Assigned_To VALUES('pc_8','w_8');
INSERT INTO Product_Assigned_To VALUES('pc_9','w_5');
INSERT INTO Product_Assigned_To VALUES('pc_9','w_8');
INSERT INTO Product_Assigned_To VALUES('pc_10','w_2');
INSERT INTO Product_Assigned_To VALUES('pc_10','w_4');

INSERT INTO Customers (
Name ,ID ,Gender ,Date_of_Birth, Address
) VALUES('A','cus_1','M','2021-10-01','ban_1');
INSERT INTO Customers (
Name ,ID ,Gender ,Date_of_Birth, Address
) VALUES('B','cus_2','M','2021-10-02','ban_2');
INSERT INTO Customers (
Name ,ID ,Gender ,Date_of_Birth, Address
) VALUES('C','cus_3','M','2021-10-03','ban_3');
INSERT INTO Customers (
Name ,ID ,Gender ,Date_of_Birth, Address
) VALUES('D','cus_4','F','2021-10-04','ban_4');
INSERT INTO Customers (
Name ,ID ,Gender ,Date_of_Birth, Address
) VALUES('E','cus_5','F','2021-10-05','ban_5');


INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_1', 'co_1','cash','success','pc_1',1);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_1','co_2','cash','success','pc_2',1);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_2','co_3','cc','success','pc_1',2);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_3','co_4','cc','success','pc_4',2);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_3','co_5','cc','success','pc_2',1);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_3','co_6','cash','pending','pc_6',3);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_4','co_7','dc','success','pc_7',2);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_5','co_8','dc','success','pc_4',1);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_5','co_9','cash','success','pc_9',1);
INSERT INTO Customer_Orders (
Customer_ID ,ID ,Payment_Method ,Payment_Status ,Product_ID ,Quantity )
VALUES('cus_5','co_10','cash','success','pc_10',2);


INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_1','co_1');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_1','co_2');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_3','co_3');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_3','co_4');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_5','co_5');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_6','co_6');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,
Customer_Order_ID) VALUES('td_7','co_7');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_8','co_8');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_9','co_9');
INSERT INTO Order_Delivered_By (
Transportation_Driver_ID,Customer_Order_ID
) VALUES('td_9','co_10');
