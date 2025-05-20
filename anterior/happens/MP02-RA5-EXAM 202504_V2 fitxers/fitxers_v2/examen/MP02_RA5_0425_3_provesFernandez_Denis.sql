-- SCRIPT DE PROVES MODIFICAT

-- Proves f_empleat_per_cognom_i_nom i f_empleat_per_cognom
DECLARE
   v_emp employees%ROWTYPE;
BEGIN
   v_emp := pkg_employees0425_Fernandez_Denis.f_empleat_per_cognom_i_nom(100, '        CHEN', 'JOHN         ');
   dbms_output.put_line('treballador: ' || v_emp.employee_id);

   v_emp := pkg_employees0425_Fernandez_Denis.f_empleat_per_cognom(100, 'Chen           ');
   dbms_output.put_line('treballador: ' || v_emp.employee_id);

   v_emp := pkg_employees0425_Fernandez_Denis.f_empleat_per_cognom_i_nom(80, 'Cambrault', 'Gerald');
   dbms_output.put_line('treballador: ' || v_emp.employee_id);

   v_emp := pkg_employees0425_Fernandez_Denis.f_empleat_per_cognom(80, 'Cambrault');
   dbms_output.put_line('treballador: ' || v_emp.employee_id);
END;
/

-- Proves f_job
DECLARE
   v_id jobs.job_id%TYPE;
BEGIN
   v_id := pkg_jobs0425_Fernandez_Denis.f_job('President');
   dbms_output.put_line('job id és: ' || v_id);

   v_id := pkg_jobs0425_Fernandez_Denis.f_job('  President ');
   dbms_output.put_line('job id és: ' || v_id);

   v_id := pkg_jobs0425_Fernandez_Denis.f_job(' accounting     manager');
   dbms_output.put_line('job id és: ' || v_id);
END;
/
