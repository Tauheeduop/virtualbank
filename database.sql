-- ===========================
-- VirtualBank Database
-- Structure + Seed Data
-- ===========================

-- 1. Database
CREATE DATABASE IF NOT EXISTS virtualbank;
USE virtualbank;

-- ===========================
-- 2. Users Table
-- ===========================
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    national_id VARCHAR(20) UNIQUE,
    kyc_status VARCHAR(20) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

INSERT INTO users (full_name, email, phone, address, national_id, kyc_status)
VALUES
('Tauheed Ahmad', 'tauheed@example.com', '03001234567', 'Karachi, Pakistan', '42101-1234567-8', 'verified'),
('Ali Khan', 'ali@example.com', '03009876543', 'Lahore, Pakistan', '42101-9876543-1', 'verified'),
('Sara Ali', 'sara@example.com', '03007654321', 'Islamabad, Pakistan', '42101-1234987-2', 'verified'),
('Ahmed Raza', 'ahmed@example.com', '03006543210', 'Rawalpindi, Pakistan', '42101-8765432-3', 'verified'),
('Fatima Noor', 'fatima@example.com', '03005432109', 'Karachi, Pakistan', '42101-5432109-4', 'pending'),
('Bilal Sheikh', 'bilal@example.com', '03004567890', 'Lahore, Pakistan', '42101-6789012-5', 'verified'),
('Hina Khan', 'hina@example.com', '03003456789', 'Karachi, Pakistan', '42101-2345678-6', 'verified');

-- ===========================
-- 3. Accounts Table
-- ===========================
CREATE TABLE IF NOT EXISTS accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_title VARCHAR(100) NOT NULL,
    iban VARCHAR(34) UNIQUE NOT NULL,
    account_type VARCHAR(20) DEFAULT 'savings',
    balance DECIMAL(15,2) DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'PKR',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

INSERT INTO accounts (account_number, account_title, iban, account_type, balance, currency)
VALUES
('1002003001', 'Tauheed Savings', 'PK00VIRT0000000001', 'savings', 50000, 'PKR'),
('1002003002', 'Ali Business', 'PK00VIRT0000000002', 'current', 150000, 'PKR'),
('1002003003', 'Sara Salary', 'PK00VIRT0000000003', 'savings', 80000, 'PKR'),
('1002003004', 'Ahmed Savings', 'PK00VIRT0000000004', 'savings', 60000, 'PKR'),
('1002003005', 'Fatima Term', 'PK00VIRT0000000005', 'term', 120000, 'PKR'),
('1002003006', 'Bilal Current', 'PK00VIRT0000000006', 'current', 90000, 'PKR'),
('1002003007', 'Hina Savings', 'PK00VIRT0000000007', 'savings', 70000, 'PKR');

-- ===========================
-- 4. Account Holders Table
-- ===========================
CREATE TABLE IF NOT EXISTS account_holders (
    holder_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    user_id INT NOT NULL,
    is_primary BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO account_holders (account_id, user_id, is_primary)
VALUES
(1, 1, TRUE),
(2, 2, TRUE),
(3, 3, TRUE),
(4, 4, TRUE),
(5, 5, TRUE),
(6, 6, TRUE),
(7, 7, TRUE);

-- ===========================
-- 5. Transactions Table
-- ===========================
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'PKR',
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    counterparty_iban VARCHAR(34),
    merchant_name VARCHAR(100),
    merchant_category VARCHAR(50),
    geo_location VARCHAR(50),
    status VARCHAR(20) DEFAULT 'success',
    recurring BOOLEAN DEFAULT FALSE,
    recurring_interval VARCHAR(20),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO transactions (account_id, transaction_type, amount, description, counterparty_iban, merchant_name, merchant_category, geo_location, status)
VALUES
(1, 'deposit', 50000, 'Initial deposit', NULL, NULL, NULL, 'Karachi', 'success'),
(1, 'withdraw', 5000, 'ATM withdrawal', NULL, NULL, NULL, 'Karachi', 'success'),
(2, 'deposit', 150000, 'Initial deposit', NULL, NULL, NULL, 'Lahore', 'success'),
(2, 'transfer_out', 20000, 'Payment to supplier', 'PK00VIRT0000000003', 'ABC Traders', 'Wholesale', 'Lahore', 'success'),
(3, 'deposit', 80000, 'Salary credited', NULL, NULL, NULL, 'Islamabad', 'success'),
(3, 'transfer_out', 10000, 'Rent payment', 'PK00VIRT0000000004', 'Landlord', 'Housing', 'Islamabad', 'success'),
(4, 'deposit', 60000, 'Initial deposit', NULL, NULL, NULL, 'Rawalpindi', 'success'),
(5, 'deposit', 120000, 'Term deposit', NULL, NULL, NULL, 'Karachi', 'success'),
(6, 'deposit', 90000, 'Initial deposit', NULL, NULL, NULL, 'Lahore', 'success'),
(6, 'transfer_out', 20000, 'Vendor payment', 'PK00VIRT0000000002', 'XYZ Traders', 'Wholesale', 'Lahore', 'success'),
(7, 'deposit', 70000, 'Salary credited', NULL, NULL, NULL, 'Karachi', 'success');

-- ===========================
-- 6. Cards Table
-- ===========================
CREATE TABLE IF NOT EXISTS cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    card_number VARCHAR(16) UNIQUE,
    expiry_date VARCHAR(5),
    cvv VARCHAR(3),
    card_type VARCHAR(10) DEFAULT 'debit',
    status VARCHAR(20) DEFAULT 'active',
    daily_limit DECIMAL(15,2) DEFAULT 50000,
    monthly_limit DECIMAL(15,2) DEFAULT 500000,
    is_virtual BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO cards (account_id, card_number, expiry_date, cvv, card_type, status, daily_limit, monthly_limit, is_virtual)
VALUES
(1, '4000123412341234', '12/28', '123', 'debit', 'active', 50000, 500000, FALSE),
(2, '4000567856785678', '11/27', '456', 'debit', 'active', 100000, 1000000, FALSE),
(3, '4000345634563456', '10/26', '789', 'debit', 'active', 50000, 500000, TRUE),
(4, '4000456745674567', '09/29', '321', 'debit', 'active', 50000, 500000, FALSE),
(5, '4000678901234567', '08/28', '654', 'debit', 'active', 200000, 2000000, TRUE),
(6, '4000789012345678', '07/27', '987', 'debit', 'active', 100000, 1000000, FALSE),
(7, '4000890123456789', '06/26', '741', 'debit', 'active', 50000, 500000, TRUE);

-- ===========================
-- 7. Loan History Table
-- ===========================
CREATE TABLE IF NOT EXISTS loan_history (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) DEFAULT 10.00,
    status VARCHAR(20) DEFAULT 'closed',
    start_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    end_date DATETIME,
    notes VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

INSERT INTO loan_history (account_id, loan_amount, interest_rate, status, start_date, end_date, notes)
VALUES
(1, 20000, 10.00, 'closed', '2024-01-01', '2024-06-01', 'Personal loan repaid'),
(2, 50000, 12.00, 'open', '2025-01-01', NULL, 'Business expansion loan'),
(3, 15000, 11.00, 'closed', '2024-05-01', '2024-11-01', 'Salary advance loan'),
(4, 30000, 10.50, 'open', '2025-03-01', NULL, 'Emergency loan'),
(5, 50000, 12.50, 'open', '2025-02-01', NULL, 'Term deposit linked loan'),
(6, 40000, 11.00, 'open', '2025-04-01', NULL, 'Small business loan'),
(7, 25000, 10.75, 'closed', '2024-07-01', '2025-01-01', 'Personal loan repaid');
