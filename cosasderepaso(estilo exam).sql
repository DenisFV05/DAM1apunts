--EXERCICI 1 – FUNCTION (BD botiga) (3,5 punts)
--Crea una funció que, donat el codi d’un producte, retorni el preu total de l’estoc disponible (preu_unitari * quantitat en estoc). Si el producte no existeix, ha de retornar -1.


CREATE OR REPLACE FUNCTION retornar_preu(codi IN NUMBER) RETURN NUMBER IS
    preu_total NUMBER;
BEGIN
    SELECT p.STANDARD_COST * i.quantity
    INTO preu_total
    FROM PRODUCTS p
    JOIN INVENTORIES i ON p.product_id = i.product_id
    WHERE p.product_id = codi;

    RETURN preu_total;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; 
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;


DECLARE
    preu NUMBER;
BEGIN
    preu := retornar_preu(254);
    DBMS_OUTPUT.PUT_LINE(reu total del producte amb id 254" || preu);
END;

--EXERCICI 2 – PROCEDURE (BD HR) (3,5 punts)
--Crea una procedura que, donat un identificador d’empleat, 
--actualitzi el seu salari incrementant-lo en un percentatge passat 
--com a paràmetre.
-- La procedura ha de mostrar el salari antic i el nou per pantalla. 
--Si l’empleat no existeix, ha de mostrar un missatge d’error.

CREATE OR REPLACE PROCEDURE Actualitzar_Salari (
    p_augment IN NUMBER,  
    emp_id IN NUMBER
) IS
    CURSOR cur IS
        SELECT employee_id, salary
        FROM employees
        WHERE employee_id = emp_id
        FOR UPDATE;

    v_salary_antic NUMBER;
    v_salary_nou   NUMBER;

BEGIN
    FOR TREBALLADOR IN cur LOOP
        v_salary_antic := TREBALLADOR.salary;
        v_salary_nou := TREBALLADOR.salary * p_augment;
        UPDATE employees
        SET salary = v_salary_nou
        WHERE employee_id = TREBALLADOR.employee_id;

        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || TREBALLADOR.employee_id);
        DBMS_OUTPUT.PUT_LINE('Salari antic: ' || v_salary_antic);
        DBMS_OUTPUT.PUT_LINE('Salari nou: ' || v_salary_nou);
    END LOOP;

    COMMIT;
END;


--EXERCICI 3 – PACKAGE (BD HR) (3 punts)
--Crea un package amb:

--Una funció que retorni el nombre d’empleats en un departament passat com a paràmetre.

--Una procedura que mostri per pantalla el llistat de noms d’empleats d’un departament passat com a paràmetre.
--Gestiona el cas que el departament no existeixi.

CREATE OR REPLACE FUNCTION nom_empleats(codi IN NUMBER) RETURN NUMBER IS
    nombre_empleats NUMBER;
BEGIN
    SELECT COUNT(*) INTO  nombre_empleats FROM employees WHERE department_id = codi;
    RETURN nombre_empleats;
END;
DECLARE
    nombre_empleats NUMBER;
BEGIN
    nombre_empleats := nom_empleats(90);
    DBMS_OUTPUT.PUT_LINE("Treballadors per departament" || nombre_empleats);
END;

CREATE OR REPLACE PROCEDURE MostrarEmpleats (p_dept_id IN NUMBER)
IS
    CURSOR cur IS
        SELECT first_name, last_name 
        FROM employees 
        WHERE department_id = p_dept_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || p_dept_id);
    
    FOR TREBALLADOR IN cur LOOP
        DBMS_OUTPUT.PUT_LINE('Empleat: ' || TREBALLADOR.first_name || ' ' || TREBALLADOR.last_name);
    END LOOP;
END;
/
BEGIN
    MostrarEmpleats(90);
END;
/
CREATE OR REPLACE PACKAGE paquet_practicar AS
    FUNCTION nom_empleats(codi IN NUMBER) RETURN NUMBER;
    PROCEDURE MostrarEmpleats(p_dept_id IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY paquet_practicar AS

    FUNCTION nom_empleats(codi IN NUMBER) RETURN NUMBER IS
        nombre_empleats NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nombre_empleats 
        FROM employees 
        WHERE department_id = codi;
        
        RETURN nombre_empleats;
    END nom_empleats;

    PROCEDURE MostrarEmpleats(p_dept_id IN NUMBER) IS
        CURSOR cur IS
            SELECT first_name, last_name 
            FROM employees 
            WHERE department_id = p_dept_id;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('PAQUET: Department ID: ' || p_dept_id);
        
        FOR TREBALLADOR IN cur LOOP
            DBMS_OUTPUT.PUT_LINE('PAQUET:Empleat: ' || TREBALLADOR.first_name || ' ' || TREBALLADOR.last_name);
        END LOOP;
    END MostrarEmpleats;

END paquet_practicar;
/
-- Mostrar número d'empleats
DECLARE
    total NUMBER;
BEGIN
    total := paquet_practicar.nom_empleats(90);
    DBMS_OUTPUT.PUT_LINE('PAQUET: Treballadors per departament: ' || total);
END;
/

-- Mostrar llista d'empleats
BEGIN
    paquet_practicar.MostrarEmpleats(90);
END;
/

CREATE OR REPLACE FUNCTION nom_empleats(codi IN NUMBER) RETURN NUMBER IS
    nombre_empleats NUMBER; -- variable donde guardar el resultado del select
BEGIN
    SELECT COUNT(*) INTO nombre_empleats FROM employees WHERE department_id = codi;
    RETURN nombre_empleats;
END;
