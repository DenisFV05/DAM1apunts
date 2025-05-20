-- FUNCIÓN
CREATE OR REPLACE FUNCTION f_prod_2017_Fernandez_Denis(nom_producte IN VARCHAR2) RETURN NUMBER
IS
  v_existe NUMBER;
  v_total NUMBER;
BEGIN
  IF nom_producte IS NULL THEN
    RETURN NULL;
  END IF;

  SELECT COUNT(*) INTO v_existe
  FROM products
  WHERE product_name = nom_producte;

  IF v_existe = 0 THEN
    RETURN NULL;
  END IF;

  SELECT NVL(SUM(oi.quantity), 0)
  INTO v_total
  FROM order_items oi
  JOIN orders o ON oi.order_id = o.order_id
  JOIN products p ON oi.product_id = p.product_id
  WHERE p.product_name = nom_producte
    AND EXTRACT(YEAR FROM o.order_date) = 2017;

  IF v_total = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Producte ' || nom_producte || ' sense comandes lany 2017');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Lany 2017 la quantitat de producte ' || nom_producte || ' venut és: ' || v_total);
  END IF;

  RETURN v_total;
END;
/

-- BLOQUE DE PRUEBAS
DECLARE
  nom_producte VARCHAR2(30);
  v_ret NUMBER;
BEGIN
  nom_producte := 'kkk';
  v_ret := f_prod_2017_Fernandez_Denis(nom_producte);
  DBMS_OUTPUT.PUT_LINE('-- producte ' || nom_producte || ' la funció ha retornat :' || v_ret);

  nom_producte := 'Intel Xeon E5-2697 V4';
  v_ret := f_prod_2017_Fernandez_Denis(nom_producte);
  DBMS_OUTPUT.PUT_LINE('-- producte ' || nom_producte || ' la funció ha retornat :' || v_ret);

  nom_producte := 'Kingston SV300S37A/120G';
  v_ret := f_prod_2017_Fernandez_Denis(nom_producte);
  DBMS_OUTPUT.PUT_LINE('-- producte ' || nom_producte || ' la funció ha retornat :' || v_ret);

  nom_producte := 'Kingston';
  v_ret := f_prod_2017_Fernandez_Denis(nom_producte);
  DBMS_OUTPUT.PUT_LINE('-- producte ' || nom_producte || ' la funció ha retornat :' || v_ret);
END;
/
