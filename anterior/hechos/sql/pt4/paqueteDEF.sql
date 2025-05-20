CREATE SEQUENCE SEQ_INVENTORIES_LOG START WITH 1;



CREATE OR REPLACE TRIGGER TR_inventory_log_Fernandez
AFTER INSERT OR UPDATE ON inventories
FOR EACH ROW
BEGIN
    INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
    VALUES (SEQ_INVENTORIES_LOG.NEXTVAL, :NEW.product_id, :NEW.warehouse_id, :NEW.quantity, SYSDATE);
END;

CREATE OR REPLACE PACKAGE PKG_update_inventories_Fernandez_D AS
    FUNCTION F_update_inventory_Fernandez_D(
        p_codi_producte IN NUMBER,
        p_warehouse_id IN NUMBER,
        p_quantitat IN NUMBER
    ) RETURN BOOLEAN;
    
    FUNCTION F_update_inventories_Fernandez_D(
        p_codi_producte IN NUMBER,
        p_codis_pais IN VARCHAR2,
        p_quantitat IN NUMBER
    ) RETURN NUMBER;
    PROCEDURE P_inventories_log_init_Fernandez_D;

END;
/

CREATE OR REPLACE PACKAGE BODY PKG_update_inventories_Fernandez_D AS
    FUNCTION F_update_inventory_Fernandez_D (
        p_codi_producte IN NUMBER,
        p_warehouse_id IN NUMBER,
        p_quantitat IN NUMBER
    ) RETURN BOOLEAN IS
        v_inventory_count NUMBER;
    BEGIN
        SELECT quantity INTO v_inventory_count
        FROM inventories
        WHERE product_id = p_codi_producte
        AND warehouse_id = p_warehouse_id
        FOR UPDATE;

        IF v_inventory_count IS NOT NULL THEN
            UPDATE inventories
            SET quantity = v_inventory_count + p_quantitat
            WHERE product_id = p_codi_producte
            AND warehouse_id = p_warehouse_id;
        ELSE
            INSERT INTO inventories (product_id, warehouse_id, quantity)
            VALUES (p_codi_producte, p_warehouse_id, p_quantitat);
        END IF;

        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO inventories (product_id, warehouse_id, quantity)
            VALUES (p_codi_producte, p_warehouse_id, p_quantitat);
            RETURN TRUE;
        WHEN OTHERS THEN
            RETURN FALSE;
    END F_update_inventory_Fernandez_D;

    FUNCTION F_update_inventories_Fernandez_D(
        p_codi_producte IN NUMBER,
        p_codis_pais IN VARCHAR2,
        p_quantitat IN NUMBER
    ) RETURN NUMBER IS
        v_total_reposat NUMBER := 0;
        v_product_count NUMBER;
        v_country_count NUMBER;
        v_warehouse_count NUMBER;
        CURSOR c_warehouses IS
            SELECT w.warehouse_id 
            FROM warehouses w
            JOIN locations l ON w.location_id = l.location_id
            WHERE l.country_id IN (
                SELECT REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL)  --https://stackoverflow.com/questions/3710589/is-there-a-function-to-split-a-string-in-oracle-pl-sql
                FROM dual 
                CONNECT BY REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL) IS NOT NULL
            );
    BEGIN
        SELECT COUNT(*) INTO v_product_count FROM products WHERE product_id = p_codi_producte;
        IF v_product_count = 0 THEN
             RETURN -2; 
        END IF;

        SELECT COUNT(*) INTO v_country_count 
        FROM countries 
        WHERE country_id IN (
            SELECT REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL)
            FROM dual 
            CONNECT BY REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL) IS NOT NULL
        );
        
        IF v_country_count < LENGTH(p_codis_pais) - LENGTH(REPLACE(p_codis_pais, ',', '')) + 1 THEN
            RETURN -1; 
        END IF;
        
        SELECT COUNT(*) INTO v_warehouse_count
        FROM warehouses w
        JOIN locations l ON w.location_id = l.location_id
        WHERE l.country_id IN (
            SELECT REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL)
            FROM dual 
            CONNECT BY REGEXP_SUBSTR(p_codis_pais, '[^,]+', 1, LEVEL) IS NOT NULL
        );
        
        IF v_warehouse_count = 0 THEN
            RETURN 0; 
        END IF;
        
        FOR wh IN c_warehouses LOOP
            IF F_update_inventory_Fernandez_D(p_codi_producte, wh.warehouse_id, p_quantitat) THEN
                v_total_reposat := v_total_reposat + p_quantitat;
            END IF;
        END LOOP;

        IF v_total_reposat = 0 THEN 
            RETURN 0;
        END IF;
        
        RETURN v_total_reposat;
    EXCEPTION
        WHEN OTHERS THEN RETURN -1;
    END F_update_inventories_Fernandez_D;

    PROCEDURE P_inventories_log_init_Fernandez_D IS
    BEGIN
        FOR inventory IN (SELECT product_id, warehouse_id, quantity FROM inventories) LOOP
            INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
            VALUES (SEQ_INVENTORIES_LOG.NEXTVAL, inventory.product_id, inventory.warehouse_id, inventory.quantity, SYSDATE);
        END LOOP;
        COMMIT;
    END P_inventories_log_init_Fernandez_D;
END; 



DECLARE
    v_result NUMBER;
BEGIN
    v_result := PKG_update_inventories_Fernandez_D.F_update_inventories_Fernandez_D(101, 'CN,US,AU', 1);
    DBMS_OUTPUT.PUT_LINE('Inventari actualizat: ' || v_result);
    
    v_result := PKG_update_inventories_Fernandez_D.F_update_inventories_Fernandez_D(101, 'CN,XX,AU', 1);
    DBMS_OUTPUT.PUT_LINE('Llista invalida: ' || v_result);
    
    v_result := PKG_update_inventories_Fernandez_D.F_update_inventories_Fernandez_D(101, 'FR,DE,UK', 1);
    DBMS_OUTPUT.PUT_LINE('Pais sense magatzems: ' || v_result);
END;

