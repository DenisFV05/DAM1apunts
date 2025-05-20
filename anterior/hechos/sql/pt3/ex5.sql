CREATE OR REPLACE PROCEDURE PujarSalari IS
    CURSOR cur IS
        SELECT m.employee_id AS manager_id, 
               m.salary AS manager_salary, 
               m.first_name,m.last_name 
               FROM employees m
               WHERE m.manager_id IS NOT NULL
               FOR UPDATE; 

    augment NUMBER; 
    v_employees_count NUMBER;
BEGIN
    FOR manager IN cur LOOP
        SELECT COUNT(*)
        INTO v_employees_count
        FROM employees e
        WHERE e.manager_id = manager.manager_id;

        IF v_employees_count <= 5 THEN
            augment := 100 * v_employees_count;
        ELSE
            augment := 85 * v_employees_count;
        END IF;

        UPDATE employees
        SET salary = salary + augment
        WHERE employee_id = manager.manager_id;

        DBMS_OUTPUT.PUT_LINE('Nom del cap: ' || manager.first_name || ' ' || manager.last_name);
        DBMS_OUTPUT.PUT_LINE('Numero treballadors: ' || v_employees_count);
        DBMS_OUTPUT.PUT_LINE('Salari previ al augment: ' || manager.manager_salary);
        DBMS_OUTPUT.PUT_LINE('Augment: ' || augment);
        DBMS_OUTPUT.PUT_LINE('Salari amb augment: ' || (manager.manager_salary + augment));
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 36, '-'));  

    END LOOP;

    COMMIT;
END;

BEGIN
    PujarSalari;
END;
/




