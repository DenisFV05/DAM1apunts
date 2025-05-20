declare
codi_prod products.product_id%type;
s_minim number;
begin

-- PROVA 1
--producte inexistent
codi_prod:=9999;
s_minim:=50;
DBMS_OUTPUT.PUT_LINE('PROVA 1 -- producte '||codi_prod|| 
					 '-- stock minim '||s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD(' ',50,' ')); 
p_sota_minims_Fernandez_Denis(codi_prod,s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD('.',50,'.')); 

--stock minim incorrecte
codi_prod:=7;
s_minim:=-50;
DBMS_OUTPUT.PUT_LINE('PROVA 1 -- producte '||codi_prod|| 
					 '-- stock minim '||s_minim); 
DBMS_OUTPUT.PUT_LINE(RPAD(' ',50,' ')); 
p_sota_minims_Fernandez_Denis(codi_prod,s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD('.',50,'.')); 

-- PROVA 2
--producte sense magatzems
codi_prod:=112;
s_minim:=50;
DBMS_OUTPUT.PUT_LINE('PROVA 2-- producte '||codi_prod|| 
					 '-- stock minim '||s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD(' ',50,' ')); 
p_sota_minims_Fernandez_Denis(codi_prod,s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD('.',50,'.')); 

-- PROVA 3
--producte amb magatzems , tots per sobre stock mínim
codi_prod:=228;
s_minim:=50;
DBMS_OUTPUT.PUT_LINE('PROVA 3-- producte '||codi_prod|| 
					 '-- stock minim '||s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD(' ',50,' ')); 
p_sota_minims_Fernandez_Denis(codi_prod,s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD('.',50,'.')); 

-- PROVA 4
--producte amb magatzems , alguns per sota stock mínim
codi_prod:=7;
s_minim:=50;
DBMS_OUTPUT.PUT_LINE('PROVA 4 -- producte '||codi_prod|| 
					 '-- stock minim '||s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD(' ',50,' ')); 
p_sota_minims_Fernandez_Denis(codi_prod,s_minim);
DBMS_OUTPUT.PUT_LINE(RPAD('.',50,'.')); 
					 
end;