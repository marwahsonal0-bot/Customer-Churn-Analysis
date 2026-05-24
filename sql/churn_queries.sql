CREATE TABLE telco_customer_churn (
    customerID TEXT,
    gender TEXT,
    SeniorCitizen INT,
    Partner TEXT,
    Dependents TEXT,
    tenure INT,
    PhoneService TEXT,
    MultipleLines TEXT,
    InternetService TEXT,
    OnlineSecurity TEXT,
    OnlineBackup TEXT,
    DeviceProtection TEXT,
    TechSupport TEXT,
    StreamingTV TEXT,
    StreamingMovies TEXT,
    Contract TEXT,
    PaperlessBilling TEXT,
    PaymentMethod TEXT,
    MonthlyCharges NUMERIC,
    TotalCharges TEXT,
    Churn TEXT
);

--Cleaning dataset

--Are there any missing values in the dataset?

SELECT *
FROM telco_customer_churn
WHERE TotalCharges IS NULL
   OR TotalCharges = '';

--Are there duplicate customer IDs?

SELECT customerID, COUNT(*)
FROM telco_customer_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

--What are the distinct churn values?

SELECT DISTINCT Churn
FROM telco_customer_churn;

--Q1: How many customers churned and how many stayed?

SELECT Churn, COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY Churn;

--Q2: Which contract type has the highest churn?

SELECT Contract,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY Contract, Churn
ORDER BY Contract;

--Q3: Does higher monthly spending increase customer churn?

SELECT Churn,
       ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges
FROM telco_customer_churn
GROUP BY Churn;

--Q4: Which internet service type has the highest churn?

SELECT InternetService,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY InternetService, Churn
ORDER BY InternetService;

--Q5: Does tenure affect customer churn?

SELECT Churn,
       ROUND(AVG(tenure), 2) AS avg_tenure
FROM telco_customer_churn
GROUP BY Churn;

--Q6: Which payment method has the highest churn?

SELECT PaymentMethod,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY PaymentMethod, Churn
ORDER BY PaymentMethod;

--Q7: Do customers with paperless billing churn more?

SELECT PaperlessBilling,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY PaperlessBilling, Churn
ORDER BY PaperlessBilling;

--Q8: Does tech support availability affect customer churn?

SELECT TechSupport,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY TechSupport, Churn
ORDER BY TechSupport;

--Q9: Does contract duration affect customer retention?

SELECT Contract,
       ROUND(AVG(tenure), 2) AS avg_tenure
FROM telco_customer_churn
GROUP BY Contract
ORDER BY avg_tenure DESC;

--Q10: Which gender has a higher churn rate?

SELECT gender,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY gender, churn;

--Q11: Do senior citizens churn more than non-senior citizens?

SELECT SeniorCitizen,
       Churn,
       COUNT(*) AS total_customers
FROM telco_customer_churn
GROUP BY SeniorCitizen, Churn;

--Q12: Rank contract types based on average monthly charges.

SELECT Contract,
       ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
       RANK() OVER (
           ORDER BY AVG(MonthlyCharges) DESC
       ) AS contract_rank
FROM telco_customer_churn
GROUP BY Contract;

--Q13: Which contract types have above-average churned customers?

WITH churn_data AS (
    SELECT Contract,
           COUNT(*) AS churned_customers
    FROM telco_customer_churn
    WHERE Churn = 'Yes'
    GROUP BY Contract
)

SELECT Contract,
       churned_customers
FROM churn_data
WHERE churned_customers > (
    SELECT AVG(churned_customers)
    FROM churn_data
);

--Q14: Rank payment methods based on churned customers.

WITH payment_churn AS (
    SELECT PaymentMethod,
           COUNT(*) AS churned_customers
    FROM telco_customer_churn
    WHERE Churn = 'Yes'
    GROUP BY PaymentMethod
)

SELECT PaymentMethod,
       churned_customers,
       RANK() OVER (
           ORDER BY churned_customers DESC
       ) AS churn_rank
FROM payment_churn;

--Q15: What is the churn percentage for each contract type?

SELECT Contract,
       COUNT(*) FILTER (WHERE Churn = 'Yes') AS churned_customers,
       COUNT(*) AS total_customers,
       ROUND(
           100.0 * COUNT(*) FILTER (WHERE Churn = 'Yes') / COUNT(*),
           2
       ) AS churn_percentage
FROM telco_customer_churn
GROUP BY Contract;
	   






















