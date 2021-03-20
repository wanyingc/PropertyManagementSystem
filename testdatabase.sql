drop table if exists Landlord;
drop table if exists Property;
drop table if exists MonthlyExpenses;
drop table if exists Tenant;
drop table if exists Individual;
drop table if exists Company;
drop table if exists Rents;
drop table if exists Retail;
drop table if exists Office;
drop table if exists Multifamily;
drop table if exists Spaces;

CREATE TABLE Landlord (
landlordID    INTEGER,
firstName     VARCHAR(50),
lastName      VARCHAR(50),

PRIMARY KEY (landlordID)
);
CREATE TABLE Property (
propertyID	   INTEGER,
province		   VARCHAR(50) NOT NULL,
street			VARCHAR(50) NOT NULL,
postcode		   CHAR(6) NOT NULL,
price			   DECIMAL(10,2),
monthlyIncome	DECIMAL(20,2),
lotSize		   INTEGER,
buildDate		YEAR,
landlordID		INTEGER,

PRIMARY KEY (propertyID)
);
CREATE TABLE MonthlyExpenses (
propertyID	INTEGER NOT NULL,
date		   DATE,
landID		INTEGER NOT NULL,
utilityBill	DECIMAL(10,2),
propertyTax	DECIMAL(10,2),
MaintNRepairs	DECIMAL(10,2),

PRIMARY KEY (propertyID, date),
FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
FOREIGN KEY (landID) REFERENCES Landlord(landlordID)
);

CREATE TABLE Tenant (
tenantID		   INTEGER,
monthlyRent	   DECIMAL(10,2),

PRIMARY KEY (tenantID)
);
CREATE TABLE Individual (
tenantID	   INTEGER NOT NULL,
firstName	VARCHAR(50) NOT NULL,
lastName	   VARCHAR(50) NOT NULL,

PRIMARY KEY (tenantID),
FOREIGN KEY (tenantID) REFERENCES Tenant(tenantID)
);
CREATE TABLE Company (
tenantID		INTEGER NOT NULL,
companyName	VARCHAR(50) NOT NULL,

PRIMARY KEY (tenantID),
FOREIGN KEY (tenantID) REFERENCES Tenant(tenantID)
);
CREATE TABLE Rents (
propertyID		INTEGER NOT NULL,
tenantID		   INTEGER NOT NULL,

PRIMARY KEY (propertyID, tenantID),
FOREIGN KEY (tenantID) REFERENCES Tenant(tenantID),
FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
);
CREATE TABLE Retail (
propertyID	INTEGER NOT NULL,

PRIMARY KEY (propertyID),
FOREIGN KEY (propertyID) REFERENCES Property(propertyID)
);
CREATE TABLE Office (
propertyID	INTEGER NOT NULL,
furnished	VARCHAR(50) NOT NULL,

PRIMARY KEY (PropertyID),
FOREIGN KEY (PropertyID) REFERENCES Property(propertyID)
);
CREATE TABLE Multifamily (
propertyID	INTEGER NOT NULL,
spaces	   VARCHAR(50) NOT NULL,
furnished	VARCHAR(50) NOT NULL,

PRIMARY KEY (propertyID),
FOREIGN KEY (PropertyID) REFERENCES Property(propertyID)
);
CREATE TABLE Spaces(
propertyID	INTEGER NOT NULL,
space		   INTEGER NOT NULL,

PRIMARY KEY (propertyID),
FOREIGN KEY (propertyID) REFERENCES Multifamily(propertyID)
);


-- INSERT LANDLORDS --
INSERT INTO Landlord (firstName, lastName) VALUES ('John', 'Jackson');
INSERT INTO Landlord (firstName, lastName) VALUES ('Jeff','Smith');
INSERT INTO Landlord (firstName, lastName) VALUES ('Ava','Romero');
INSERT INTO Landlord (firstName, lastName) VALUES ('Paul','Henderson');
INSERT INTO Landlord (firstName, lastName) VALUES ('William','Anderson');
INSERT INTO Landlord (firstName, lastName) VALUES ('Thomas','Clark');


-- INSERT PROPERTIES --
INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('British Columbia','850  Haaglund Rd','V0H1M0','123456','5500','1000','2000','1');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Saskatchewan','1187  Lillooet Street','S6V1B3','100000000','10000','3400','2021','1');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Ontario','1649  Sheppard Ave','M1S1T4','1500345','7234','5500','2021','2');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Quebec','3995  rue Boulay','J0H1Y0','350000','3000','1500','1987','3');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Ontario','2934  Balmy Beach Road','N4K2N7','1233004','3599','3500','2001','2');

 INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','106 588 45th Ave','V5C4G2','2034572','5599','6000','2019','1');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','563 Union St','V6A2B7','1333022','3599','3500','1999','6');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','3008 8th Ave','V6A2A6','1999999','5900','6000','2017','1');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','1410 Tolmie St','V6R4B3','1005000','5000','4599','2018','2');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','59080 Battison St','V5R4M8','1233004','5000','5000','2001','100002');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Vancouver','3308 Ash St','V5C3E3','1009999','7999','5500','2001','100004');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Ontario','1847 Ross Street','G4T7W2','90333212','3420','2591','1989','100004');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Saskatchewan','2431 Main St','V4K5K7','2321214','3192','3310','2011','100004');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Alberta','9096 Algoma St Road','P7A4T3','1233038','2345','2510','1999','100004');

INSERT INTO Property (province,street,postcode,price,monthlyIncome,lotSize,buildDate,landlordID) 
VALUES ('Quebec','4610  rue Saint-Antoine','J4K8L7','3290533','3500','3502','1974','100004');















INSERT INTO MonthlyExpenses (propertyID, date, landID, utilityBill, propertyTax, MaintNRepairs) 
VALUES('1', "2020-08-03", '1','100.32', '303.32', '76.38');

INSERT INTO MonthlyExpenses (propertyID, date, landID, utilityBill, propertyTax, MaintNRepairs) 
VALUES('2', "2020-09-03", '1','187.72', '203.87', '33.44');

INSERT INTO MonthlyExpenses (propertyID, date, landID, utilityBill, propertyTax, MaintNRepairs) 
VALUES('3', "2020-10-03", '2','243.62', '340.56', '25.11');

INSERT INTO MonthlyExpenses (propertyID, date, landID, utilityBill, propertyTax, MaintNRepairs) 
VALUES('4', "2020-11-03", '3','43.45', '813.42', '65.76');

INSERT INTO MonthlyExpenses (propertyID, date, landID, utilityBill, propertyTax, MaintNRepairs) 
VALUES('5', "2020-12-03", '2','32.11', '399.74', '25.26');



INSERT INTO Tenant (monthlyRent)
VALUES('1050.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1150.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1250.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1350.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1450.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1550.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1650.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1750.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1850.50');
INSERT INTO Tenant (monthlyRent)
VALUES('1950.50');


INSERT INTO Individual (tenantID, FirstName, LastName)
VALUES('1','Bob','Miller');
INSERT INTO Individual (tenantID, FirstName, LastName)
VALUES('2','James','Brown');
INSERT INTO Individual (tenantID, FirstName, LastName)
VALUES('3','Kelly','Davis');
INSERT INTO Individual (tenantID, FirstName, LastName)
VALUES('4','Karen','Jones');
INSERT INTO Individual (tenantID, FirstName, LastName)
VALUES('5','Mary','Wilson');

INSERT INTO Company (tenantID, CompanyName)
VALUES('6', 'West Tech');
INSERT INTO Company (tenantID, CompanyName)
VALUES('7', 'East Tech');
INSERT INTO Company (tenantID, CompanyName)
VALUES('8', 'North Tech');
INSERT INTO Company (tenantID, CompanyName)
VALUES('9', 'South Tech');
INSERT INTO Company (tenantID, CompanyName)
VALUES('10', 'Mid Tech');



INSERT INTO Retail (propertyID) VALUES ('200000');
INSERT INTO Retail (propertyID) VALUES ('200001');
INSERT INTO Retail (propertyID) VALUES ('200002');
INSERT INTO Retail (propertyID) VALUES ('200003');
INSERT INTO Retail (propertyID) VALUES ('200004');



INSERT INTO Office (propertyID, furnished)
VALUES ('1', "Yes");
INSERT INTO Office (propertyID, furnished)
VALUES ('2', "Yes");
INSERT INTO Office (propertyID, furnished)
VALUES ('3', "No");
INSERT INTO Office (propertyID, furnished)
VALUES ('4', "Yes");
INSERT INTO Office (propertyID, furnished)
VALUES ('5', "No");



INSERT INTO Multifamily (propertyID,spaces, furnished) VALUES ('6', '2', "Yes");
INSERT INTO Multifamily (propertyID,spaces, furnished) VALUES ('7', '1', "Yes");
INSERT INTO Multifamily (propertyID,spaces, furnished) VALUES ('8', '3', "No");
INSERT INTO Multifamily (propertyID,spaces, furnished) VALUES ('9', '8', "No");
INSERT INTO Multifamily (propertyID,spaces, furnished) VALUES ('10', '6', "Yes");


INSERT INTO Spaces (propertyID, space) VALUES ('11', '1');
INSERT INTO Spaces (propertyID, space) VALUES ('12', '1');
INSERT INTO Spaces (propertyID, space) VALUES ('13', '3');
INSERT INTO Spaces (propertyID, space) VALUES ('14', '5');
INSERT INTO Spaces (propertyID, space) VALUES ('15', '8');







COMMIT;
