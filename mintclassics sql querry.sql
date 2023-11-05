-- Selecting mintclassics Database
use mintclassics;


-- Viewing the tables in Mintclassics Database
show tables;


-- Checking how many warehouses are there
SELECT 
    COUNT(warehouseName)
FROM
    warehouses;


-- Seeing how many stocks are in each warehouses
SELECT 
    w.warehouseName,
    p.warehouseCode,
    SUM(quantityInStock) AS InventoryStock
FROM
    warehouses w
        JOIN
    products p ON w.warehouseCode = p.warehousecode
GROUP BY p.warehouseCode;


-- This shows the profits of each warehouses
With revenue as(
	select p.warehouseCode,p.productCode,p.buyprice,od.priceEach,od.quantityOrdered,(od.priceEach-buyPrice) as Profit
	from products p join orderdetails od on p.productcode=od.productCode
    )
select w.warehouseCode,w.warehouseName,sum(r.Profit*r.quantityOrdered) as Profits
from warehouses w join revenue r on w.warehouseCode=r.warehouseCode
group by r.warehouseCode
order by Profits Desc;


-- Checking which product has more stock in inventory than needed
SELECT 
    p.productcode,
    p.productName,
    p.quantityinStock,
    SUM(od.quantityOrdered) AS totalorder,
    (p.quantityinstock - SUM(od.quantityOrdered)) AS BalancestockInventory
FROM
    products p
        JOIN
    orderdetails od ON p.productCode = od.productCode
GROUP BY p.productcode
HAVING BalanceStockInventory > 0
ORDER BY BalancestockInventory DESC;


-- Checking which product needs to be stocked and its demand
SELECT 
    p.productcode,
    p.productName,
    p.quantityinStock,
    SUM(od.quantityOrdered) AS totalorder,
    (p.quantityinstock - SUM(od.quantityOrdered)) AS BalancestockInventory
FROM
    products p
        JOIN
    orderdetails od ON p.productCode = od.productCode
GROUP BY p.productcode
HAVING BalanceStockInventory < 0
ORDER BY BalancestockInventory ASC;


-- Checking whether product price as any effect on sales
SELECT 
    p.productCode,
    p.productName,
    p.buyPrice,
    SUM(od.quantityOrdered) AS Quantityordered
FROM
    products p
        JOIN
    orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode
ORDER BY buyPrice DESC;
    
    
-- Finding who is our valuable customer;
SELECT 
    c.customerNumber,
    c.customerName,
    COUNT(o.orderNumber) AS totalSales
FROM
    mintclassics.customers AS c
        JOIN
    mintclassics.orders AS o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber , c.customerName
ORDER BY totalSales DESC



    