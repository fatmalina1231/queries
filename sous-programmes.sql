/*
conn hr/hr
set serveroutput on 
--PARTIE 1
--1
--a 
declare 
d date ; 
begin
select sysdate into d
from dual ; 
dbms_output.put_line('la date du jour est '||d) ; 
end ; 
/

--b
declare 
a number :=44.5; 
b number := 61.8; 
s number; 
begin
s:= a+b; 
dbms_output.put_line('la somme de '||a||'+'||b||' est '||s) ; 
end ; 
/
--c
begin
for i in 1..9 loop
dbms_output.put(i||',');
end loop ; 
dbms_output.put(10);
dbms_output.new_line(); 
end ; 
/

declare 
i number :=100; 
begin
while (i>0) loop
dbms_output.put(i||',');
i:=i-2; 
end loop; 
dbms_output.put(0); 
dbms_output.new_line(); 
end ; 
/

--d 
declare
a number := &a; 
b number := &a; 
s number; 
p number ; 
begin 
s:= a+b;
p:=a*b;
dbms_output.put_line('la somme de '||a||'+'||b||' est '||s) ; 
dbms_output.put_line('le produit de '||a||'*'||b||' est '||p) ; 
end ; 
/
--f
declare 
a number :=&a; 
f number :=1; 
begin
for i in 2..a loop
f:=f*i; 
end loop; 
dbms_output.put_line('le factoriel de '||a||' est '||f); 
end ; 
/

--2
--a
declare
nom employees.first_name%type; 
begin
select first_name into nom
from employees 
where employee_id =110 ; 
dbms_output.put_line(nom);
end ; 
/

--b
declare
nb number ; 
begin
select count(*) into nb
from employees 
where department_id=50; 
dbms_output.put_line(nb );
end ; 
/
--c
declare
maxi number ; 
mini number ; 
begin
select max(salary) , min(salary)  into maxi, mini
from employees 
where department_id=50; 
dbms_output.put_line(maxi||' '||mini) ;
end ; 
/
--PARTIE 2
--1
--A
--curseur implicite 
begin
for i in ( select d.department_id id , department_name , avg(salary) moy
from departments d
join employees e
on d.department_id=e.department_id 
group by d.department_id , department_name) loop
dbms_output.put_line(i.id ||' '|| i.department_name||' '||i.moy); 
end loop ; 
end ; 
/
--curseur explicite 
declare 
cursor c is (select d.department_id id , department_name , avg(salary) moy
from departments d
join employees e
on d.department_id=e.department_id 
group by d.department_id , department_name) ; 
i c%rowtype; 
--identifiant departments.department_id%type;
--nom departments.department_name%type;
--moyenne number; 
begin
open c ; 
loop
fetch c into i ; 
--fetch c into identifiant, nom , moyenne; 
dbms_output.put_line(i.id ||' '|| i.department_name||' '||i.moy); 
--dbms_output.put_line(identifiant||' '||nom||' '||moyenne); 
exit when (c%notfound) ; 
end loop; 
close c ; 
end ; 
/

--b 
begin
for i in ( select count(*) nb , department_id id 
from employees 
group by department_id ) loop

dbms_output.put_line('departement numero:'||i.id ||' , nombre d''employe :' || i.nb) ; 
end loop; 
end ; 
/

--c 
declare 
cursor c is select first_name
from employees 
where department_id in ( select department_id from employees
group by department_id 
having count(*)>20); 
nom employees.first_name%type ;
begin
 open c ; 
loop 
fetch c into nom ;
dbms_output.put_line(nom) ;
exit when ( c%notfound) ; 
end loop ; 
close c ; 
end ; 
/

--d 
declare
cursor c is ( select distinct(manager_id) m_id from employees ) ; 
man_id employees.manager_id%type ; 
cursor c1(id number) is ( select first_name from employees where manager_id=id) ; 
nom employees.first_name%type; 
begin
open c ; 
loop
fetch c into man_id ; 
dbms_output.put_line('manager '||man_id ) ; 
open c1(man_id) ; 
loop
fetch c1 into nom ;
dbms_output.put_line('employe '||nom);
exit when (c1%notfound); 
end loop; 
close c1; 
exit when ( c%notfound) ; 
end loop ; 
close c ; 
end ; 
/
*/
--2

begin
execute immediate ('create table produits (idproduit number primary key , 
nomproduit varchar(30) , categorieP varchar(30) , prixProduit number) ') ; 
dbms_output.put_line('table cree') ; 
end ; 
/ 








































