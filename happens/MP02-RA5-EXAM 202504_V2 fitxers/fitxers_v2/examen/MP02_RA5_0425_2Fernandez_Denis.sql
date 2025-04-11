-- procediment p_last_managers_hired_Fernandez_Denis lista n managers d'un departament mes nous

-- parametre n(num de managers) no pot ser null

-- dades a llistar FIRST__NAME, LAST_NAME, HIRE_DATE, JOB_TITLE

-- formato como el enunciado

CREATE OR REPLACE PROCEDURE p_last_managers_hired_Fernandez_Denis(n IN NUMBER)
IS
v_count NUMBER;

BEGIN

    
END;









CREATE OR REPLACE PROCEDURE listar_empleados_departamento(p_dept_id IN NUMBER) IS
    v_emp_count NUMBER;
    
    CURSOR cur_empleados IS
        SELECT e.first_name, e.last_name,
               TO_CHAR(e.hire_date, 'DD-MM-YYYY') AS hire_date,
               j.job_title
          FROM employees e
          JOIN jobs j ON e.job_id = j.job_id
         WHERE e.department_id = p_dept_id;
BEGIN
    -- Verificar que el parámetro no sea NULL
    IF p_dept_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('El departamento no puede ser NULL.');
        RETURN;
    END IF;
    
    -- Comprobar si existe el departamento
    BEGIN
        SELECT department_name INTO v_dept_name
          FROM departments
         WHERE department_id = p_dept_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No existe el departamento con ID ' || p_dept_id);
            RETURN;
    END;
    
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
    
    -- Contar número de empleados en el departamento
    SELECT COUNT(*)
      INTO v_emp_count
      FROM employees
     WHERE department_id = p_dept_id;
    
    IF v_emp_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El departamento no tiene empleados.');
    ELSE
        -- Iterar y mostrar los empleados
        FOR emp IN cur_empleados LOOP
            DBMS_OUTPUT.PUT_LINE(emp.first_name || ' ' || emp.last_name || ' | ' ||
                                     emp.hire_date || ' | ' || emp.job_title);
        END LOOP;
    END IF;
END;