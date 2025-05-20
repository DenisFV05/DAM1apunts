-- ==================================================================
-- NOM: Denis <tu_apellido>
-- MÒDUL: MP02. Bases de dades
-- RA: RA5. Llenguatge PL/SQL
-- EXERCICI: Exercici1
-- FITXER: M2_RA5_PR4_EX1_Denis.sql
-- ==================================================================

-- CREACIÓ DE SEQÜÈNCIA PER A INVENTORIES_LOG
CREATE SEQUENCE SEQ_INVENTORIES_LOG START WITH 1 INCREMENT BY 1;

-- FUNCIO AUXILIAR: Actualitza o insereix inventari per a un magatzem
CREATE OR REPLACE FUNCTION F_update_inventory_Denis (
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
END;
/

-- FUNCIO PRINCIPAL: Actualitza inventari en diversos magatzems segons país
CREATE OR REPLACE FUNCTION F_update_inventories_Denis (
    p_product_id IN NUMBER,
    p_country_ids IN VARCHAR2,
    p_quantity    IN NUMBER
) RETURN NUMBER IS
    v_total_added NUMBER := 0;
    v_country_count NUMBER;
    v_product_exists NUMBER;

    CURSOR cur_warehouses IS
        SELECT warehouse_id FROM warehouses
        WHERE country_id IN (
            SELECT REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL)
            FROM dual
            CONNECT BY REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL) IS NOT NULL
        );
BEGIN
    -- Comprovar si el producte existeix
    SELECT COUNT(*) INTO v_product_exists FROM products WHERE product_id = p_product_id;
    IF v_product_exists = 0 THEN
        RETURN -2;
    END IF;

    -- Comprovar que tots els països existeixen
    SELECT COUNT(DISTINCT country_id)
    INTO v_country_count
    FROM countries
    WHERE country_id IN (
        SELECT REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL)
        FROM dual
        CONNECT BY REGEXP_SUBSTR(p_country_ids, '[^,]+', 1, LEVEL) IS NOT NULL
    );

    IF v_country_count <> (LENGTH(p_country_ids) - LENGTH(REPLACE(p_country_ids, ',')) + 1) THEN
        RETURN -1;
    END IF;

    -- Processar magatzems
    FOR rec IN cur_warehouses LOOP
        IF F_update_inventory_Denis(p_product_id, rec.warehouse_id, p_quantity) THEN
            v_total_added := v_total_added + p_quantity;
        END IF;
    END LOOP;

    IF v_total_added = 0 THEN
        RETURN 0;
    ELSE
        RETURN v_total_added;
    END IF;
END;
/

-- TRIGGER: Registra canvis a INVENTORIES_LOG
CREATE OR REPLACE TRIGGER TR_inventory_log_Denis
AFTER INSERT OR UPDATE ON inventories
FOR EACH ROW
BEGIN
    INSERT INTO inventories_log(ilog_id, product_id, warehouse_id, quantity, created_at)
    VALUES (
        SEQ_INVENTORIES_LOG.NEXTVAL,
        :NEW.product_id,
        :NEW.warehouse_id,
        :NEW.quantity,
        SYSDATE
    );
END;
/

-- PROCEDURE: Inicialitza INVENTORIES_LOG amb l’estat actual
CREATE OR REPLACE PROCEDURE P_inventories_log_init_Denis IS
BEGIN
    INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
    SELECT SEQ_INVENTORIES_LOG.NEXTVAL, product_id, warehouse_id, quantity, SYSDATE
    FROM inventories;
    COMMIT;
END;
/

-- JOC DE PROVES
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 1: Producte inexistent => Esperat: -2');
    DBMS_OUTPUT.PUT_LINE(F_update_inventories_Denis(9999, 'US,CA', 10));

    DBMS_OUTPUT.PUT_LINE('Test 2: País invàlid => Esperat: -1');
    DBMS_OUTPUT.PUT_LINE(F_update_inventories_Denis(4, 'XX,YY', 10));

    DBMS_OUTPUT.PUT_LINE('Test 3: Cap magatzem en aquests països => Esperat: 0');
    DBMS_OUTPUT.PUT_LINE(F_update_inventories_Denis(4, 'IS', 10));

    DBMS_OUTPUT.PUT_LINE('Test 4: Reposar inventari OK => Retorna quantitat afegida');
    DBMS_OUTPUT.PUT_LINE(F_update_inventories_Denis(4, 'US,CA', 5));

    -- Inicialitzar log
    P_inventories_log_init_Denis;
    DBMS_OUTPUT.PUT_LINE('Inicialització del log feta.');
END;
/
