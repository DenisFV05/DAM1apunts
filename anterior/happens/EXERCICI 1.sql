--EXERCICI 1
CREATE OR REPLACE FUNCTION F1_OldEmployeeCount_Bargados_D (
    id_departament IN NUMBER
) RETURN NUMBER 
IS
    antics_empleats NUMBER;
BEGIN
    SELECT OLD_EMPLOYEE_COUNT
    INTO antics_empleats
    FROM departments
    WHERE department_id = id_departament;

    RETURN antics_empleats;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; 
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END;


DECLARE
    resultat NUMBER;
BEGIN
    v_result := F1_OldEmployeeCount_Bargados_D(10);
    DBMS_OUTPUT.PUT_LINE('Numero de treballadors antics: ' || resultat);
END;


--EXERCICI 2
 alter table departments modify department_name VARCHAR(50);

--Comprova l’estat dels objectes de la teva BD HR:
SELECT object_name, object_type, status FROM user_objects;





--hi surten algunes funcions invalidades al fer camvis a la taula, per arreglar-ho haurem de recompilar la funció amb:
ALTER FUNCTION F1_DEPARTAMENT_BARGADOS_DAVID COMPILE;
ALTER PROCEDURE P1_COMISSIO_BARGADOS_DAVID COMPILE;


--EXERCICI 3:

--DADES
UPDATE departments
SET old_employee_count = 14
WHERE department_id IN (10);

UPDATE departments
SET old_employee_count = 18
WHERE department_id IN (20, 30, 40, 50, 60, 70, 80, 90,100, 110, 120, 130,140,150, 160, 170, 180, 190, 200);



CREATE OR REPLACE PROCEDURE P1_OldEmployeeCount_Bargados_D IS
    v_department_id NUMBER := 10;  
    v_old_employees NUMBER := 0;    
    v_total_old_employees NUMBER := 0; 
    v_departaments_actualitzats NUMBER := 0; 
BEGIN
    WHILE v_department_id <= 200 LOOP
        v_old_employees := F1_OldEmployeeCount_Bargados_D(v_department_id);
        IF v_old_employees IS NOT NULL THEN
            UPDATE departments
            SET OLD_EMPLOYEE_COUNT = v_old_employees
            WHERE department_id = v_department_id;
            v_departaments_actualitzats := v_departaments_actualitzats + 1;
            v_total_old_employees := v_total_old_employees + v_old_employees;
        END IF;
        v_department_id := v_department_id + 10;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('------------- ANTICS TREBALLADOR DE 10 a 200 ---------');
    DBMS_OUTPUT.PUT_LINE('TOTAL DEPARTAMENTS: ' || v_departaments_actualitzats);
    DBMS_OUTPUT.PUT_LINE('TOTAL TREBALLADORS: ' || v_total_old_employees);
    
END;

BEGIN
    P1_OldEmployeeCount_Bargados_D;
END;















CREATE OR REPLACE PROCEDURE P1_OldEmployeeCount_Bargados_D IS
    v_department_id NUMBER := 10;  
    v_old_employees NUMBER := 0;    
    v_total_old_employees NUMBER := 0; 
    v_departaments_actualitzats NUMBER := 0; 
BEGIN
    WHILE v_department_id <= 200 LOOP
        v_old_employees := F1_OldEmployeeCount_Bargados_D(v_department_id);
        IF v_old_employees IS NOT NULL THEN
            UPDATE departments
            SET OLD_EMPLOYEE_COUNT = v_old_employees
            WHERE department_id = v_department_id;
            v_departaments_actualitzats := v_departaments_actualitzats + 1;
            v_total_old_employees := v_total_old_employees + v_old_employees;
        END IF;
        v_department_id := v_department_id + 10;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('------------- ANTICS TREBALLADOR DE 10 a 200 ---------');
    DBMS_OUTPUT.PUT_LINE('TOTAL DEPARTAMENTS: ' || v_departaments_actualitzats);
    DBMS_OUTPUT.PUT_LINE('TOTAL TREBALLADORS: ' || v_total_old_employees);
    
END;



BEGIN
    P1_OldEmployeeCount_Bargados_D;
END;