DROP SEQUENCE SEQ_INVENTORIES_LOG;
CREATE SEQUENCE SEQ_INVENTORIES_LOG START WITH 1;



CREATE OR REPLACE TRIGGER TR_inventory_log_Bargados
AFTER INSERT OR UPDATE ON inventories
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
BEGIN
    INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
    VALUES (SEQ_INVENTORIES_LOG.NEXTVAL, :NEW.product_id, :NEW.warehouse_id, :NEW.quantity, SYSDATE);
END;



CREATE OR REPLACE PROCEDURE P_inventories_log_init_Bargados_D IS
BEGIN
    FOR inventory IN (SELECT product_id, warehouse_id, quantity FROM inventories) LOOP
        INSERT INTO inventories_log (ilog_id, product_id, warehouse_id, quantity, created_at)
        VALUES (SEQ_INVENTORIES_LOG.NEXTVAL, inventory.product_id, inventory.warehouse_id, inventory.quantity, SYSDATE);
    END LOOP;
    COMMIT;
END;