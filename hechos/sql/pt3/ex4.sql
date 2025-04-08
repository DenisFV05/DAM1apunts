CREATE OR REPLACE FUNCTION quantitat_producte_BargadosD(
    v_pais IN VARCHAR2,
    v_categoria IN VARCHAR2
)
RETURN NUMBER  
IS
    v_total NUMBER := 0;  

    CURSOR cur IS
        SELECT p.PRODUCT_NAME, 
               i.QUANTITY,
               w.WAREHOUSE_NAME  
        FROM COUNTRIES c
        JOIN LOCATIONS l ON c.COUNTRY_ID = l.COUNTRY_ID
        JOIN WAREHOUSES w ON l.LOCATION_ID = w.LOCATION_ID
        JOIN INVENTORIES i ON w.WAREHOUSE_ID = i.WAREHOUSE_ID
        JOIN PRODUCTS p ON i.PRODUCT_ID = p.PRODUCT_ID
        JOIN PRODUCT_CATEGORIES pc ON p.CATEGORY_ID = pc.CATEGORY_ID
        WHERE c.COUNTRY_NAME = v_pais
        AND pc.CATEGORY_NAME = v_categoria;

BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('PRODUCT_NAME', 50) || ' | ' || RPAD('QUANTITY', 10) || ' | ' || 'WAREHOUSE_NAME'|| '| ' );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-') || ' | ' || RPAD('-', 10, '-') || ' | ' || RPAD('-', 14, '-')|| '| ');
    FOR product IN cur LOOP
        v_total := v_total + product.QUANTITY;
        DBMS_OUTPUT.PUT_LINE(RPAD(product.PRODUCT_NAME, 50) || ' | ' || RPAD(product.QUANTITY, 10) || ' | ' || RPAD(product.WAREHOUSE_NAME, 13)  || ' | ');
    END LOOP;
    RETURN v_total;
END;


--JOC DE PROVES
DECLARE
    resultat NUMBER;
BEGIN
    resultat := quantitat_producte_BargadosD('Australia', 'CPU');
    DBMS_OUTPUT.PUT_LINE('Total  disponibles: ' || resultat);
END;
/
