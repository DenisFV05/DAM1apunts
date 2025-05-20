CREATE OR REPLACE PROCEDURE MostrarNom(
    dep_id IN NUMBER
) IS
    CURSOR emp_cursor IS
        SELECT first_name, last_name, salary
        FROM employees
        WHERE department_id = dep_id;

    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || ' amb salari ' || emp_rec.salary);
    END LOOP;
END;