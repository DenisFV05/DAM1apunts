#Exercici 3 – Alter taules
use vet_clinic_Bargados_David;
#CREACIÓ DE COLUMNA NOVA
ALTER TABLE appointment
ADD COLUMN created_at datetime NOT NULL;