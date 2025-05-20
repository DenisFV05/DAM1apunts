-- 3 packages amb funcions de funcionsemployees

--pkg_employees0425_Fernandez_Denis - f_empleat 
--pkg_jobs0425_Fernandez_Denis - f_job
--pkg_utilitats0425_Fernandez_Denis - normalitzar_string

--La cabeza del package solo declarar funciones PUBLICAS

-- pa comprobar si va todo bien usar funcionsdelete





CREATE OR REPLACE PACKAGE pkg_utilitats0425_Fernandez_Denis AS
   FUNCTION normalitzar_string(p_string VARCHAR2, p_convertir BOOLEAN) RETURN VARCHAR2;
END pkg_utilitats0425_Fernandez_Denis;
/

CREATE OR REPLACE PACKAGE BODY pkg_utilitats0425_Fernandez_Denis AS

   FUNCTION normalitzar_string(p_string VARCHAR2, p_convertir BOOLEAN) RETURN VARCHAR2 IS
      v_string        VARCHAR2(50);
      v_string_out    VARCHAR2(50);
      v_paraula       VARCHAR2(50);
      v_paraula_aux   VARCHAR2(50);
      v_pos           NUMBER;
      primera_vegada  BOOLEAN;
   BEGIN
      IF p_string IS NULL THEN
         RETURN NULL;
      END IF;

      IF LENGTH(TRIM(p_string)) > 50 THEN
         RETURN NULL;
      END IF;

      v_string := TRIM(p_string);
      primera_vegada := TRUE;

      WHILE v_string IS NOT NULL LOOP
         v_pos := INSTR(v_string, ' ', 1, 1);
         IF v_pos = 0 THEN
            v_pos := LENGTH(v_string) + 1;
         END IF;

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
   END normalitzar_string;

END pkg_utilitats0425_Fernandez_Denis;
/
















CREATE OR REPLACE PACKAGE pkg_jobs0425_Fernandez_Denis AS
   FUNCTION f_job(nom jobs.job_title%type) RETURN jobs.job_id%type;
END pkg_jobs0425_Fernandez_Denis;
/

CREATE OR REPLACE PACKAGE BODY pkg_jobs0425_Fernandez_Denis AS

   FUNCTION f_job_excep(nom jobs.job_title%type) RETURN jobs.job_id%type IS
      v_id jobs.job_id%type;
   BEGIN
      SELECT job_id INTO v_id FROM jobs WHERE job_title = nom;
      RETURN v_id;
   EXCEPTION
      WHEN no_data_found THEN RETURN NULL;
      WHEN too_many_rows THEN RETURN NULL;
      WHEN others THEN RETURN -1;
   END f_job_excep;

   FUNCTION f_job(nom jobs.job_title%type) RETURN jobs.job_id%type IS
   BEGIN
      RETURN f_job_excep(pkg_utilitats0425_Fernandez_Denis.normalitzar_string(nom, TRUE));
   END f_job;

END pkg_jobs0425_Fernandez_Denis;
/











CREATE OR REPLACE PACKAGE pkg_employees0425_Fernandez_Denis AS
   FUNCTION f_empleat_per_cognom(p_dept departments.department_id%type,
                                p_cognom employees.last_name%type) RETURN employees%rowtype;

   FUNCTION f_empleat_per_cognom_i_nom(p_dept departments.department_id%type,
                                       p_cognom employees.last_name%type,
                                       p_nom employees.first_name%type) RETURN employees%rowtype;
END pkg_employees0425_Fernandez_Denis;
/

CREATE OR REPLACE PACKAGE BODY pkg_employees0425_Fernandez_Denis AS

   FUNCTION f_empleat_per_cognom(p_dept departments.department_id%type,
                                p_cognom employees.last_name%type) RETURN employees%rowtype IS
   BEGIN
      RETURN f_empleat_per_cognom_i_nom(p_dept, p_cognom, NULL);
   END f_empleat_per_cognom;

   FUNCTION f_empleat_per_cognom_i_nom(p_dept departments.department_id%type,
                                       p_cognom employees.last_name%type,
                                       p_nom employees.first_name%type) RETURN employees%rowtype IS
      v_emp employees%rowtype;
      v_convertir BOOLEAN := TRUE;
   BEGIN
      BEGIN
         SELECT *
           INTO v_emp
           FROM employees
          WHERE department_id = p_dept
            AND last_name = pkg_utilitats0425_Fernandez_Denis.normalitzar_string(p_cognom, v_convertir)
            AND first_name = NVL(pkg_utilitats0425_Fernandez_Denis.normalitzar_string(p_nom, v_convertir), first_name);
      EXCEPTION
         WHEN no_data_found THEN
            v_emp.employee_id := -1;
         WHEN too_many_rows THEN
            v_emp.employee_id := -99;
         WHEN others THEN
            v_emp.employee_id := -10;
      END;
      RETURN v_emp;
   END f_empleat_per_cognom_i_nom;

END pkg_employees0425_Fernandez_Denis;
/









