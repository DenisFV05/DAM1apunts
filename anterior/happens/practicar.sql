CREATE OR REPLACE FUNCTION ObtenirSalari(
    v_id IN NUMBER
)
RETURN NUMBER IS
    v_salari NUMBER;
BEGIN
    BEGIN
        SELECT salary INTO v_salari 
        FROM employees 
        WHERE employee_id = v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_salari := NULL;
    END;
    
    RETURN v_salari;
END;
/


DECLARE
    p_id NUMBER := 1;
    v_Salari NUMBER;
BEGIN
    v_Salari := ObtenirSalari(p_id);
    DBMS_OUTPUT.PUT_LINE('Salari = ' || (v_Salari));
END;
/
