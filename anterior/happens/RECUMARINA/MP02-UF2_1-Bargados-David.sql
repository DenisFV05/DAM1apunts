create database vet_clinic_Bargados_David;
use vet_clinic_Bargados_David;
#TAULA VETERINARI
create table veterinarian(
	id int auto_increment primary key not null, 
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    contact_number VARCHAR(20),
    email VARCHAR(255),
    specialization VARCHAR(255)
);
#TAULA OWNER
create table owner(
	id int auto_increment primary key not null, 
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    contact_number VARCHAR(20),
    email VARCHAR(255)    
);
#ANIMALS
create table animal(
	id int auto_increment primary key not null,
    name VARCHAR(255),
    species VARCHAR(255),
    breed VARCHAR(255),
    owner_id int,
    birth_date date,
    foreign key (owner_id) references owner(id));

#TAULA APPOINTMENT
create table appointment(
	id int auto_increment primary key not null, 
	veterinarian_id int,
    animal_id int,
    appointment_date datetime,
	reason VARCHAR(255),
    foreign key (veterinarian_id) references veterinarian(id),
    foreign key (animal_id) references animal(id)
    );



#TAULA INVOICE
create table invoice(
	id int auto_increment primary key not null, 
    appointment_id int,
    total_amount float(2),
    payment_status VARCHAR(20),
    foreign key (appointment_id) references appointment(id)
);
