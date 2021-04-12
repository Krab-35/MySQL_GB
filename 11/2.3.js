USE catalogs
db.catalogs.insertmany([
	{id: 1, name: 'Процессоры'}, 
	{id: 2, name: 'Материнские платы'}, 
	{id: 3, name: 'Видеокарты'}, 
	{id: 4, name: 'Жесткие диски'}, 
	{id: 5, name: 'Оперативная память'} 
])

USE products
db.products.insertmany([
	{id: 1, name: 'Intel Core i3-8100', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price: '7890.00', catalog_id: 1, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 2, name: 'Intel Core i5-7400', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', price: '12700.00', catalog_id: 1, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 3, name: 'AMD FX-8320E', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', price: '4780.00', catalog_id: 1, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 4, name: 'AMD FX-8320', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', price: '7120.00', catalog_id: 1, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 5, name: 'ASUS ROG MAXIMUS X HERO', description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', price: '19310.00', catalog_id: 2, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 6, name: 'Gigabyte H310M S2H', description: 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', price: '4790.00', catalog_id: 2, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'},
	{id: 7, name: 'MSI B250M GAMING PRO', description: 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', price: '5060.00', catalog_id: 2, created_at: '2021-03-22 17:14:03', updated_at: '2021-03-22 17:14:03'}
])