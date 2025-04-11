-- ==================================================================
-- NOM: Denis <tu_apellido>
-- MÒDUL: MP02. Bases de dades
-- RA: RA5. Llenguatge PL/SQL
-- EXERCICI: Exercici2
-- FITXER: M2_RA5_PR4_EX2_Denis.sql
-- ==================================================================

-- PAQUET: PKG_update_inventories_Denis

-- ESPECIFICACIÓ DEL PAQUET
CREATE OR REPLACE PACKAGE PKG_update_inventories_Denis AS
    FUNCTION F_update_inventory_Denis(
        p_product_id  IN NUMBER,
        p_warehouse_id IN NUMBER,
        p_quantity     IN NUMBER
    ) RETURN BOOLEAN;

    FUNCTION F_update_inventories_Denis(
        p_product_id  IN NUMBER,
        p_country_ids IN VARCHAR2,
        p_quantity     IN NUMBER
    ) RETURN NUMBER;

    FUNCTION validar_paisos_Denis(p_country_ids IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION validar_magatzems_Denis(p_country_ids IN VARCHAR2) RETURN BOOLEAN;

    PROCEDURE P_inventories_log_init_Denis;
END PKG_update_inventories_Denis;
/

-- COS DEL PAQUET
CREATE OR REPLACE PACKAGE BODY PKG_update_inventories_Denis AS

    FUNCTION validar_paisos_Denis(p_country_ids IN VARCHAR2) RETURN BOOLEAN IS
        v_country_count NUMBER;
        v_expected_count NUMBER := LENGTH(p_country_ids) - LENGTH(REPLACE(p_country_ids, ',')) + 1;
    BEGIN
        SELECT COUNT(DISTINCT country_id)
        INTO v_country_count
        FROM countries
        WHERE country_id IN (
            SELECT REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL)
            FROM dual
            CONNECT BY REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL) IS NOT NULL
        );

        RETURN v_country_count = v_expected_count;
    END validar_paisos_Denis;

    FUNCTION validar_magatzems_Denis(p_country_ids IN VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM warehouses
        WHERE country_id IN (
            SELECT REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL)
            FROM dual
            CONNECT BY REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL) IS NOT NULL
        );

        RETURN v_count > 0;
    END validar_magatzems_Denis;

    FUNCTION F_update_inventory_Denis(
        p_product_id  IN NUMBER,
        p_warehouse_id IN NUMBER,
        p_quantity     IN NUMBER
    ) RETURN BOOLEAN IS
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists
        FROM inventories
        WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;

        IF v_exists > 0 THEN
            UPDATE inventories
            SET quantity = quantity + p_quantity
            WHERE product_id = p_product_id AND warehouse_id = p_warehouse_id;
        ELSE
            INSERT INTO inventories(product_id, warehouse_id, quantity)
            VALUES (p_product_id, p_warehouse_id, p_quantity);
        END IF;

        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END F_update_inventory_Denis;

    FUNCTION F_update_inventories_Denis(
        p_product_id  IN NUMBER,
        p_country_ids IN VARCHAR2,
        p_quantity     IN NUMBER
    ) RETURN NUMBER IS
        v_total_added     NUMBER := 0;
        v_product_exists  NUMBER;

        CURSOR cur_warehouses IS
            SELECT warehouse_id FROM warehouses
            WHERE country_id IN (
                SELECT REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL)
                FROM dual
                CONNECT BY REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL) IS NOT NULL
            );
    BEGIN
        SELECT COUNT(*) INTO v_product_exists FROM products WHERE product_id = p_product_id;
        IF v_product_exists = 0 THEN
            RETURN -2;
        END IF;

        IF NOT validar_paisos_Denis(p_country_ids) THEN
            RETURN -1;
        END IF;

        IF NOT validar_magatzems_Denis(p_country_ids) THEN
            RETURN 0;
        END IF;

        FOR rec IN cur_warehouses LOOP
            IF F_update_inventory_Denis(p_product_id, rec.warehouse_id, p_quantity) THEN
                v_total_added := v_total_added + p_quantity;
            END IF;
        END LOOP;

        RETURN v_total_added;
    END F_update_inventories_Denis;

    PROCEDURE P_inventories_log_init_Denis IS
    BEGIN
        INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
        SELECT SEQ_INVENTORIES_LOG.NEXTVAL, product_id, warehouse_id, quantity, SYSDATE
        FROM inventories;
        COMMIT;
    END P_inventories_log_init_Denis;

END PKG_update_inventories_Denis;
/

-- JOC DE PROVES
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 1: Producte inexistent => Esperat: -2');
    DBMS_OUTPUT.PUT_LINE(PKG_update_inventories_Denis.F_update_inventories_Denis(9999, 'US,CA', 10));

    DBMS_OUTPUT.PUT_LINE('Test 2: País invàlid => Esperat: -1');
    DBMS_OUTPUT.PUT_LINE(PKG_update_inventories_Denis.F_update_inventories_Denis(4, 'XX,YY', 10));

    DBMS_OUTPUT.PUT_LINE('Test 3: Cap magatzem => Esperat: 0');
    DBMS_OUTPUT.PUT_LINE(PKG_update_inventories_Denis.F_update_inventories_Denis(4, 'IS', 10));

    DBMS_OUTPUT.PUT_LINE('Test 4: Reposar inventari OK');
    DBMS_OUTPUT.PUT_LINE(PKG_update_inventories_Denis.F_update_inventories_Denis(4, 'US,CA', 5));

    -- Inicialitzar log
    PKG_update_inventories_Denis.P_inventories_log_init_Denis;
    DBMS_OUTPUT.PUT_LINE('Log inicialitzat.');
END;
/
