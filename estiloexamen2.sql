/**📝 Enunciado de la función f_salesman_orders:
Crea una funció anomenada f_salesman_orders que rebi com a paràmetres
 l'identificador d'un empleat (p_emp_id) i un any (p_year). 

La funció ha de retornar la quantitat total de comandes realitzades per
 aquest empleat durant l'any indicat només si:

Cap dels paràmetres és NULL. En cas contrari, la funció ha de retornar NULL.

L'empleat existeix a la base de dades. Si no existeix, ha de retornar NULL.

L'empleat és un venedor (per exemple, que tingui un job_id relacionat 
amb vendes com 'SA_REP' o similar). Si no ho és, ha de retornar NULL.

L'any indicat és vàlid, és a dir, ha d'estar dins d’un rang acceptable 
com ara entre 1990 i l'any actual. Si l’any és incorrecte, la funció ha de retornar NULL.

Si totes les condicions anteriors es compleixen, ha de retornar
 el nombre total de comandes (orders) associades a aquest empleat 
 durant l'any indicat.

La funció ha de retornar un valor de tipus NUMBER.**/
CREATE OR REPLACE FUNCTION f_salesman_orders(p_emp_id IN NUMBER, p_year IN NUMBER)
RETURN NUMBER 
IS
    v_total NUMBER := 0;
    v_JOB_TITLE EMPLOYEES.JOB_TITLE%TYPE;
BEGIN
    IF p_emp_id IS NULL OR p_year IS NULL THEN
        RETURN NULL;
    ELSIF p_year < 1990 OR p_year > 2025 THEN
        RETURN NULL;
    END IF;

    BEGIN
        SELECT job_title INTO v_JOB_TITLE
        FROM EMPLOYEES
        WHERE employee_id = p_emp_id;

        IF v_JOB_TITLE != 'Sales Representative' THEN  
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN TOO_MANY_ROWS THEN
            RETURN NULL;
    END;

    SELECT COUNT(*) INTO v_total
    FROM ORDERS
    WHERE EXTRACT(YEAR FROM order_date) = p_year
      AND salesman_id = p_emp_id;

    RETURN v_total;

EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;



/**
📝 Enunciado del procedimiento P_emp_dept_hist:
Crea un procediment anomenat P_emp_dept_hist que rebi com a paràmetre 
l’identificador 
d’un departament (p_dept_id de tipus NUMBER).
 Aquest procediment ha de mostrar per pantalla (amb DBMS_OUTPUT.PUT_LINE)
 
  l’historial de departament dels empleats que han treballat
  
en aquest departament, amb la següent lògica:

Si el paràmetre és NULL, no ha de fer res o pot mostrar
 un missatge indicant que el valor és nul.

Si el departament no existeix a la taula departments, ha 
d'indicar-ho i finalitzar l'execució.

Si el departament existeix però no té empleats, 
ha d’indicar que no hi ha treballadors associats.

Si el departament té treballadors, ha de mostrar
 la informació dels empleats i el seu historial de departament 
 
 (per exemple,
 
 
 
  els períodes en què han treballat allà, càrrec, data d'inici i final, etc.).

La informació es pot extreure de les taules 
employees i job_history, o d'una estructura similar.

**/

CREATE OR REPLACE PROCEDURE P_emp_dept_hist (
    p_dept_id IN NUMBER
) IS
    CURSOR cur IS
        SELECT e.first_name, e.last_name, j.start_date, j.end_date
        FROM employees e
        JOIN job_history j ON j.employee_id = e.employee_id
        WHERE e.department_id = p_dept_id;

    CURSOR cur2 IS
        SELECT department_id FROM departments;

    v_dept_exists BOOLEAN := FALSE;  
BEGIN
    IF p_dept_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('ID de departament null');
        RETURN; 
    END IF;

    FOR dep IN cur2 LOOP
        IF dep.department_id = p_dept_id THEN
            v_dept_exists := TRUE;  
            EXIT; 
        END IF;
    END LOOP;

    IF NOT v_dept_exists THEN
        DBMS_OUTPUT.PUT_LINE('El departament no existeix');
        RETURN; 
    END IF;

    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM employees
        WHERE department_id = p_dept_id;

        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('El departament no té treballadors');
            RETURN;
        END IF;
        FOR empleat IN cur LOOP
            DBMS_OUTPUT.PUT_LINE('Empleat ' || empleat.first_name || ' ' || empleat.last_name || 
                                 ' va ser contractat al ' || empleat.start_date || ' i es va anar el ' || 
                                 empleat.end_date);
        END LOOP;
    END;
END;
