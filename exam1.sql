

--1-create sequence seq_res INCREMENT BY 1 start with 1 maxvalue 300 nocycle;

--2-create  view v_details_res as select nom, prenom, intitule from clients c join reservations r on r.codeClient=c.codeClient join circuits cr on cr.idCircuit=r.codeCircuit where etatReservation='confirme' with read only;


-----3
----a
/*
create or replace function fn_nb return integer
is
nb integer;
begin
select count(*) into nb  from circuits where idCircuit not in (select distinct idCircuit from Reservations);
return nb;
end;
/
*/
-----b

-----select fn_nb "nb circuit" from dual;

-----ou bien 
/*
set serveroutput on 
declare
v_nb integer;
begin
v_nb:= fn_nb; 
dbms_output.put_line (v_nb);
end;
/
*/

---------4
/*
set serveroutput on 
declare
cursor cur_vl is select villeDepart VD, count(*) nbvilledep from vols group by villedepart having count(*)>50;
begin
for i in cur_vl
loop
dbms_output.put_line( 'la ville de depart est :' || i.VD|| 'le nombre est' || i.nbvilledep);
end loop;
end;
/
*/
-------------------------------



--------5
/*
create or replace procedure proc_insertion_res (v_cli Reservations.codeClient%type, v_cir Reservations.codeCircuit%type, 
nb Reservations.nbPlaceReserve%type, vacompte Reservations.Acompte%type)
is
verif Reservations.codeClient%type;
prix Reservations.Acompte%type;
exception_accompte exception; 
begin
select CodeClient into verif from clients where CodeClient=v_cli;
select prixCircuit into prix from circuits where idCircuit=v_cir;
if (vacompte < prix/3) then 
raise exception_accompte;
end if;
insert into reservations values(seq_res.nextval, v_cli, v_cir, sysdate, nb, vacompte, null,null);
commit; 
exception
when no_data_found then
dbms_output.put_line('code client inexistant or code circuit inexistant');
when exception_accompte then dbms_output.put_line('verifiez le montant de l''acompte');
end;
/
*/

------------------6
/*

create or replace procedure proc_top_clients (total_res out integer)
is
cursor cur_topthree is select count(*) nb, codeClient cc from reservations group by codeClient order by 1 desc;
begin
total_res :=0;
for j in cur_topthree
loop
total_res := total_res+ j.nb;
exit when cur_topthree%rowcount=3;
dbms_output.put_line('le code client est :'||j.cc||'_'||'ayant le nombre des revervations est :'||j.nb);
end loop;
end;
/
*/

--Appel
/*
set serveroutput on 
declare
tot integer;
begin
proc_top_clients (tot);
dbms_output.put_line(tot);
end;
/
*/

------7
/*
CREATE OR REPLACE TRIGGER TRIG_NB_PLACE
AFTER
INSERT OR DELETE ON RESERVATIONS
FOR EACH ROW 
BEGIN
IF INSERTING THEN 
UPDATE CIRCUITS SET nbPlaceDisponible = nbPlaceDisponible-1 where idCircuit=:new.codeCircuit ;
ELSE 
UPDATE CIRCUITS SET nbPlaceDisponible = nbPlaceDisponible+1 where idCircuit=:old.codeCircuit ;
END IF;
END;
/
*/

-----8
/*
create or replace trigger trig_control
before 
delete or update or insert on vols
for each row
when (new.dateDepart > new.dateArrivee)
begin
if (to_char(sysdate,'dd/mm')='01/01') or (to_char(sysdate, 'dd/mm')='01/05') then 
raise_application_error(-2000,'Interdit de faire toute modification');
end if;
end;
/
*/
