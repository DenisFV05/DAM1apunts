#Exercici 4 -  Consultes de la BD Custprod
use custprod;
#Empleats de les oficines de França que tenen més de 6 clients
##############################################################
# Comandes dels clients de les oficines de França realitzades el 2005. 
SELECT c.customerName,o.orderNumber,o.orderDate,o.status AS OrderStatus,f.country
FROM customers c	
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices f ON e.officeCode = f.officeCode
WHERE f.country = 'France' AND YEAR(o.orderDate) = 2005;

#Ingressos obtinguts el 2005 per comanda.
SELECT c.customerName,o.orderNumber,o.orderDate,SUM(od.quantityOrdered * p.buyPrice) AS Import_Total
from orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON c.customerNumber = o.customerNumber
where YEAR(o.orderDate) = 2005
GROUP BY customerName,orderNumber,orderDate
ORDER BY customerName,orderDate asc;

#Comandes realitzades de productes del venedor 'Welly Diecast Productions'. 
SELECT p.productVendor,p.productName,od.quantityOrdered,od.priceEach,c.customerName,o.orderDate
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON c.customerNumber = o.customerNumber
where p.productVendor = 'Welly Diecast Productions'
ORDER BY productName,orderDate DESC;

