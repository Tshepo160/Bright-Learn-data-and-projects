-- Running the entire table 
----------------------------------------------------------------------
SELECT * 
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`
LIMIT 10;

----------------------------------------------------------------------
-- 1 Checking the Date Range 
----------------------------------------------------------------------
SELECT MIN(`transaction_date`) AS min_date,
       MAX(`transaction_date`) AS max_date
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-----------------------------------------------------------------------
-- 2 Checking the names of the different stores 
-----------------------------------------------------------------------
SELECT DISTINCT `store_location`
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

SELECT COUNT(DISTINCT `store_location`) AS number_of_stores
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-----------------------------------------------------------------------
-- 3 Checking products sold at our stores
-----------------------------------------------------------------------
SELECT DISTINCT `product_category`
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

SELECT DISTINCT `product_detail`
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

SELECT DISTINCT `product_type`
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

SELECT DISTINCT `product_category` AS category,
       `product_detail` AS product_name
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-----------------------------------------------------------------------
-- 4 Checking product prices
-----------------------------------------------------------------------
SELECT MIN(`unit_price`) AS cheapest_price,
       MAX(`unit_price`) AS most_expensive_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-- 5 Checking for NULLS in Various Columns
SELECT *
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`
WHERE `unit_price` IS NULL;

----------------------------------------------------------------------- 
-- 6 Checking lowest and highest unit price
-----------------------------------------------------------------------
SELECT 
     MIN(`unit_price`) AS Lowest_unit_price,
     MAX(`unit_price`) AS Highest_unit_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

------------------------------------------------------------------------
-- 7 Extracting the day and Month names
------------------------------------------------------------------------
SELECT 
     dayname(`transaction_date`) AS Day_name,
     monthname(`transaction_date`) AS Month_name
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-----------------------------------------------------------------------
-- 8 Calculating Revenue
SELECT `unit_price`,
       `transaction_qty`,
       `unit_price`*`transaction_qty` AS total_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

SELECT *
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`;

-----------------------------------------------------------------------
-- Combine functions to get a clean enhanced data set
-----------------------------------------------------------------------
SELECT
    `transaction_id`,
    `transaction_date`,
    `transaction_time`,
    `transaction_qty`,
    `store_id`,
    `store_location`,
    `product_id`,
    `unit_price`,
    `product_category`,
    `product_type`,
    `product_detail`,
-- Adding Columns to enhance the table for better insight
-- New Column added 1
    dayname(`transaction_date`) AS Day_name,
-- New Column added 2
    monthname(`transaction_date`) AS Month_name,
-- New Column added 3
    dayofmonth(`transaction_date`) AS day_of_month,
-- New Column added 4 - Determining weekday/weekend
    CASE
        WHEN dayname(`transaction_date`) IN ('Sunday', 'Saturday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,
-- New Column added 5 - Time Buckets
    CASE
        WHEN date_format(`transaction_time`, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01 morning'
        WHEN date_format(`transaction_time`, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02 afternoon'
        WHEN date_format(`transaction_time`, 'HH:mm:ss') BETWEEN '17:00:00' AND '23:59:59' THEN '03 evening'
        ELSE 'night'
    END AS time_Classification,
-- New Column added 6 - Spend buckets
CASE
    WHEN (transaction_qty * unit_price) <= 50 THEN '01 Low Spend'
    WHEN (transaction_qty * unit_price) BETWEEN 51 AND 200 THEN '02 Mid Spend'
    WHEN (transaction_qty * unit_price) BETWEEN 201 AND 500 THEN '03 High Spend'
    ELSE '04 Very High Spend'
END AS Spend_Bucket,
--New Column Added 7 - Revenue
   transaction_qty*unit_price AS Revenue
FROM `workspace`.`default`.`bright_coffee_shop_analysis_case_study(2)_1`
