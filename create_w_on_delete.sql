--Create ENUM
Create  Type GenderType as ENUM('Male', 'Female', 'Other');

Create  Type PaymentMethod as ENUM('MobileBanking', 'Credit/DebitCard', 'QRPayment');

Create  Type ReportStatus as ENUM('Pending', 'InProgress', 'Resolved');

Create  Type TransactionStatus as ENUM('Pending','Complete');

Create Type AccountType as ENUM('Buddy','Customer');

Create Type ReservationStatus as ENUM('Incomplete', 'During Service', 'Complete');

-- Create ADMIN Table
CREATE TABLE ADMIN (
    admin_id VARCHAR(32) PRIMARY KEY,
    first_name VARCHAR(32) NOT NULL,
    middle_name VARCHAR(32),
    last_name VARCHAR(32) NOT NULL
);

--Create USERS
CREATE TABLE USERS (
    user_id VARCHAR(32) PRIMARY KEY,
    citizen_id VARCHAR(13) NOT NULL,
    gender GenderType NOT NULL,
    address TEXT,
    phone_number VARCHAR(12),
    display_name VARCHAR(32) NOT NULL,
    picture_link TEXT,
    description TEXT
);

--Create Citizen
CREATE TABLE CITIZEN (
    citizen_id VARCHAR(13) PRIMARY KEY,
    first_name VARCHAR(32) NOT NULL,
    middle_name VARCHAR(32),
    last_name VARCHAR(32) NOT NULL
);

--Create Buddy
CREATE TABLE BUDDY (
    buddy_id VARCHAR(32) PRIMARY KEY,
    withdrawable_coin_amount DOUBLE PRECISION NOT NULL,
    FOREIGN KEY (buddy_id) REFERENCES USERS(User_id)
	ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Create SERVICE_TYPE Table
CREATE TABLE SERVICE_TYPE (
    type_id VARCHAR(8) PRIMARY KEY,
    description TEXT NOT NULL
);

-- Create CUSTOMER Table
CREATE TABLE CUSTOMER (
    customer_id VARCHAR(32) PRIMARY KEY,
    age INTEGER,
    gender GenderType,
    location TEXT NOT NULL,
    coin_amount DOUBLE PRECISION NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES USERS(user_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create CUSTOMER_SERVICE_TYPE Table
CREATE TABLE CUSTOMER_SERVICE_TYPE (
    customer_id VARCHAR(32) NOT NULL,
    service_type VARCHAR(8) NOT NULL,
    PRIMARY KEY (customer_id, service_type),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create CUSTOMER_PREFERENCE_TAG Table
CREATE TABLE CUSTOMER_PREFERENCE_TAG (
    customer_id VARCHAR(32) NOT NULL,
    tag VARCHAR(32) NOT NULL,
    PRIMARY KEY (customer_id, tag),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create RESERVATION_RECORD Table
CREATE TABLE RESERVATION_RECORD (
    reservation_id VARCHAR(32) PRIMARY KEY,
    price_coin DOUBLE PRECISION NOT NULL,
    reservation_date DATE NOT NULL,
    status ReservationStatus NOT NULL,
    create_timestamp DATE NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    buddy_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create SERVICE_RECORD Table
CREATE TABLE SERVICE_RECORD (
    service_id VARCHAR(32) PRIMARY KEY,
    description TEXT,
    service_date DATE NOT NULL,
    reservation_id VARCHAR(32) NOT NULL,
    type_id VARCHAR(8) NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    buddy_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES RESERVATION_RECORD(reservation_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (type_id) REFERENCES SERVICE_TYPE(type_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

--Create Buddy_Tag
CREATE TABLE BUDDY_TAG (
    buddy_id VARCHAR(32) NOT NULL,
    tag VARCHAR(32) NOT NULL,
    PRIMARY KEY (buddy_id, tag),
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

--Create Buddy_service_type
CREATE TABLE BUDDY_SERVICE_TYPE (
    buddy_id VARCHAR(32) NOT NULL,
    service_types VARCHAR(8) NOT NULL,
    PRIMARY KEY (buddy_id, service_types),
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	FOREIGN KEY (service_types) REFERENCES SERVICE_TYPE(type_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create WITHDRAWAL_RECORD Table
CREATE TABLE WITHDRAWAL_RECORD (
    withdraw_id VARCHAR(32) PRIMARY KEY,
    bank_information VARCHAR(64) NOT NULL,
    exchange_rate DOUBLE PRECISION NOT NULL,
    coin_amount DOUBLE PRECISION NOT NULL,
    timestamp DATE NOT NULL,
    buddy_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE
    ON UPDATE CASCADE
)

-- Create COIN_PURCHASE_RECORD Table
CREATE TABLE COIN_PURCHASE_RECORD (
    purchase_id VARCHAR(32) PRIMARY KEY,
    payment_method PaymentMethod NOT NULL,
    timestamp DATE NOT NULL,
    cash_price DOUBLE PRECISION NOT NULL,
    coin_amount DOUBLE PRECISION NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Create REPORT_TYPE Table
CREATE TABLE REPORT_TYPE (
    type_id VARCHAR(8) PRIMARY KEY,
    type_description TEXT NOT NULL
);

-- Create REPORT Table
CREATE TABLE REPORT (
    report_id VARCHAR(32) PRIMARY KEY,
    status ReportStatus NOT NULL,
    timestamp DATE NOT NULL,
    content TEXT,
    reporter_id VARCHAR(32) NOT NULL,
    reportee_id VARCHAR(32) NOT NULL,
    type_id VARCHAR(8) NOT NULL,
    admin_id VARCHAR(32) NOT NULL,
    reservation_id VARCHAR(32),
    FOREIGN KEY (reporter_id) REFERENCES USERS(user_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (reportee_id) REFERENCES USERS(user_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (type_id) REFERENCES REPORT_TYPE(type_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES ADMIN(admin_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	FOREIGN KEY (reservation_id) REFERENCES RESERVATION_RECORD(reservation_id)	
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create CHAT_MESSAGE Table
CREATE TABLE CHAT_MESSAGE (
    message_id VARCHAR(64) PRIMARY KEY,
    timestamp DATE NOT NULL,
    read_status BOOLEAN NOT NULL,
    content TEXT NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    buddy_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create REVIEW Table
CREATE TABLE REVIEW (
    service_id VARCHAR(32) NOT NULL,
    review_id VARCHAR(32) PRIMARY KEY,
    timestamp DATE NOT NULL,
    rating DOUBLE PRECISION NOT NULL,
    description TEXT,
    FOREIGN KEY (service_id) REFERENCES SERVICE_RECORD(service_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create COIN_TRANSACTION Table
CREATE TABLE COIN_TRANSACTION (
    transaction_id VARCHAR(64) PRIMARY KEY,
    fee_rate DOUBLE PRECISION NOT NULL,
    status TransactionStatus NOT NULL,
    timestamp DATE NOT NULL,
    reservation_id TEXT NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    buddy_id VARCHAR(32) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (buddy_id) REFERENCES BUDDY(buddy_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	FOREIGN KEY (reservation_id) REFERENCES RESERVATION_RECORD(reservation_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create MANAGE_USER Table
CREATE TABLE MANAGE_USER (
    admin_id VARCHAR(32) NOT NULL,
    user_id VARCHAR(32) NOT NULL,
    PRIMARY KEY (admin_id, user_id),
    FOREIGN KEY (admin_id) REFERENCES ADMIN(admin_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);