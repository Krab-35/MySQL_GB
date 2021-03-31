CREATE OR REPLACE VIEW
	join_tables
AS
	SELECT
		products.name AS 'product_name',
		catalogs.name AS 'catalog_name'
	FROM 
		products
	JOIN
		catalogs
	ON
		products.catalog_id = catalogs.id
;

SELECT * FROM join_tables;