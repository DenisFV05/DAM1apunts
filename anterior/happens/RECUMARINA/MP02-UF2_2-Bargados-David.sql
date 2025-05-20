#MODIFICAR DADES#
SET SQL_SAFE_UPDATES = 0;
use vet_clinic_Bargados_David;
#CREACIÓ DEL OWNER JANE SMITH
insert into owner(first_name,last_name,contact_number,email)
VALUES ('Jane','Smith',658011562,'janesmith@gmail.com');

#CREACIÓ DELS ANIMALS LAIKA I MIAU(SENSE OWNER)
insert into animal(name,species,birth_date)
VALUES('Laika','gos','2023-01-22'),('Miau','gat','2023-01-22');
select * from owner;  #DEMOSTRACIÓ(OWNER NULL)
#ACTUALITZACIÓ DE LA TAULA ANIMAL PER QUE ARA ELS ANIMALS TINGUIN UN OWNER
update animal
set owner_id = (SELECT id from owner where first_name='Jane');
select * from animal;#DEMOSTRACIÓ(AMB OWNER)
