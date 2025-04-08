CREATE OR REPLACE PROCEDURE P3_PagarBonusEmpleats_2017 IS
    v_limit_bonus NUMBER := 1000000; 
    v_total_bonus NUMBER := 0; 
    v_bonus NUMBER := 0;

    CURSOR cur IS
        SELECT EMPLOYEES.FIRST_NAME,
               EMPLOYEES.LAST_NAME,
               SUM(ORDER_ITEMS.QUANTITY * ORDER_ITEMS.UNIT_PRICE) AS ingresos
        FROM EMPLOYEES
        INNER JOIN ORDERS ON ORDERS.SALESMAN_ID = EMPLOYEES.EMPLOYEE_ID
        INNER JOIN ORDER_ITEMS ON ORDER_ITEMS.ORDER_ID = ORDERS.ORDER_ID
        WHERE EXTRACT(YEAR FROM ORDERS.ORDER_DATE) = 2017 --EXTRACT(YEAR) AGAFA L'ANY D'UNA DATA
        GROUP BY EMPLOYEES.FIRST_NAME, EMPLOYEES.LAST_NAME
        ORDER BY ingresos DESC;
    
BEGIN
    FOR empleat IN cur LOOP
        v_bonus := empleat.ingresos * 0.10; 
            IF (v_total_bonus + v_bonus) > v_limit_bonus THEN
            v_bonus := v_limit_bonus - v_total_bonus;  
        END IF;
        
        v_total_bonus := v_total_bonus + v_bonus;
        
        DBMS_OUTPUT.PUT_LINE('Empleat: ' || empleat.FIRST_NAME || ' ' || empleat.LAST_NAME);
        DBMS_OUTPUT.PUT_LINE('Bonus rebut: ' || v_bonus);
        DBMS_OUTPUT.PUT_LINE('Total dels bonus pagats: ' || v_total_bonus);
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 36, '-'));        
        IF v_total_bonus >= v_limit_bonus THEN
            EXIT;
        END IF;
    END LOOP;

END;

--EXECUTAR PROCEDURE
BEGIN
    P3_PagarBonusEmpleats_2017;
END;

