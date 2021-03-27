SELECT
	catalogs.name AS 'product_section',
	products.name AS 'product_name'
FROM 
	products
JOIN
	catalogs
ON
	products.catalog_id = catalogs.id
;