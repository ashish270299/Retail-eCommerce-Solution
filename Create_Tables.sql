

USE FinalProject_Group15;

CREATE SCHEMA Customer;


CREATE TABLE  Customer.Customer_Base (
  Customer_ID INT  NOT NULL IDENTITY,
  Customer_First_Name VARCHAR(max) ,
  Customer_Last_Name VARCHAR(max) ,
  Birth_Date DATE ,
  Gender VARCHAR(1) ,
  Mail_ID VARCHAR(max),
  Phone_Number VARCHAR(max) ,
  User_Name VARCHAR(max) ,
  Password VARCHAR(max) ,
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  PRIMARY KEY (Customer_ID))
;



CREATE TABLE  Customer.Customer_Address (
  Address_ID INT  NOT NULL IDENTITY,
  Customer_ID INT NOT NULL,
  Address_Type VARCHAR(max) ,
  Flat_No VARCHAR(max) ,
  Street_Name VARCHAR(max),
  City VARCHAR(max),
  Pin_Code INT,
  Create_Date DATETIME,
  Proc_date DATETIME,
  PRIMARY KEY (Address_ID),
  INDEX Customer_ID_idx (Customer_ID ASC),
  CONSTRAINT Customer_ID
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer.Customer_Base (Customer_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
;



CREATE TABLE  Customer.Customer_Card_Detail (
  Card_Number INT NOT NULL,
  Customer_ID INT NOT NULL,
  Valid_From INT,
  Valid_To INT,
  Name_On_Card VARCHAR(max),
  Card_Type VARCHAR(max),
  PRIMARY KEY (Card_Number),
  INDEX Customer_ID_idx (Customer_ID ASC),
  CONSTRAINT Customer_ID2
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer.Customer_Base (Customer_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
;

CREATE SCHEMA Commodity;



CREATE TABLE  Commodity.Commodity_Master (
  Product_ID INT NOT NULL,
  Product_Category VARCHAR(max),
  Brand_Name VARCHAR(max),
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  PRIMARY KEY (Product_ID))
;




CREATE TABLE  Commodity.Commodity_Details (
  Product_ID INT NOT NULL,
  Product_Title VARCHAR(max),
  Product_Description VARCHAR(max),
  Product_Specification VARCHAR(max),
  Product_Unit_Price Money NULL,
  PRIMARY KEY (Product_ID),
  CONSTRAINT Product_ID
    FOREIGN KEY (Product_ID)
    REFERENCES Commodity.Commodity_Master (Product_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
;


	CREATE TABLE  Commodity.Stock_Master (
  Seller_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Seller_Name VARCHAR(max),
  Total_Stock INT,
  Available_Stock INT,
  PRIMARY KEY (Seller_ID, Product_ID),
  CONSTRAINT Product_ID3
    FOREIGN KEY (Product_ID)
    REFERENCES Commodity.Commodity_Master (Product_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE);



CREATE SCHEMA Orders;




CREATE TABLE  Orders.Cart_Master (
  Customer_ID INT NOT NULL,
  Product_ID INT NOT NULL,
  Cart_Quantity INT,
  Cart_Status VARCHAR(max),
  Order_Flag BIT ,
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  PRIMARY KEY (Customer_ID, Product_ID),
  INDEX Product_ID_idx (Product_ID ASC) ,
  INDEX Customer_ID_idx (Customer_ID ASC) ,
  CONSTRAINT Product_ID2
    FOREIGN KEY (Product_ID)
    REFERENCES Commodity.Commodity_Master (Product_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT Customer_ID3
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer.Customer_Base (Customer_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
;




CREATE TABLE Orders.Order_Master (
  Order_ID INT NOT NULL,
  Customer_ID INT NOT NULL,
  Payment_Mode VARCHAR(max) ,
  Transaction_ID INT,
  Order_Date DATE ,
  Order_Status VARCHAR(max) ,
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  PRIMARY KEY (Order_ID),
  INDEX Customer_ID_idx (Customer_ID ASC) ,
  CONSTRAINT Customer_ID6
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer.Customer_Base (Customer_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
  



CREATE TABLE  Orders.Order_Details (
  Order_ID INT  NOT NULL,
  Product_ID INT NOT NULL,
  Seller_ID INT ,
  Price_Per_Unit MONEY,
  Quantity INT,
  Tax_Amount MONEY,
  Invoice_Status VARCHAR(max),
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  INDEX Order_ID_idx (Order_ID ASC) ,
  PRIMARY KEY (Order_ID, Product_ID),
  INDEX Product_ID_idx (Product_ID ASC) ,
  CONSTRAINT Order_ID
    FOREIGN KEY (Order_ID)
    REFERENCES Orders.Order_Master (Order_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT Product_ID4
    FOREIGN KEY (Product_ID)
    REFERENCES Commodity.Commodity_Master (Product_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


Create schema Shipment;
	
	CREATE TABLE  Shipment.Order_Shipment_Master (
  Order_ID INT NOT NULL,
  Customer_ID INT ,
  Address_ID INT ,
  Expected_Delivery_Date DATETIME ,
  Actual_Delivery_Date DATETIME ,
  Delivery_Status VARCHAR(max) ,
  PRIMARY KEY (Order_ID),
  --UNIQUE INDEX Expected_Delivery_Date_UNIQUE (Expected_Delivery_Date ASC) ,
  INDEX Customer_ID_idx (Customer_ID ASC),
  INDEX Address_ID_idx (Address_ID ASC),
  CONSTRAINT Customer_ID7
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer.Customer_Base (Customer_ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT Address_ID2
    FOREIGN KEY (Address_ID)
    REFERENCES Customer.Customer_Address (Address_ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT Order_ID2
    FOREIGN KEY (Order_ID)
    REFERENCES Orders.Order_Master (Order_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)


;




	CREATE TABLE  Shipment.Shipment_Details (
  Shipment_ID INT NOT NULL,
  Order_ID INT NOT NULL,
  Shipment_Charge MONEY ,
  Shipment_Status VARCHAR(max) ,
  Shipment_Delivery_Date DATETIME ,
  Address_ID VARCHAR(max) ,
  Shipped_Date DATETIME ,
  PRIMARY KEY (Shipment_ID),
  CONSTRAINT Order_ID4
    FOREIGN KEY (Order_ID)
    REFERENCES Shipment.Order_Shipment_Master (Order_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)


	--CREATED
	
	Create schema Invoice;
	CREATE TABLE  Invoice.Invoice_Master (
  Invoice_ID INT NOT NULL,
  Order_ID INT NOT NULL,
  Invoice_Date DATETIME ,
  Invoice_Amount MONEY ,
  Invoice_Status VARCHAR(max) ,
  PRIMARY KEY (Invoice_ID),
  INDEX Order_ID_idx (Order_ID ASC),
  CONSTRAINT Order_ID3
    FOREIGN KEY (Order_ID)
    REFERENCES Orders.Order_Master (Order_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)

	
CREATE TABLE  Invoice.Invoice_Details (
  Invoice_Detail_ID INT NOT NULL,
  Invoice_ID INT NOT NULL,
  Seller_ID INT ,
  Invoice_Item VARCHAR(max),
  Item_Amount MONEY ,
  Tax_Amount MONEY,
  Create_Date DATETIME ,
  Processing_Date DATETIME ,
  PRIMARY KEY (Invoice_Detail_ID),
  INDEX Invoice_ID_idx (Invoice_ID ASC),
  CONSTRAINT Invoice_ID
    FOREIGN KEY (Invoice_ID)
    REFERENCES Invoice.Invoice_Master (Invoice_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)

	CREATE TABLE  Invoice.Payment_Master (
  Payment_ID INT NOT NULL,
  Invoice_ID INT NOT NULL,
  Transaction_ID VARCHAR(max) ,
  Payment_Date DATETIME ,
  Payment_Amount MONEY ,
  Payment_Status VARCHAR(max) ,
  PRIMARY KEY (Payment_ID),
  INDEX Invoice_ID_idx (Invoice_ID ASC),
  CONSTRAINT Invoice_ID2
    FOREIGN KEY (Invoice_ID)
    REFERENCES Invoice.Invoice_Master (Invoice_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE)