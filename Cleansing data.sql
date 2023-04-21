-- Cast function, in this case cast() use for change purchase_price from string to float64
SELECT 
	CAST(purchase_price AS FLOAT)
FROM 
	[Coursera].[dbo].[Table]
ORDER BY 
	CAST(purchase_price AS float) DESC

-- use cast again, but for change Datetime to date

SELECT
 CAST(date AS date) AS date_only,
 purchase_price
FROM
 [Coursera].[dbo].[Table]
WHERE
 date BETWEEN '2020-12-01' AND '2020-12-31'

-- concat query
SELECT
 CONCAT(product_code, product_color) AS new_product_code
FROM
 [Coursera].[dbo].[Table]
WHERE
 product = 'couch'

-- coalesce query
SELECT
 COALESCE(product, product_code) AS product_info
FROM
 [Coursera].[dbo].[Table]
