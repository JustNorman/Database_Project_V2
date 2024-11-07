INSERT INTO PROD_CATEGORY (PROD_CAT_ID, PROD_CAT_DESC) --WORKS
VALUES 
(1, 'Beverages'),
(2, 'Snacks');

INSERT INTO PROD_SUBCATEGORY (PROD_SUBCAT_ID, PROD_SUBCAT_DESC, PROD_CAT_ID) --WORKS
VALUES 
(1, 'Soft Drinks', 1),
(2, 'Chips', 2);

INSERT INTO PRODUCT (PROD_ID, PROD_PRICE, SERV_SIZE, PROD_SUBCAT_ID) --WORKS
VALUES 
(1, 1.50, 1, 1),
(2, 2.00, 1, 1),
(3, 3.00, 1, 2),
(4, 2.50, 1, 2);

INSERT INTO CUSTOMER (CUST_ID, CUST_FNAME, CUST_LNAME, CUST_ADDRESS, CUST_PHONE) --WORKS
VALUES 
(1, 'John', 'Doe', '123 Elm St', '555-1234'),
(2, 'Jane', 'Smith', '456 Maple Ave', '555-5678');

INSERT INTO [ORDER] (ORD_ID, CUST_ID, EMP_ID, ORD_DATE, ORD_TOTAL)
VALUES 
(1, 1, 101, '2024-01-15', 5.50),
(2, 2, 102, '2024-01-20', 5.50);

INSERT INTO ORDER_DETAIL (ORD_DET_ID, ORD_ID, PROD_ID, ORD_PRICE)
VALUES 
(1, 1, 1, 1.50),
(2, 1, 2, 2.00),
(3, 2, 3, 3.00),
(4, 2, 4, 2.50);

INSERT INTO STAGES (STAGE_ID, [DESC]) --WORKS
VALUES 
(1, 'Initial Stage'),
(2, 'Final Stage');

INSERT INTO ORDER_CURR_STAGE_BRIDGE (STAGE_ID, ORD_ID, DETAIL_ID)
VALUES 
(1, 1, 1),
(2, 2, 3);

INSERT INTO VENDOR (VEND_ID, VEND_NAME, VEND_ADDRESS, VEND_PHONE)
VALUES 
(1, 'Vendor A', '789 Oak St', '555-7890'),
(2, 'Vendor B', '101 Pine Rd', '555-1011');

INSERT INTO INVENTORY_CATEGORY (INV_CAT_ID, INV_CAT_DESC) --WORKS
VALUES 
(1, 'Food'),
(2, 'Drink');

INSERT INTO INVENTORY_SUBCATEGORY (INV_SUBCAT_ID, INV_SUBCAT_DESC, INV_CAT_ID) --WORKS
VALUES 
(1, 'Beverages', 2),
(2, 'Snacks', 1);

INSERT INTO INVENTORY (INV_ID, INV_QUANTITY_ON_HAND, INV_SUBCAT_ID, VEND_ID) --WORKS
VALUES 
(1, 100, 1, 1),
(2, 200, 2, 2);

INSERT INTO RECIPE_BRIDGE (PROD_ID, INV_ID, QTY_NEED) --WORKS
VALUES 
(1, 1, 10),
(2, 2, 20);

INSERT INTO PRICE_HISTORY (PROD_ID, START_DATE, END_DATE, PRICE) --WORKS
VALUES 
(1, '2024-01-01', '2024-06-30', 1.50),
(2, '2024-01-01', '2024-06-30', 2.00);

INSERT INTO PAYMENT (PYMT_ID, PYMT_METHOD, DISCOUNT_AMOUNT, ORD_ID)
VALUES 
(1, 'Credit Card', 0.50, 1),
(2, 'Cash', 0.00, 2);

INSERT INTO MEMBERSHIP (MEMB_ID, CUST_ID, MEMB_POINTS) --WORKS
VALUES 
(1, 1, 100),
(2, 2, 200);

INSERT INTO RATING_BRIDGE (RATING_ID, CUST_ID, ORD_ID, STAR_RAT, COMMENTS)
VALUES 
(1, 1, 1, 5, 'Excellent'),
(2, 2, 2, 4, 'Good');
