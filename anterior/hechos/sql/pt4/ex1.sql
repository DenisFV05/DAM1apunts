CREATE OR REPLACE FUNCTION F_update_inventories_Fernandez_D(
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