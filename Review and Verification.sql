--Step 1
USE [Papa Georgios]; -- Ensure you're in the correct database

SELECT 
    C.PROD_CAT_DESC,
    SUM(D.ORD_PRICE) AS Total_Amount,
    SUM(DQ.Quantity_Sold) AS Total_Quantity
FROM 
    dbo.ORDER_DETAIL D
JOIN 
    dbo.PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN 
    dbo.PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN 
    dbo.PROD_CATEGORY C ON S.PROD_CAT_ID = C.PROD_CAT_ID
JOIN
    (SELECT PROD_ID, COUNT(*) AS Quantity_Sold FROM dbo.ORDER_DETAIL GROUP BY PROD_ID) DQ ON DQ.PROD_ID = D.PROD_ID
GROUP BY 
    C.PROD_CAT_DESC;


--Step 2
SELECT 
    S.PROD_SUBCAT_DESC,
    SUM(D.ORD_PRICE) AS Total_Amount,
    SUM(DQ.Quantity_Sold) AS Total_Quantity
FROM 
    ORDER_DETAIL D
JOIN 
    PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN
    (SELECT PROD_ID, COUNT(*) AS Quantity_Sold FROM ORDER_DETAIL GROUP BY PROD_ID) DQ ON DQ.PROD_ID = D.PROD_ID
GROUP BY 
    S.PROD_SUBCAT_DESC;


--Step 3 works now
SELECT 
    P.PROD_ID,
    SUM(D.ORD_PRICE) AS Total_Amount,
    SUM(DQ.Quantity_Sold) AS Total_Quantity
FROM 
    ORDER_DETAIL D
JOIN 
    PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN
    (SELECT PROD_ID, COUNT(*) AS Quantity_Sold FROM ORDER_DETAIL GROUP BY PROD_ID) DQ ON DQ.PROD_ID = D.PROD_ID
WHERE 
    S.PROD_SUBCAT_DESC = 'Pizza' -- Modify this condition based on your pizza identifier
GROUP BY 
    P.PROD_ID;


--Step 4
SELECT 
    P.PROD_ID,
    P.SERV_SIZE,
    SUM(D.ORD_PRICE) AS Total_Amount,
    SUM(DQ.Quantity_Sold) AS Total_Quantity
FROM 
    ORDER_DETAIL D
JOIN 
    PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN
    (SELECT PROD_ID, COUNT(*) AS Quantity_Sold FROM ORDER_DETAIL GROUP BY PROD_ID) DQ ON DQ.PROD_ID = D.PROD_ID
GROUP BY 
    P.PROD_ID, P.SERV_SIZE;


--Step 5
SELECT 
    P.PROD_ID,
    P.PROD_PRICE,
    P.SERV_SIZE,
    S.PROD_SUBCAT_DESC,
    C.PROD_CAT_DESC
FROM 
    PRODUCT P
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN 
    PROD_CATEGORY C ON S.PROD_CAT_ID = C.PROD_CAT_ID;


--Step 6 works now
SELECT 
    D.ORD_ID,
    COUNT(D.PROD_ID) AS Pizza_Count
FROM 
    ORDER_DETAIL D
JOIN 
    PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
WHERE 
    S.PROD_SUBCAT_DESC = 'Pizza'
GROUP BY 
    D.ORD_ID;


SELECT 
    AVG(Pizza_Count) AS Average_Pizza_Per_Order
FROM 
    (
        SELECT 
            D.ORD_ID,
            COUNT(D.PROD_ID) AS Pizza_Count
        FROM 
            ORDER_DETAIL D
        JOIN 
            PRODUCT P ON D.PROD_ID = P.PROD_ID
        JOIN 
            PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
        WHERE 
            S.PROD_SUBCAT_DESC = 'Pizza'
        GROUP BY 
            D.ORD_ID
    ) AS PizzaOrders;


--Step 7 may need to be modified because it shows a lot of zeros
SELECT 
    C.PROD_CAT_DESC,
    ROUND(AVG(NULLIF(P.PROD_PRICE, 0)), 2) AS Average_Price
FROM 
    PRODUCT P
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN 
    PROD_CATEGORY C ON S.PROD_CAT_ID = C.PROD_CAT_ID
GROUP BY 
    C.PROD_CAT_DESC;



--Step 8 works now
SELECT DISTINCT
    C.CUST_ID,
    C.CUST_FNAME,
    C.CUST_LNAME,
    C.CUST_ADDRESS,
    C.CUST_PHONE
FROM 
    CUSTOMER C
JOIN 
    [ORDER] O ON C.CUST_ID = O.CUST_ID
JOIN 
    ORDER_DETAIL D ON O.ORD_ID = D.ORD_ID
JOIN 
    PRODUCT P ON D.PROD_ID = P.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
WHERE 
    S.PROD_SUBCAT_DESC IN ('Pizza', 'Pasta');

--Fixes and modify the PROD_SUBCATEGORY table
/*UPDATE PROD_SUBCATEGORY 
SET PROD_SUBCAT_DESC = 'Pizza' 
WHERE PROD_SUBCAT_DESC = 'Soft Drinks';

--Same as above
UPDATE PROD_SUBCATEGORY 
SET PROD_SUBCAT_DESC = 'Pasta' 
WHERE PROD_SUBCAT_DESC = 'Chips';
*/


--Step 9 needs more testing
-- Calculate the total quantity sold for each product
WITH TotalQuantity AS (
    SELECT 
        PROD_ID,
        SUM(Quantity_Sold) AS Total_Quantity_Sold
    FROM 
        (SELECT PROD_ID, COUNT(*) AS Quantity_Sold 
         FROM ORDER_DETAIL 
         GROUP BY PROD_ID) DQ
    GROUP BY 
        PROD_ID
),

-- Calculate the average quantity sold across all products
AverageQuantity AS (
    SELECT 
        AVG(Total_Quantity_Sold) AS Avg_Quantity_Sold
    FROM 
        TotalQuantity
)

-- Select products whose total quantity sold is greater than the average quantity sold
SELECT 
    P.PROD_ID,
    P.PROD_PRICE,
    P.SERV_SIZE,
    S.PROD_SUBCAT_DESC,
    C.PROD_CAT_DESC,
    TQ.Total_Quantity_Sold
FROM 
    TotalQuantity TQ
JOIN 
    PRODUCT P ON TQ.PROD_ID = P.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN 
    PROD_CATEGORY C ON S.PROD_CAT_ID = C.PROD_CAT_ID,
    AverageQuantity AQ
WHERE 
    TQ.Total_Quantity_Sold > AQ.Avg_Quantity_Sold;


--Step 10
-- Calculate the average price for each product
WITH ProductAveragePrice AS (
    SELECT 
        P.PROD_ID,
        AVG(D.ORD_PRICE) AS Avg_Price_Per_Item
    FROM 
        ORDER_DETAIL D
    JOIN 
        PRODUCT P ON D.PROD_ID = P.PROD_ID
    GROUP BY 
        P.PROD_ID
)

-- Select all product information, sales price, average price, and the difference
SELECT 
    P.PROD_ID,
    P.PROD_PRICE AS Sales_Price,
    PAP.Avg_Price_Per_Item,
    (P.PROD_PRICE - PAP.Avg_Price_Per_Item) AS Price_Difference,
    P.SERV_SIZE,
    S.PROD_SUBCAT_DESC,
    C.PROD_CAT_DESC
FROM 
    PRODUCT P
JOIN 
    ProductAveragePrice PAP ON P.PROD_ID = PAP.PROD_ID
JOIN 
    PROD_SUBCATEGORY S ON P.PROD_SUBCAT_ID = S.PROD_SUBCAT_ID
JOIN 
    PROD_CATEGORY C ON S.PROD_CAT_ID = C.PROD_CAT_ID;
