CREATE OR REPLACE FUNCTION buscar_empleat (
    p_nom IN VARCHAR2, 
    p_cognom IN VARCHAR2 
) RETURN employees%ROWTYPE 
IS
    v_employee employees%ROWTYPE;
    CURSOR cur IS 
        SELECT * 
        FROM employees
        WHERE first_name = NVL(p_nom, first_name)
        AND last_name = NVL(p_cognom, last_name)
        ORDER BY last_name, first_name;
BEGIN
    v_employee.employee_id := NULL;
    OPEN cur;
    FETCH cur INTO v_employee;
    IF cur%NOTFOUND THEN
        v_employee := NULL;
    END IF;
    CLOSE cur;
    RETURN v_employee;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; 
    WHEN TOO_MANY_ROWS THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL; 
END;


--JOC DE PROVES
DECLARE
  p_nom employees.first_name%type;
  p_cognom employees.last_name%type;
  v_Return employees%rowtype;
BEGIN
  p_nom := null;
  p_cognom := null;
  v_Return := buscar_empleat(p_nom,p_cognom);
  if v_Return.employee_id IS NULL then DBMS_OUTPUT.PUT_LINE('v_Return null'); else
  DBMS_OUTPUT.PUT_LINE('v_Return buscar_empleat= ' || v_Return.email);
  end if;
  p_nom := 'UK';
  p_cognom := 'UK';
  v_Return := buscar_empleat(p_nom,p_cognom);
  if v_Return.employee_id IS NULL then DBMS_OUTPUT.PUT_LINE('v_Return null'); else
  DBMS_OUTPUT.PUT_LINE('v_Return buscar_empleat= ' || v_Return.email);
  end if;
  p_nom := 'John';
  p_cognom := 'Chen';
  v_Return := buscar_empleat(p_nom,p_cognom);
  if v_Return.employee_id IS NULL then DBMS_OUTPUT.PUT_LINE('v_Return null'); else
  DBMS_OUTPUT.PUT_LINE('v_Return buscar_empleat= ' || v_Return.email);
  end if;
END;

