/* 

CONSULTES A REALITZAR BD HR
1. (1 punt) Jobs que ha tingut un treballador, històric de jobs.
◦ Mostrar a cada fila:
▪ de l’empleat (id, nom, cognom)
▪ de l’històric (nom del job(jobtitle), nom departament, data inici i data fi).*/


SELECT e.employee_id, e.first_name, e.last_name,
       j.job_title AS job_title, d.department_name,
       jh.start_date, jh.end_date
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
JOIN jobs j ON jh.job_id = j.job_id
JOIN departments d ON jh.department_id = d.department_id
ORDER BY e.employee_id, jh.start_date;


/* 2. (1 punt) Mànagers de departaments que tenen més de 5 treballadors, sense contar
el propi mànager. Mostrar el nom sencer del mànager i el seu email.*/


SELECT e.employee_id AS manager_id, e.last_name AS manager_last_name, e.first_name AS manager_first_name, e.email
FROM departments d
JOIN employees e ON d.manager_id = e.employee_id
WHERE d.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 5);


/* 3. (1,5 punts) Departaments i el detall de la seva ubicació.◦ Mostrar per a cada departament:
▪ nom del departament
▪ nom del manager (id, nom, cognom)
▪ adreça i codi postal
▪ nom del país
▪ nom de la regió*/

SELECT d.department_name, e.employee_id AS manager_id, e.last_name AS manager_last_name, 
e.first_name AS manager_first_name, l.postal_code, l.street_address, c.country_name, r.region_name
FROM departments d
JOIN employees e ON d.manager_id = e.employee_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id;


/* CONSULTES A REALITZAR BD productes
4. (1,5 punts) Quantitat de customers per línia de producte.*/

SELECT pl.productLine, COUNT(DISTINCT c.customerNumber) AS quantitat_customers
FROM productlines pl   
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY pl.productLine;


/* 5. (1,5 punts) Clients que han comprat productes del venedor 'Motor City Art Classics'.
◦ Mostrar a cada fila:
▪ del client (número, nom, ciutat i país)
▪ de la comanda (data)
▪ dels productes (concatenar venedor i nom del producte)
◦ Ordenat per país. */

/* El uso de GROUP_CONCAT me lo preguntaste en un examen anterior y 
explique el porque de su uso por correo, por si acaso */

SELECT c.customerNumber, c.customerName, c.city, c.country,
       o.orderDate,
       GROUP_CONCAT(CONCAT(p.productVendor, ' - ', p.productName) SEPARATOR ', ') AS productos_comprados
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
WHERE p.productVendor = 'Motor City Art Classics'
GROUP BY c.customerNumber, o.orderDate
ORDER BY c.customerNumber, o.orderDate, c.city;