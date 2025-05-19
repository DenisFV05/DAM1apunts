-- Funcion f_prod_2017_Fernandez_Denis para saber QUANTITAT TOTAL PRODUCTE VENDIDO EN COMANDAS REALIZADAS EN 2017

-- Parametre nom producte, ha de existir, el nom no es unic, puede haber mas de 1 con elmismo nombre

-- si no cumple NULL

-- si es correct buscar QUANTITAT DE PRODUCTE VENUT EN 2017

-- si no hay comands en 2017 Producte ........ sense comandes l’any 2017 i return 0

-- si hay L’any 2017 la quantitat de producte ........ venut és: <quantitat_total> i return quantital_total

-- return final QUANTITAT TOAL DE PRODUCTE VENUT EN 2017

CREATE OR REPLACE FUNCTION f_prod_2017_Fernandez_Denis(nom_producte IN VARCHAR2)
RETURN NUMBER
IS
    v_total NUMBER := 0;
    v_existe NUMBER := 0;
BEGIN
    -- Comprobamos si el parámetro es NULL
    IF nom_producte IS NULL THEN
        RETURN NULL;
    END IF;

    -- Comprobamos si existe al menos un producto con ese nombre
    SELECT COUNT(*) INTO v_existe
    FROM products
    WHERE product_name = nom_producte;

    IF v_existe = 0 THEN
        RETURN NULL;
    END IF;

    -- Calculamos la cantidad total vendida en 2017
    SELECT NVL(SUM(oi.quantity), 0)
    INTO v_total
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.product_name = nom_producte
      AND EXTRACT(YEAR FROM o.order_date) = 2017;

    IF v_total = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Producte ' || nom_producte || ' sense comandes l’any 2017');
    ELSE
        DBMS_OUTPUT.PUT_LINE('L’any 2017 la quantitat de producte ' || nom_producte || ' venut és: ' || v_total);
    END IF;

    RETURN v_total;
END;
/



