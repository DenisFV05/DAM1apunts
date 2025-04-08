-- Funcion f_prod_2017_Fernandez_Denis para saber QUANTITAT TOTAL PRODUCTE VENDIDO EN COMANDAS REALIZADAS EN 2017

-- Parametre nom producte, ha de existir, el nom no es unic, puede haber mas de 1 con elmismo nombre

-- si no cumple NULL

-- si es correct buscar QUANTITAT DE PRODUCTE VENUT EN 2017

-- si no hay comands en 2017 Producte ........ sense comandes l’any 2017 i return 0

-- si hay L’any 2017 la quantitat de producte ........ venut és: <quantitat_total> i return quantital_total

-- return final QUANTITAT TOAL DE PRODUCTE VENUT EN 2017

CREATE OR REPLACE FUNCTION f_prod_2017_Fernandez_Denis(nom_producte IN VARCHAR2) RETURN NUMBER
IS vquantitat NUMBER;
BEGIN
    IF nom_producte IS NULL THEN
        RETURN NULL;
    -- comprobar si es unico
    END IF;

    SELECT COUNT(*) INTO vquantitat, product_name
    FROM ORDERS, PRODUCTS
    WHERE EXTRACT(YEAR FROM order_date) = p_year
      AND product_name = nom_producte;

    IF vquantitat IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Producte'|| nom_producte ||'sense comandes l?any 2017');
        RETURN NUMBER=:0;
    ELSE 
        DBMS_OUTPUT.PUT_LINE("L'any 2017 la quantitat de producte" || nom_producte ||' venut és:' || vquantitat);
        RETURN vquantitat;

    END;


