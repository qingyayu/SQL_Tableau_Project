-- Create a new database called Amazon_Sale
CREATE SCHEMA IF NOT EXISTS Amazon_Sale;
-- Select Amazon_Sale Dataset
USE Amazon_Sale;

-- Create a temp_amazon_sale table to import the cleaned 'Amazon Sales Report' data
CREATE TABLE temp_amazon_sale(
   order_id           VARCHAR(19) NOT NULL PRIMARY KEY,
   date               DATE  NOT NULL,
   status             VARCHAR(29) NOT NULL,
   fulfilment         VARCHAR(8) NOT NULL,
   sales_channel      VARCHAR(10) NOT NULL,
   ship_service_level VARCHAR(9) NOT NULL,
   style              VARCHAR(8) NOT NULL,
   SKU                VARCHAR(29) NOT NULL,
   category           VARCHAR(13) NOT NULL,
   size               VARCHAR(4) NOT NULL,
   ASIN               VARCHAR(10) NOT NULL,
   courier_status     VARCHAR(9) NOT NULL,
   quantity           INTEGER  NOT NULL,
   currency           VARCHAR(3) NOT NULL,
   amount             NUMERIC(7,2) NOT NULL,
   ship_city          VARCHAR(50) NOT NULL,
   ship_state         VARCHAR(22) NOT NULL,
   ship_postal_code   VARCHAR(8) NOT NULL,
   ship_country       VARCHAR(3) NOT NULL,
   customer_type      VARCHAR(8) NOT NULL,
   SKU_ASIN           VARCHAR(40) NOT NULL
);

-- Create a stock table to import the cleaned 'Sale Report' data
CREATE TABLE stock(
   SKU       VARCHAR(27) NOT NULL PRIMARY KEY,
   design_no VARCHAR(18) NOT NULL,
   stock     NUMERIC(6,1) NOT NULL,
   category  VARCHAR(20) NOT NULL,
   size      VARCHAR(4) NOT NULL,
   color     VARCHAR(15) NOT NULL
);

-- Create amazon_sale table
CREATE TABLE amazon_sale (
	transaction_key INT PRIMARY KEY AUTO_INCREMENT,
	order_id NVARCHAR(255),
	date DATE,
	status NVARCHAR(255),
	fulfilment NVARCHAR(255),
	sales_channel NVARCHAR(255),
	ship_service_level NVARCHAR(255),
	courier_status NVARCHAR(255),
	quantity INT,
	currency NVARCHAR(255),
	amount DECIMAL(10,2),
	ship_city NVARCHAR(255),
	ship_state NVARCHAR(255),
	ship_postal_code NVARCHAR(255),
	ship_country NVARCHAR(255),
	customer_type NVARCHAR(255),
	SKU_ASIN NVARCHAR(255)
);

-- Create SKU_info table
CREATE TABLE SKU_info(
	SKU_ASIN NVARCHAR(255) PRIMARY KEY,
	style NVARCHAR(255),
	SKU NVARCHAR(255),
	category NVARCHAR(255),
	size NVARCHAR(255),
	ASIN NVARCHAR(255)
);
