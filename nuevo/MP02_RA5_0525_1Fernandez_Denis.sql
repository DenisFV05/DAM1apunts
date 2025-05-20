-- Base de dades botiga, ejercicio completamente funcional !!!
-- Procedure para buscar cuantos almacenes tienen stock de un producto y que cantidad de producto hace falta reponer si en un almacen el stock esta por debajo del minimo
-- Parametros: product_id, hace falta comprobar que sea un codigo de producto válido, que exista y que no sea NULL. / stock minimo, sera la cantidad minima de stock de producto que tiene que haber en el almacen, no puede ser una cantidad negativa o 0
-- Si no se cumplen las condiciones, producto y stock validos, lanzar un mensaje indicando que los parametros no son correctos y terminar. Si los parametros son correctos hace falta buscar los almacenes donde hay el producto solicitado.
-- La relacion esta entre productos y inventarios, y entre inventarios y almacenes
-- En products para validar el codigo del producto, inventories para saber la cantidad de producto que hay en un almacen, warehouses para saber los datos del almacen. En la tabla inventories hay la cantidad de un producto en el almacen, si la cantidad es inferior al minimo en ese almacen hace falta reposar, añadir mas cantidad al producto
-- Si los parametros son correctos, hace falta listar los almacenes que tienen stock del producto. 
-- Hay 2 situaciones.
-- 1. No hay ningun almacen que contenga el producto, entonces listara lo siguiente: un mensaje de 3 lineas donde se muestren los parametros del procedimiento y un mensaje de que no hay ningun almacen
-- 2. Que haya almacenes, entonces se listaran los almacenes y se contara la cantidad de producto a reponer: una cabecera de 3 lineas mostrando los parametros del procedimiento, un detalle del almacen con su nombre y cantidad del producto que contiene, una linea de pie con el total de unidades que hace falta reposar, si hay mas de un almacen hace falta que se acumule la cantidad y decir el total, el total puede ser 0
CREATE OR REPLACE PROCEDURE p_sota_minims_Fernandez_Denis(
    p_product_id IN NUMBER,
    p_stock_minimo IN NUMBER
)
IS
    v_count_products NUMBER;
    v_total_reponer NUMBER := 0;
    v_stock_actual NUMBER;
    v_almacen_nombre VARCHAR2(100);
    
    CURSOR cur_almacenes IS
        SELECT w.warehouse_id, w.warehouse_name, i.quantity
        FROM inventories i
        JOIN warehouses w ON i.warehouse_id = w.warehouse_id
        WHERE i.product_id = p_product_id;
    
    -- Variable para controlar si hay almacenes con el producto
    v_almacenes_existen BOOLEAN := FALSE;
    
BEGIN
    -- Validar parámetros, si es null o <= 0 salta error
    IF p_product_id IS NULL OR p_stock_minimo IS NULL OR p_stock_minimo <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Parámetros inválidos.');
        DBMS_OUTPUT.PUT_LINE('product_id: ' || NVL(TO_CHAR(p_product_id), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('stock_minimo: ' || NVL(TO_CHAR(p_stock_minimo), 'NULL'));
        RETURN;
    END IF;
    
    -- Comprobar si el producto existe
    SELECT COUNT(*) INTO v_count_products FROM products WHERE product_id = p_product_id;
    IF v_count_products = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Producto no existe.');
        DBMS_OUTPUT.PUT_LINE('product_id: ' || p_product_id);
        RETURN;
    END IF;
    
    -- Abrir cursor para recorrer los almacenes con producto
    -- v_almacen_nombre lo repito por el momento  

    DBMS_OUTPUT.PUT_LINE('The product researched is:' || p_product_id);
    DBMS_OUTPUT.PUT_LINE('The minimum stock is:' || p_stock_minimo);
    DBMS_OUTPUT.PUT_LINE('The list of warehouses:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    OPEN cur_almacenes;
    LOOP
        FETCH cur_almacenes INTO v_almacen_nombre, v_almacen_nombre, v_stock_actual;
        EXIT WHEN cur_almacenes%NOTFOUND;
        
        v_almacenes_existen := TRUE;
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_almacen_nombre, 22) || ' ' ||
            RPAD(v_stock_actual || ' units' , 22) 
        );
        
        IF v_stock_actual < p_stock_minimo THEN
            v_total_reponer := v_total_reponer + (p_stock_minimo - v_stock_actual);
        END IF;
    END LOOP;
    CLOSE cur_almacenes;
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TOTAL units to repurpose: ' || v_total_reponer);

    -- Si no hay almacenes con el producto
    IF NOT v_almacenes_existen THEN
        DBMS_OUTPUT.PUT_LINE('The product researched is: ' || p_product_id);
        DBMS_OUTPUT.PUT_LINE('The minimum stock is: ' || p_stock_minimo);
        DBMS_OUTPUT.PUT_LINE('There are NO warehouses for this product.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('TOTAL units to repurpose: ' || v_total_reponer); -- Por si acaso
    END IF;
END;
/
