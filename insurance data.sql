-- Creating the db
create database insurance_data;

-- imported the tables, columns and rows uning TABLE DATA IMPORT WIZARD
use insurance_data;

-- Added 2 new columns in he customers table
alter table customers
add column age int,
add column age_group varchar (20);

SELECT 
    age, age_group
FROM
    customers;
    
UPDATE customers 
SET 
    age = TIMESTAMPDIFF(YEAR,
        date_of_birth,
        CURDATE());
        
UPDATE customers 
SET 
    age_group = CASE
        WHEN age < 30 THEN 'Young'
        WHEN age BETWEEN 30 AND 49 THEN 'Middle Age'
        WHEN age >= 50 THEN 'Old'
        ELSE 'Unknown'
    END;

SELECT 
    age, age_group
FROM
    customers;
    
-- setting pk and fk
alter table customers
add primary key (customer_id);

alter table claims
add primary key (claim_id);

alter table policies
add primary key (policy_id);

alter table risk_profile
add primary key (customer_id);

alter table policies
add constraint fk_policies_customer
foreign key (customer_id) references customers(customer_id);

alter table claims
add constraint fk_claims_policy
foreign key (policy_id) references policies(policy_id);

alter table risk_profile
add constraint fk_risk_customer
foreign key (customer_id) references customers(customer_id);

-- joining tables
-- Total approved claims based on gender
SELECT 
    SUM(claim_amount) AS approved_claim, gender
FROM
    customers AS cu
        JOIN
    policies AS po ON cu.customer_id = po.customer_id
        JOIN
    claims AS cl ON cl.policy_id = po.policy_id
WHERE
    status = 'Approved'
GROUP BY gender;


SELECT 
    policy_type, COUNT(policy_type) AS 'policy '
FROM
    policies
GROUP BY policy_type;

SELECT 
    policy_type, COUNT(policy_type) AS 'policy'
FROM
    policies
GROUP BY policy_type
ORDER BY policy DESC
LIMIT 1;


-- creating a new column with updated risk score and level
ALTER TABLE risk_profile
ADD COLUMN risk_score INT,
ADD COLUMN calculated_risk_factor VARCHAR(10);

-- then update them with the calculated values
UPDATE risk_profile rp
        JOIN
    customers cu ON cu.customer_id = rp.customer_id 
SET 
    rp.risk_score = (CASE
        WHEN rp.bmi < 18.5 THEN 1
        WHEN rp.bmi BETWEEN 18.5 AND 24.9 THEN 0
        WHEN rp.bmi BETWEEN 25 AND 34.9 THEN 2
        ELSE 3
    END + CASE
        WHEN cu.age_group = 'Young' THEN 0
        WHEN cu.age_group = 'Middle Age' THEN 1
        WHEN cu.age_group = 'Old' THEN 2
        ELSE 0
    END + CASE
        WHEN rp.smoker_status = 'Yes' THEN 2
        ELSE 0
    END),
    rp.calculated_risk_factor = CASE
        WHEN
            (CASE
                WHEN rp.bmi < 18.5 THEN 1
                WHEN rp.bmi BETWEEN 18.5 AND 24.9 THEN 0
                WHEN rp.bmi BETWEEN 25 AND 34.9 THEN 2
                ELSE 3
            END + CASE
                WHEN cu.age_group = 'Young' THEN 0
                WHEN cu.age_group = 'Middle Age' THEN 1
                WHEN cu.age_group = 'Old' THEN 2
                ELSE 0
            END + CASE
                WHEN rp.smoker_status = 'Yes' THEN 2
                ELSE 0
            END) <= 1
        THEN
            'Low'
        WHEN
            (CASE
                WHEN rp.bmi < 18.5 THEN 1
                WHEN rp.bmi BETWEEN 18.5 AND 24.9 THEN 0
                WHEN rp.bmi BETWEEN 25 AND 34.9 THEN 2
                ELSE 3
            END + CASE
                WHEN cu.age_group = 'Young' THEN 0
                WHEN cu.age_group = 'Middle Age' THEN 1
                WHEN cu.age_group = 'Old' THEN 2
                ELSE 0
            END + CASE
                WHEN rp.smoker_status = 'Yes' THEN 2
                ELSE 0
            END) <= 3
        THEN
            'Medium'
        ELSE 'High'
    END;
    
alter table risk_profile
drop column risk_level;

alter table risk_profile
rename column calculated_risk_factor to risk_level;

-- Determinibg aand Adding an income level. Lower Class, Upper class and Middle class
select avg(annual_income)
from customers;


SELECT 
    MAX(annual_income) AS highest_earner,
    MIN(annual_income) AS lowest_earner
FROM
    customers;

-- The center of the annual income of all customers is 115,820.71 usd, max is 197,493 usd and min is 32,026 usd

alter table customers add column income_bracket varchar(20);

UPDATE customers 
SET 
    income_bracket = CASE
        WHEN annual_income <= 60000 THEN 'Lower Class'
        WHEN annual_income BETWEEN 60001 AND 120000 THEN 'Middle Class'
        ELSE 'Upper Class'
    END;
    
SELECT 
    income_bracket, COUNT(income_bracket) AS count
FROM
    customers
GROUP BY income_bracket;

alter table policies add column freq varchar(20);

UPDATE policies
SET freq = ELT(FLOOR(1 + RAND() * 3), 'Monthly', 'Quarterly', 'Annually');

SELECT 
    freq, COUNT(freq) AS co
FROM
    policies
GROUP BY freq;


alter table policies add column payment_frequency int;

alter table policies rename column freq to subscription_plan;

UPDATE policies 
SET 
    payment_frequency = CASE
        WHEN subscription_plan = 'monthly' THEN 12
        WHEN subscription_plan = 'quarterly' THEN 4
        ELSE 1
    END;

alter table policies add column total_premium decimal (10,2);

update policies set total_premium = payment_frequency * premium;
