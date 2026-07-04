CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    City VARCHAR(50),
    Occupation VARCHAR(50)
);

CREATE TABLE accounts (
    Account_ID INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Open_Year INT,
    FOREIGN KEY (Customer_ID) REFERENCES customers(Customer_ID)
);

CREATE TABLE transactions (
    Transaction_ID INT PRIMARY KEY,
    Account_ID INT,
    Transaction_Date DATE,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(10,2),
    Category VARCHAR(50),
    Status VARCHAR(20),
    FOREIGN KEY (Account_ID) REFERENCES accounts(Account_ID)
);


-- 1) sum of total amount
select sum(amount) As Total_Amount from transactions;

-- 2) sum of amount according to cities
select c.city , sum(t.amount) as total_amt
from customers c 
join accounts a on
c.Customer_ID = a.Customer_ID
join transactions t on
a.Account_ID = t.Account_ID
group by city order by total_amt;

-- 3) sum of amount according to transaction_type
select Transaction_Type , sum(amount) as Total_Amount
from transactions group by Transaction_Type ;

-- 4) sum of amount according to Account_Type
select a.Account_Type , sum(t.amount) as Total_Amt
from accounts a 
join transactions t on 
a.Account_ID = t.Account_ID
group by Account_Type ;

-- 5) sum of amount according to transactions type in all type of account
select t.Transaction_Type , a.Account_Type , sum(t.amount) as Total_Amt
from transactions t
join accounts a on 
a.Account_ID = t.Account_ID
group by t.Transaction_Type , a.Account_Type;
-- 2nd method
SELECT
    a.Account_Type,
    SUM(CASE WHEN t.Transaction_Type = 'Credit' THEN t.Amount ELSE 0 END) AS Credit_Amount,
    SUM(CASE WHEN t.Transaction_Type = 'Debit' THEN t.Amount ELSE 0 END) AS Debit_Amount
FROM accounts a
JOIN transactions t
    ON a.Account_ID = t.Account_ID
GROUP BY a.Account_Type;

-- 6) count of transaction type according to account type
select a.account_type , t.Transaction_Type , count(t.transaction_type) as transaction_count
from transactions t
join accounts a on 
a.Account_ID = t.Account_ID
group by t.Transaction_Type , a.Account_Type;
-- 2nd method
SELECT
    a.Account_Type,
    COUNT(CASE WHEN t.Transaction_Type = 'Credit' THEN 1 END) AS Credit_Count,
    COUNT(CASE WHEN t.Transaction_Type = 'Debit' THEN 1 END) AS Debit_Count
FROM accounts a
JOIN transactions t
    ON a.Account_ID = t.Account_ID
GROUP BY a.Account_Type;

-- 7) Window functions = Row_Number () / Rank () / Dense_Rank ()
select * , 
row_number() over(partition by Category order by  Account_id) as Row_Number_FN ,
rank () over(partition by Category order by  Account_id) as RankFN ,
dense_rank () over(partition by Category order by  Account_id) as Dense_rank_FN
from transactions ;

-- 2nd highest transaction
select * from
(select *,
rank() over(order by amount desc) as rnk
from transactions) as rnk_trns
where rnk = 2;

select *
from transactions
order by amount desc
limit 1 offset 1;

