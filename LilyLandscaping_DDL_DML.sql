/* DDL Statements */

CREATE TABLE CLIENT(
	ClientID		Int		GENERATED ALWAYS AS IDENTITY	PRIMARY KEY,	
	ClientName		VarChar(50)		NOT NULL,
	PhoneNumber		Char(12)		NULL,
	EmailAddress	VarChar(50)		NULL		        	UNIQUE,
	NumberOfBids	Int				DEFAULT 0               NOT NULL,
	CONSTRAINT check_neg_bids		CHECK (NumberOfBids >= 0)
);

CREATE TABLE CONTRACT(
	ContractID			Int		GENERATED ALWAYS AS IDENTITY    PRIMARY KEY,
	ContractName        VarChar(50)     NULL,
    SiteAdministrator	VarChar(50)		NULL,
	StartDate			Date			NULL,
	StopDate			Date			NULL,
	ContractType		VarChar(11)		NULL,
	TaskDescription		VarChar(50)		NULL,
	FemaleWorkHours		Numeric(*,2)	DEFAULT 0               NOT NULL,
	MinorityWorkHours	Numeric(*,2)	DEFAULT 0               NOT NULL,
    CONSTRAINT check_neg_female_hours 	CHECK (FemaleWorkHours >= 0),
	CONSTRAINT check_neg_minority_hours CHECK (MinorityWorkHours >= 0),
	CONSTRAINT contract_type 			CHECK (ContractType IN
		('Maintenance', 'Initial', 'Renovation'))						
);

CREATE TABLE BID(
	BidID			Int		GENERATED ALWAYS AS IDENTITY    PRIMARY KEY,
	Plans			VarChar(100)	NULL,
	SiteAddress 	VarChar(100)	NULL,
    SiteCity        VarChar(50)     NULL,
    SiteState       Char(2)         NULL,
    SiteZip         Char(5)         NULL,
	SiteVisitor		VarChar(50)		NULL,
	ClientID		Int				NOT NULL,
	ContractID		Int				NULL,
	BidAmount		Numeric(*,2)	NOT NULL,
	CONSTRAINT check_neg_bid_amount CHECK (BidAmount > 0),
	CONSTRAINT bid_client_fk 		FOREIGN KEY (ClientID) REFERENCES
		CLIENT (ClientID),
	CONSTRAINT bid_contract_fk 		FOREIGN KEY (ContractID) REFERENCES
		CONTRACT (ContractID)
);

CREATE TABLE SUPPLIER(
	SupplierID		Int		GENERATED ALWAYS AS IDENTITY    PRIMARY KEY,
	SupplierName	VarChar(50)		NULL,
	PhoneNumber		Char(12)		NULL
);

CREATE TABLE PRICE(
	BidID		Int					NOT NULL	UNIQUE,
	SupplierID	Int					NOT NULL	UNIQUE,
	LineItem	VarChar(100)		NULL,
	UnitPrice	Numeric(9,2)		NULL,
	Quantity	Int					NULL,
	CONSTRAINT check_neg_unit_price	CHECK (UnitPrice > 0),
	CONSTRAINT check_neg_quantity	CHECK (Quantity > 0),
	CONSTRAINT price_pk				PRIMARY KEY	(BidID, SupplierID),
	CONSTRAINT bid_price_fk 		FOREIGN KEY (BidID)		 REFERENCES
		BID (BidID),
	CONSTRAINT supplier_price_fk 	FOREIGN KEY (SupplierID) REFERENCES
		SUPPLIER (SupplierID)
);

CREATE TABLE EMPLOYEE(
	EmployeeID				Int	  GENERATED ALWAYS AS IDENTITY    PRIMARY  KEY,
	IsSiteAdministrator		Char(1)			DEFAULT 'F'           NULL,
	FirstName				VarChar(50)		NOT NULL,
	LastName				VarChar(50)		NOT NULL,
	MiddleInitial			Char(1)			NULL,
	StreetAddress			VarChar(100)	NULL,
	UnitNumber				VarChar(5)		NULL,
	City					VarChar(50)		NULL,
	StateAbbr				Char(2)			DEFAULT 'IL'          NULL,
	Zip						Char(5)			NULL,
	PhoneNumber				Char(12)		NULL,
	Birthdate				Date			NOT NULL,
	Gender					VarChar(12)		NOT NULL,
    MaritalStatus           VarChar(7)      NOT NULL,
	HireDate				Date			NULL,
	SocialSecurityNumber	Char(11)		NOT NULL,
	Race					VarChar(30)		NULL,
    IsUnion                 Char(1)         DEFAULT 'F'           NOT NULL,
	EEOCCode 				Char(1) 		NULL,
    CONSTRAINT gender_option    	CHECK (Gender IN ('Male', 'Female')),
    CONSTRAINT site_admin_boolean   CHECK (IsSiteAdministrator IN ('T','F')),
    CONSTRAINT union_boolean        CHECK (IsUnion IN ('T','F')),
    CONSTRAINT eeoc_code_option     CHECK (EEOCCode IN ('1','2','3','4','5')),
    CONSTRAINT marital_option       CHECK (MaritalStatus IN ('Single', 'Married'))
);

CREATE TABLE PAY_STATEMENT(
	PayStatementID	Int		    GENERATED ALWAYS AS IDENTITY    PRIMARY KEY,
	GrossPay		Numeric(9,2)	    NOT NULL,
	FederalTax		Numeric(9,2)	    NULL,
	StateTax		Numeric(9,2)	    NULL,
	SocialSecurity	Numeric(9,2)	    NULL,
	NetPay			Numeric(9,2)	    NULL,
    PayPeriodWeek   Date                NOT NULL,
	PaymentDate		Date			    NOT NULL,
	CONSTRAINT	check_neg_gross_pay		CHECK (GrossPay > 0),
	CONSTRAINT	check_neg_fed_tax		CHECK (FederalTax > 0),
	CONSTRAINT	check_neg_state_tax		CHECK (StateTax > 0),
	CONSTRAINT	check_neg_soc_sec		CHECK (SocialSecurity > 0),
	CONSTRAINT	check_neg_net_pay		CHECK (NetPay > 0)
);

CREATE TABLE LABOR_RATE (
	Skill						    Char(3)			PRIMARY KEY,	
	WorkDescription				    VarChar(50)		NULL,
	PayRate						    Numeric(5,2)	NOT NULL,
	FringeBenefitsCompensation  	Numeric(*,2)	NULL,
	CONSTRAINT check_neg_pay_rate 	CHECK (PayRate > 0),
	CONSTRAINT check_neg_fringe_ben CHECK (FringeBenefitsCompensation > 0)
);

CREATE TABLE TIME_ENTRY(
	TimeEntryID		Int		GENERATED ALWAYS AS IDENTITY		 PRIMARY KEY,
	ContractID		Int				NOT NULL,
	EmployeeID		Int				NOT NULL,
	PayStatementID 	Int 			NOT NULL,
	TimeEntryDate 	Date 			NOT NULL,
	WorkHours		Numeric(5,2)	NOT NULL,
	Skill			Char(3)			NOT NULL,
	CONSTRAINT check_neg_hours		CHECK 		(WorkHours >= 0),
	CONSTRAINT contract_id_fk 		FOREIGN KEY (ContractID)     REFERENCES
		CONTRACT (ContractID),
	CONSTRAINT employee_id_fk 		FOREIGN KEY (EmployeeID)     REFERENCES
		EMPLOYEE (EmployeeID),
	CONSTRAINT paystatement_id_fk	FOREIGN KEY (PayStatementID) REFERENCES
		PAY_STATEMENT (PayStatementID),
	CONSTRAINT skill_fk				FOREIGN KEY (Skill) 		 REFERENCES
		LABOR_RATE (Skill)
);

CREATE TABLE VEHICLE(
	VehicleID		Int		GENERATED ALWAYS AS IDENTITY    PRIMARY KEY,
	VINNumber		Char(17)		NOT NULL,
	LicensePlate	VarChar(10)		NULL,
	Make			VarChar(20)		NULL,
	VehicleModel	VarChar(20)		NULL,
	Color			VarChar(15)		NULL
);

CREATE TABLE TOOL(
	ToolID		    Int		GENERATED ALWAYS AS IDENTITY	PRIMARY KEY,
	ToolType	    VarChar(30)		NULL,
	ToolCategory	VarChar(30) 	NULL
);

CREATE TABLE EQUIPMENT(
	EquipmentID			Int 	GENERATED ALWAYS AS IDENTITY	PRIMARY KEY,
	EquipmentType		VarChar(30)	       NULL,
	EquipmentCategory	VarChar(30)	       NULL,
	Condition			VarChar(30)	       NULL,
	TransportationReq	VarChar(30) 	   NULL,
	OwnershipType		VarChar(9)	       NULL,
	CONSTRAINT equip_own_type	CHECK (OwnershipType IN
		('Rented', 'Purchased'))
);

CREATE TABLE USAGE_LOG(
	ContractID	        Int		    PRIMARY KEY,
	EquipmentID	        Int		    NULL,
	VehicleID 	        Int		    NULL,
	ToolID	  	        Int		    NULL,
    DateUsed            Date        NOT NULL,
    CheckOutTime        Varchar(10) NULL,
    CheckInTime         VarChar(10) NULL,
    
    CONSTRAINT U_L_Contr_fk		FOREIGN KEY (ContractID) REFERENCES
		CONTRACT (ContractID),
	CONSTRAINT U_L_Equip_fk		FOREIGN KEY (EquipmentID) REFERENCES
		EQUIPMENT (EquipmentID),
	CONSTRAINT U_L_Vehicle_fk 	FOREIGN KEY (VehicleID) REFERENCES
		VEHICLE (VehicleID),
	CONSTRAINT U_L_Tool_fk 		FOREIGN KEY (ToolID)	REFERENCES
		TOOL (ToolID)
);

CREATE TABLE MAINTENANCE(
	ContractID	Int					   PRIMARY KEY,
	PayAmount	Numeric(9,2)		   NULL,
	CONSTRAINT check_neg_pay_amount	   CHECK (PayAmount >= 0),
	CONSTRAINT maintenence_contract_fk FOREIGN KEY (ContractID) REFERENCES
		CONTRACT (ContractID)
);

CREATE TABLE INITIAL_RENOVATION(
	ContractID	Int					PRIMARY KEY,
	PayStages	Int	            	NULL,
	TotalPay	Numeric(9,2)		NULL,
	CONSTRAINT check_neg_stages		CHECK 		(PayStages > 0),
	CONSTRAINT check_neg_total		CHECK		(TotalPay > 0),
	CONSTRAINT I_R_contract_fk		FOREIGN KEY (ContractID) REFERENCES
		CONTRACT (ContractID)
);

CREATE TABLE RENTED(
	EquipmentID		Int				PRIMARY KEY,
	Rate			Numeric(9,2)	NULL,
	PickupDate		Date			NULL,
	ReturnDate		Date			NULL,
	CONSTRAINT check_neg_rate   	CHECK 		(Rate >= 0),
	CONSTRAINT rent_eq_fk 		    FOREIGN KEY (EquipmentID) REFERENCES
		EQUIPMENT (EquipmentID)
);

CREATE TABLE PURCHASED(
	EquipmentID		Int				PRIMARY KEY,
	DateBought		Date			NULL,
	EquipmentCost	Numeric(11,2)	NULL,
	CONSTRAINT check_neg_cost	    CHECK 		(EquipmentCost >= 0),
	CONSTRAINT purch_eq_fk 		    FOREIGN KEY (EquipmentID) REFERENCES
		EQUIPMENT (EquipmentID)
);


/* DML Statements */

-- CLIENT Insert Statements
INSERT INTO CLIENT (ClientName, PhoneNumber, EmailAddress, NumberOfBids)
    VALUES ('Schrute Farms', '651-555-4679', 'dwight@schrute.com', 1);
INSERT INTO CLIENT (ClientName, PhoneNumber, EmailAddress, NumberOfBids)
    VALUES ('Carver County Public SChools', '952-952-9525', 'carver@school.edu', 1);
INSERT INTO CLIENT (ClientName, PhoneNumber, EmailAddress, NumberOfBids)
    VALUES ('Pawnee Parks and Recreation', '555-123-4567', 'leslie@knope.gov', 1);

-- CONTRACT Insert Statements
INSERT INTO CONTRACT (ContractName, SiteAdministrator, StartDate, StopDate,
                      ContractType, TaskDescription, FemaleWorkHours, MinorityWorkHours)
    VALUES('Schrute Farms Project', 'Zhang Jing', '22-Feb-21', '15-Mar-20',
           'Maintenance', 'Tree Removal', 20, 20);
INSERT INTO CONTRACT (ContractName, SiteAdministrator, StartDate, StopDate,
                      ContractType, TaskDescription, FemaleWorkHours, MinorityWorkHours)
    VALUES ('Chaska Elementary Renovation', 'Heidi Lewis', '15-Jan-21', '15-Feb-20',
            'Renovation', 'Renovate Soccer Fields', 40, 40);
INSERT INTO CONTRACT (ContractName, SiteAdministrator, StartDate, StopDate,
                      ContractType, TaskDescription, FemaleWorkHours, MinorityWorkHours)
    VALUES ('Pawnee Pit Project', 'Zhang Jing', '15-May-21', '16-Jun-21', 'Initial',
            'Making the Pit into a Park', 50, 50);
            
-- BID Insert Statements
INSERT INTO BID (Plans, SiteAddress, SiteCity, SiteState, SiteZip, SiteVisitor,
                 ClientID, ContractID, BidAmount)
    VALUES ('Tree Removal', '115 Beet St', 'Scranton', 'PA', '86753',
            'Zhang Jing', 1, 1, 500.00);
INSERT INTO BID (Plans, SiteAddress, SiteCity, SiteState, SiteZip, SiteVisitor,
                 ClientID, ContractID, BidAmount)
    VALUES ('Soccer Field Renovation', '110 Pioneer Trail', 'Chaska', 'MN',
            '55318', 'Heidi Lewis', 2, 2, 2500.00);
INSERT INTO BID (Plans, SiteAddress, SiteCity, SiteState, SiteZip, SiteVisitor,
                 ClientID, ContractID, BidAmount)
    VALUES ('New Park in Pit', '233 Pit Way', 'Pawnee', 'IN', '33233',
            'Zhang Jing', 3, 3, 5000.00);
            
-- SUPPLIER Insert Statements
INSERT INTO SUPPLIER (SupplierName, PhoneNumber)
    VALUES('Home Depot', '444-333-2222');
INSERT INTO SUPPLIER (SupplierName, PhoneNumber)
    VALUES('Landscaping Goods', '952-222-6541');
INSERT INTO SUPPLIER (SupplierName, PhoneNumber)
    VALUES('John Deere', '651-554-4545');
    
-- PRICE Insert Statements
INSERT INTO PRICE (BidID, SupplierID, LineItem, UnitPrice, Quantity)
    VALUES (1, 1, 'Wood', 45.00, 50);
INSERT INTO PRICE (BidID, SupplierID, LineItem, UnitPrice, Quantity)
    VALUES (2, 2, 'Soil', 5.00, 60);
INSERT INTO PRICE (BidID, SupplierID, LineItem, UnitPrice, Quantity)
    VALUES (3, 3, 'Mower', 5000.00, 1);
    
-- EMPLOYEE Insert Statements
INSERT INTO EMPLOYEE (IsSiteAdministrator, FirstName, LastName, MiddleInitial,
                      StreetAddress, City, StateAbbr, Zip, PhoneNumber, Birthdate,
                      Gender, MaritalStatus, HireDate, SocialSecurityNumber, Race, IsUnion, EEOCCode)
    VALUES ('T', 'Zhang', 'Jing', 'T', '555 Forest Rd', 'Chicago', 'IL', '60616',
            '312-222-5553', '02-Feb-80', 'Male', 'Single', '05-May-17', '454-44-5454',
            'Asian/Pacific Islander', 'F', '3');
INSERT INTO EMPLOYEE (IsSiteAdministrator, FirstName, LastName, MiddleInitial,
                      StreetAddress, City, StateAbbr, Zip, PhoneNumber, Birthdate,
                      Gender, MaritalStatus, HireDate, SocialSecurityNumber, Race,
                      IsUnion, EEOCCode)
    VALUES ('T', 'Heidi', 'Lewis', 'E', '333 Pine Ln', 'Chicago', 'IL', '60615',
            '343-333-3456', '08-Dec-85', 'Female', 'Married', '20-Feb-18', '555-55-5555',
            'Non-Minority (White)', 'F', '5');
INSERT INTO EMPLOYEE (IsSiteAdministrator, FirstName, LastName, MiddleInitial,
                      StreetAddress, City, StateAbbr, Zip, PhoneNumber, Birthdate,
                      Gender, MaritalStatus, HireDate, SocialSecurityNumber, Race,
                      IsUnion, EEOCCode)
    VALUES ('F', 'James', 'Worker', 'E', '1253 Chopping Block Lane', 'Franklintown',
            'IL', '62270', '312-555-4897', '16-Nov-83', 'Male', 'Single', '17-Jun-2020',
            '390-05-4489', 'Hispanic', 'T', '2');
           
-- PAY_STATEMENT Insert Statements
INSERT INTO PAY_STATEMENT (GrossPay, PayPeriodWeek, PaymentDate)
    VALUES (1000.00, '15-Oct-20', '7-Dec-20');
INSERT INTO PAY_STATEMENT (GrossPay, PayPeriodWeek, PaymentDate)
    VALUES (2000.00, '22-Oct-20', '15-Dec-20');
INSERT INTO PAY_STATEMENT (GrossPay, PayPeriodWeek, PaymentDate)
    VALUES (1500.00, '01-Nov-20', '30-Dec-20');

-- LABOR_RATE Insert Statements
INSERT INTO LABOR_RATE (Skill, WorkDescription, PayRate, FringeBenefitsCompensation)
    VALUES ('MAS', 'Masonry', 17.00, 3.00);
INSERT INTO LABOR_RATE (Skill, WorkDescription, PayRate, FringeBenefitsCompensation)
    VALUES ('LAB', 'Labor', 15.00, 3.00);
INSERT INTO LABOR_RATE (Skill, WorkDescription, PayRate, FringeBenefitsCompensation)
    VALUES ('EQP', 'Equipment Operation', 20.00, 3.00);
    
-- TIME_ENTRY Insert Statements
INSERT INTO TIME_ENTRY (ContractID, EmployeeID, PayStatementID, TimeEntryDate,
                        WorkHours, Skill)
    VALUES (1, 1, 2, '16-Oct-20', 20, 'EQP');
INSERT INTO TIME_ENTRY (ContractID, EmployeeID, PayStatementID, TimeEntryDate,
                        WorkHours, Skill)
    VALUES (2, 2, 3, '25-Oct-20', 25, 'MAS');
INSERT INTO TIME_ENTRY (ContractID, EmployeeID, PayStatementID, TimeEntryDate,
                        WorkHours, Skill)
    VALUES (3, 3, 1, '05-Nov-20', 50, 'LAB');

-- VEHICLE Insert Statements
INSERT INTO VEHICLE (VINNumber, LicensePlate, Make, VehicleModel, Color)
    VALUES ('A1B2C3456298IL85K', 'ITS-121', 'Toyota', '4Runner', 'Blue');
INSERT INTO VEHICLE (VINNumber, LicensePlate, Make, VehicleModel, Color)
    VALUES ('NM3462I2J23413CV3', '437-GHI', 'Ford', 'Ranger', 'Red');
INSERT INTO VEHICLE (VINNumber, LicensePlate, Make, VehicleModel, Color)
    VALUES ('QR347IK3SW6981EO0', 'ROV-998', 'Dodge', 'Ram', 'Black');
    
-- TOOL Insert Statements
INSERT INTO TOOL (ToolType, ToolCategory)
    VALUES ('Saw', 'Woodworking');
INSERT INTO TOOL (ToolType, ToolCategory)
    VALUES ('Mortar', 'Masonry');
INSERT INTO TOOL (ToolType, ToolCategory)
    VALUES ('Shovel', 'Labor');
    
-- EQUIPMENT Insert Statements
INSERT INTO EQUIPMENT (EquipmentType, EquipmentCategory, Condition,
                       OwnershipType)
    VALUES ('Lawn Mower', 'Lawn', 'New', 'Purchased');
INSERT INTO EQUIPMENT (EquipmentType, EquipmentCategory, Condition,
                       OwnershipType)
    VALUES ('Leaf Blower', 'Fall', 'Used', 'Purchased');
INSERT INTO EQUIPMENT (EquipmentType, EquipmentCategory, Condition, 
                       OwnershipType)
    VALUES ('Snowblower', 'Winter', 'New', 'Rented');
    
-- USAGE_LOG Insert Statements
INSERT INTO USAGE_LOG (ContractID, EquipmentID, DateUsed, CheckOutTime, CheckInTime)
    VALUES (1, 1, '12-Dec-20', '10:00 AM', '5:00 PM');
INSERT INTO USAGE_LOG (ContractID, ToolID, DateUsed, CheckOutTime, CheckInTime)
    VALUES (2, 3, '28-Nov-20', '8:00 AM', '2:00 PM');
INSERT INTO USAGE_LOG (ContractID, VehicleID, DateUsed, CheckOutTime, CheckInTime)
    VALUES (3, 1, '20-Dec-20', '6:00 AM', '3:00 PM');

-- MAINTENANCE Insert Statements
INSERT INTO MAINTENANCE (ContractID, PayAmount)
    VALUES (1, 500.00);

--INITIAL_RENOVATION Insert Statements
INSERT INTO INITIAL_RENOVATION (ContractID, PayStages, TotalPay)
    VALUES (2, 3, 2500.00);
INSERT INTO INITIAL_RENOVATION (ContractID, PayStages, TotalPay)
    VALUES (3, 2, 5000.00);
    
-- RENTED Insert Statements
INSERT INTO RENTED (EquipmentID, Rate, PickupDate, ReturnDate)
    VALUES (3, 50.00, '10-Dec-20', '20-Dec-20');
    
-- PURCHASED Insert Statements
INSERT INTO PURCHASED (EquipmentID, DateBought, EquipmentCost)
    VALUES (1, '10-May-20', 5000.00);
INSERT INTO PURCHASED (EquipmentID, DateBought, EquipmentCost)
    VALUES (2, '25-Sep-17', 1000.00);