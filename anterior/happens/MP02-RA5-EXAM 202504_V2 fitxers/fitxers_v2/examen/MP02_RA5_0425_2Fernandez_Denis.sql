CREATE OR REPLACE PROCEDURE p_last_managers_hired_Fernandez_Denis(n IN NUMBER)
IS
    -- Cursor que selecciona directamente de EMPLOYEES y JOBS
    CURSOR c_managers IS
        SELECT e.first_name, e.last_name, TO_CHAR(e.hire_date, 'DD-MM-YYYY') AS hire_date, j.job_title
        FROM employees e
        JOIN jobs j ON e.job_id = j.job_id
        WHERE LOWER(j.job_title) LIKE '%manager%'
        ORDER BY e.hire_date DESC;

    -- Variables para guardar los valores del cursor
    v_first_name EMPLOYEES.FIRST_NAME%TYPE;
    v_last_name EMPLOYEES.LAST_NAME%TYPE;
    v_hire_date VARCHAR2(20); -- porque usamos TO_CHAR
    v_job_title JOBS.JOB_TITLE%TYPE;
    v_total NUMBER := 0;
BEGIN
    -- Validación
    IF n IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El valor de N no puede ser NULL.');
        RETURN;
    ELSIF n <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El valor de N debe ser mayor que 0.');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('The list of latest hired managers is:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    OPEN c_managers;
    LOOP
        FETCH c_managers INTO v_first_name, v_last_name, v_hire_date, v_job_title;
        EXIT WHEN c_managers%NOTFOUND OR v_total >= n;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_first_name, 12) || ' ' ||
            RPAD(v_last_name, 12) || ' ' ||
            RPAD(v_hire_date, 12) || ' ' ||
            v_job_title
        );
        v_total := v_total + 1;
    END LOOP;
    CLOSE c_managers;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TOTAL found: ' || v_total);
END;
/
