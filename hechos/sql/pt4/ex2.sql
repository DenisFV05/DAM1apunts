CREATE OR REPLACE FUNCTION F_update_inventory_Fernandez_D (
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
END;
