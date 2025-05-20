-- ==================================================================
-- NOM: Denis <tu_apellido>
-- MÒDUL: MP02. Bases de dades
-- RA: RA5. Llenguatge PL/SQL
-- EXERCICI: Exercici3
-- FITXER: M2_RA5_PR4_EX3_Denis.sql
-- ==================================================================

-- ESPECIFICACIÓ: pkg_employees0425_Denis
CREATE OR REPLACE PACKAGE pkg_employees0425_Denis AS
    FUNCTION f_empleat_per_cognom(
        p_dept    IN departments.department_id%TYPE,
        p_cognom  IN employees.last_name%TYPE
    ) RETURN employees%ROWTYPE;

    FUNCTION f_empleat_per_cognom_i_nom(
        p_dept    IN departments.department_id%TYPE,
        p_cognom  IN employees.last_name%TYPE,
        p_nom     IN employees.first_name%TYPE
    ) RETURN employees%ROWTYPE;
END pkg_employees0425_Denis;
/

-- COS
CREATE OR REPLACE PACKAGE BODY pkg_employees0425_Denis AS
    FUNCTION f_empleat_per_cognom(
        p_dept    IN departments.department_id%TYPE,
        p_cognom  IN employees.last_name%TYPE
    ) RETURN employees%ROWTYPE IS
        v_emp employees%ROWTYPE;
    BEGIN
        v_emp := pkg_employees0425_Denis.f_empleat_per_cognom_i_nom(p_dept, p_cognom, NULL);
        RETURN v_emp;
    END;

    FUNCTION f_empleat_per_cognom_i_nom(
        p_dept    IN departments.department_id%TYPE,
        p_cognom  IN employees.last_name%TYPE,
        p_nom     IN employees.first_name%TYPE
    ) RETURN employees%ROWTYPE IS
        v_emp employees%ROWTYPE;
        v_convertir BOOLEAN := TRUE;
    BEGIN
        BEGIN
            SELECT * INTO v_emp
            FROM employees
            WHERE department_id = p_dept
              AND last_name = pkg_utilitats0425_Denis.normalitzar_string(p_cognom, v_convertir)
              AND first_name = NVL(pkg_utilitats0425_Denis.normalitzar_string(p_nom, v_convertir), first_name);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN v_emp.employee_id := -1;
            WHEN TOO_MANY_ROWS THEN v_emp.employee_id := -99;
            WHEN OTHERS THEN v_emp.employee_id := -10;
        END;
        RETURN v_emp;
    END;
END pkg_employees0425_Denis;
/

-- ESPECIFICACIÓ: pkg_jobs0425_Denis
CREATE OR REPLACE PACKAGE pkg_jobs0425_Denis AS
    FUNCTION f_job(nom IN jobs.job_title%TYPE) RETURN jobs.job_id%TYPE;
END pkg_jobs0425_Denis;
/

-- COS
CREATE OR REPLACE PACKAGE BODY pkg_jobs0425_Denis AS
    FUNCTION f_job_excep(nom IN jobs.job_title%TYPE) RETURN jobs.job_id%TYPE IS
        v_id jobs.job_id%TYPE;
    BEGIN
        SELECT job_id INTO v_id
        FROM jobs
        WHERE job_title = nom;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
        WHEN TOO_MANY_ROWS THEN RETURN NULL;
        WHEN OTHERS THEN RETURN -1;
    END;

    FUNCTION f_job(nom IN jobs.job_title%TYPE) RETURN jobs.job_id%TYPE IS
    BEGIN
        RETURN f_job_excep(pkg_utilitats0425_Denis.normalitzar_string(nom, TRUE));
    END;
END pkg_jobs0425_Denis;
/

-- ESPECIFICACIÓ: pkg_utilitats0425_Denis
CREATE OR REPLACE PACKAGE pkg_utilitats0425_Denis AS
    FUNCTION normalitzar_string(
        p_string    IN VARCHAR2,
        p_convertir IN BOOLEAN
    ) RETURN VARCHAR2;
END pkg_utilitats0425_Denis;
/

-- COS
CREATE OR REPLACE PACKAGE BODY pkg_utilitats0425_Denis AS
    FUNCTION normalitzar_string(
        p_string    IN VARCHAR2,
        p_convertir IN BOOLEAN
    ) RETURN VARCHAR2 IS
        v_string      VARCHAR2(50);
        v_string_out  VARCHAR2(50);
        v_paraula     VARCHAR2(50);
        v_paraula_aux VARCHAR2(50);
        v_pos         NUMBER;
        primera_vegada BOOLEAN := TRUE;
    BEGIN
        IF p_string IS NULL THEN RETURN NULL; END IF;
        IF LENGTH(TRIM(p_string)) > 50 THEN RETURN NULL; END IF;

        v_string := TRIM(p_string);

        WHILE v_string IS NOT NULL LOOP
            v_pos := INSTR(v_string, ' ', 1, 1);
            IF v_pos = 0 THEN v_pos := LENGTH(v_string) + 1; END IF;

            v_paraula := SUBSTR(v_string, 1, v_pos - 1);

            IF p_convertir THEN
                IF LENGTH(v_paraula) > 1 THEN
                    v_paraula_aux := UPPER(SUBSTR(v_paraula, 1, 1)) || LOWER(SUBSTR(v_paraula, 2));
                ELSE
                    v_paraula_aux := UPPER(v_paraula);
                END IF;
            ELSE
                v_paraula_aux := v_paraula;
            END IF;

            IF primera_vegada THEN
                v_string_out := v_paraula_aux;
                primera_vegada := FALSE;
            ELSE
                v_string_out := v_string_out || ' ' || v_paraula_aux;
            END IF;

            v_string := LTRIM(SUBSTR(v_string, v_pos + 1));
        END LOOP;

        RETURN v_string_out;
    END;
END pkg_utilitats0425_Denis;
/

-- JOC DE PROVES
BEGIN
    -- Prova f_job
    DBMS_OUTPUT.PUT_LINE('ID del job: ' || pkg_jobs0425_Denis.f_job('Programmer'));

    -- Prova normalitzar_string
    DBMS_OUTPUT.PUT_LINE('Nom normalitzat: ' || pkg_utilitats0425_Denis.normalitzar_string('JOSE  peREz', TRUE));

    -- Prova f_empleat_per_cognom
    DECLARE
        v_emp employees%ROWTYPE;
    BEGIN
        v_emp := pkg_employees0425_Denis.f_empleat_per_cognom(50, 'King');
        DBMS_OUTPUT.PUT_LINE('ID empleat KING: ' || v_emp.employee_id);
    END;
END;
/
