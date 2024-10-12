--What is the average sales made for each month based on category?
WITH CTE AS (
	SELECT AVG(OD.AMOUNT) AS SALES
	,MONTH(OL.ORDER_DATE) AS MONTHNO
	,DATENAME(month,OL.ORDER_DATE) AS MNTH
	,OD.Category
	FROM 
	Order_Details OD
	JOIN Orders_List OL
	ON OD.Order_ID=OL.Order_ID
	GROUP BY DATENAME(month,OL.ORDER_DATE),MONTH(OL.ORDER_DATE),OD.Category)

SELECT SALES,MNTH AS MONTH,CATEGORY FROM CTE
ORDER BY 3,2;

-- Which months have the target not been made/made based on category?  
WITH CTE AS (
	SELECT AVG(OD.AMOUNT) AS SALES
	,MONTH(OL.ORDER_DATE) AS MONTHNO
	,DATENAME(month,OL.ORDER_DATE) AS MNTH
	,OD.Category
	FROM 
	Order_Details OD
	JOIN Orders_List OL
	ON OD.Order_ID=OL.Order_ID
	GROUP BY DATENAME(month,OL.ORDER_DATE),MONTH(OL.ORDER_DATE),OD.Category)

--What is the profit/loss margin made for each category? 
SELECT 
CATEGORY,
SUM(AMOUNT) AS TOTAL_AMT,
SUM(PROFIT) AS PROFIT_OR_LOSS
FROM
Order_Details
GROUP BY Category

--Which months do we see the highest sales?
SELECT 
CATEGORY,
SUM(AMOUNT) AS TOTAL_AMT,
SUM(PROFIT) AS PROFIT_OR_LOSS
FROM
Order_Details
GROUP BY Category
ORDER BY 2 DESC

--For each category- return the subcategory performing the best in terms of sales and the subcategory with lowest number of sales/profit
WITH CTE AS (
SELECT
MAX(AMOUNT) AS MAX_SALES,
MIN(AMOUNT) AS MIN_SALES,
CATEGORY
FROM Order_Details
GROUP BY CATEGORY
)

SELECT 
OD.CATEGORY,
OD.SUB_CATEGORY,
CASE WHEN C.MAX_SALES IS NULL AND C2.MIN_SALES IS NOT NULL THEN 'Lowest Sales' 
ELSE 'Highest Sales' end as High_or_low,
od.amount AS SALES
FROM ORDER_DETAILS OD 
LEFT JOIN
(select max_sales,Category from CTE) C ON OD.Category=C.Category AND OD.Amount=C.MAX_SALES 
LEFT JOIN
(select min_sales,Category from CTE) C2 ON OD.Category=C2.Category AND OD.Amount=C2.MIN_SALES
WHERE 
(C.MAX_SALES IS NOT NULL OR C2.MIN_SALES IS NOT NULL)
order by 1,3