CREATE OR REPLACE FUNCTION F_salari_total_rang_Fernandez_D ( 
    p_rang1 IN NUMBER, 
    p_rang2 IN NUMBER 
) 
RETURN NUMBER 
IS 
    v_total_salary NUMBER := 0; 
    v_employee_salary employees.salary%TYPE; 
    v_rangInici NUMBER; 
    v_rangFinal NUMBER; 
    
    CURSOR c_employees IS 
        SELECT salary 
        FROM employees 
        WHERE salary BETWEEN v_rangInici AND v_rangFinal; 

BEGIN 
    IF p_rang1 IS NULL AND p_rang2 IS NULL THEN
        v_rangInici := 0;
        v_rangFinal := 1000000; 
    ELSIF p_rang1 IS NULL THEN
        v_rangInici := 0;
        v_rangFinal := p_rang2;
    ELSIF p_rang2 IS NULL THEN
        v_rangInici := 0;
        v_rangFinal := p_rang1;
    ELSE
        IF p_rang1 > p_rang2 THEN
            v_rangInici := p_rang2;
            v_rangFinal := p_rang1;
        ELSE
            v_rangInici := p_rang1;
            v_rangFinal := p_rang2;
        END IF;
    END IF;

    OPEN c_employees; 
    LOOP 
        FETCH c_employees INTO v_employee_salary; 
        EXIT WHEN c_employees%NOTFOUND; 
        v_total_salary := v_total_salary + v_employee_salary; 
    END LOOP; 
    CLOSE c_employees; 

    RETURN v_total_salary; 

EXCEPTION
    WHEN OTHERS THEN
        IF c_employees%ISOPEN THEN 
            CLOSE c_employees; 
        END IF;
        RETURN NULL; 
END;

--JOC DE PROVES
DECLARE
    v_total NUMBER;
BEGIN
    v_total := F_salari_total_rang_Fernandez_D(3000, 7000);
    DBMS_OUTPUT.PUT_LINE('Salari total (3000-7000): ' || v_total);

    v_total := F_salari_total_rang_Fernandez_D(NULL, NULL);
    DBMS_OUTPUT.PUT_LINE('Salari total (NULL, NULL): ' || v_total);

    v_total := F_salari_total_rang_Fernandez_D(NULL, 7000);
    DBMS_OUTPUT.PUT_LINE('Salari total (NULL, 7000): ' || v_total);
END;

    