/*
--1
Begin
execute immediate ('create table chantiers (reference number primary key , lieu varchar(30) , datedebut date , duree number , nb_ouv number)'); 
execute immediate ('create table ouvriers(maricule number primary key , nom varchar(30) , prenom varchar(30) , prix_jr number , ref number references chantiers(reference)'); 
end ; 
/

--2
create or replace procedure proc_insertion_chantiers ( ref in chantiers.reference%type, lieu in chantiers.lieu%type , dated in chantiers.datedebut%type , duree in chantiers.duree%type)
is
begin 
insert into chantiers values ( ref , lieu, dated, duree , null) ; 
exception 
when dup_val_on_index then
dbms_output.put_line('ref exise déja');
end ; 
/ 
--appel
declare
ref in chantiers.reference%type;
 lieu in chantiers.lieu%type ;
 dated in chantiers.datedebut%type ;
 duree in chantiers.duree%type; 
begin
ref:=&ref;
lieu:=&lieu;
dated:=&dated; 
duree:=&duree; 
proc_insertion_chantiers( ref, lieu, dated, duree); 
ref:=&ref;
lieu:=&lieu;
dated:=&dated; 
duree:=&duree; 
proc_insertion_chantiers( ref, lieu, dated, duree); 
ref:=&ref;
lieu:=&lieu;
dated:=&dated; 
duree:=&duree; 
proc_insertion_chantiers( ref, lieu, dated, duree); 
end ; 
/ 

--2
create or replace procedure proc_insertion_OUVRIER( matricule number , nom varchar(30) , prenom varchar(30), prixjr number , ref number)
is 
a varchar(30); 
E exception ; 
begin
select reference 
into a 
from chantiers
where reference=ref; 
if prixjr<10 then
raise E ; 
end if ; 
insert into chantiers values (  matricule  , nom  , prenom , prixjr  , ref ); 
Exception 
when dup_val_on_index then
dbms_output.put_line('matricule existe déja');
when no_data_found then
dbms_output.put_line('ref  n''existe pas');
when E then 
dbms_output.put_line('prix doit etre sup a 10');
end ; 
/ 

--PARTIE 3
--1
create or replace trigger trig_msg1 
BEFORE 
insert 
on ouvriers 
Begin
dbms_output.put_line('Début d''insertion'); 
end ; 
/
create or replace trigger trig_msg2 
AFTER
insert 
on ouvriers 
Begin
dbms_output.put_line('Fin d''insertion'); 
end ; 
/


--2
create or replace trigger trig_messages_specif
BEfore 
insert or update or delete 
on chantiers 
begin 
if inserting then 
dbms_output.put_line(' Insertion le '|| sysdate||' à '||extract(hour from systimestamp) ||'H'); 
elsif updating then
dbms_output.put_line(' modification le '|| sysdate||' à '||(extract(hour from systimestamp)+1) ||'H'); 
else 
dbms_output.put_line(' suppression le '|| sysdate||' à '||(extract(hour from systimestamp) +1)||'H'); 
end if ; 
end ; 
/

--3
create or replace trigger Trig_nbrOuvriers
after
insert or delete
on ouvriers 
for each row 
begin
if inserting then 
update chantiers set NBOUVRIERAFFECTES= NBOUVRIERAFFECTES+1 where reference = :new.ref ; 
else 
update chantiers set NBOUVRIERAFFECTES= NBOUVRIERAFFECTES-1 where reference = :old.ref; 
end if ; 
end ; 
/

--4
create table historiques (
type_requete varchar(15) , 
date_peration date , 
heure varchar(30) , 
utilisateur varchar(20) ) ; 

--5
create or replace trigger Trig_historique
after
insert or update or delete
on chantiers 
begin 
if inserting then 
insert into historiques values ( 'insert' , sysdate , to_char(systimestamp, 'HH24:mi') , user ) ; 
elsif updating then
insert into historiques values ( 'update' , sysdate , to_char(systimestamp, 'HH24:mi') , user ) ; 
else 
insert into historiques values ( 'suppression' , sysdate , to_char(systimestamp, 'HH24:mi') , user ) ; 
end if ; 
end ; 
/ 
*/
--6
create or replace trigger trig_control 
before
insert or update or delete
on ouvriers 
begin
if to_char( sysdate , 'day') in ( 'samedi  ', 'dimanche', 'jeudi   ') then 
raise_application_error( -20959 , 'operation interdite') ; 
end if ; 
end ; 
/
--ou 
create or replace trigger trig_control2 
before
insert or update or delete
on ouvriers 
declare 
E exception ; 
begin
if to_char( sysdate , 'day') in ( 'samedi  ', 'dimanche', 'jeudi   ') then 
raise E ; 
end if ; 
Exception 
when E then 
dbms_output.put_line('operation interdite 2') ; 
end ; 
/














