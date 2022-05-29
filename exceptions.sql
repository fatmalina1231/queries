/*
--1
create or replace function FN_NBR_DEPARTEMENT 
return number 
is 
nb number ; 
begin
select count(*) into nb 
from departments ; 
return nb ; 
end ; 
/

--appel 
 select FN_NBR_DEPARTEMENT from dual ; 

--2
create or replace function FN_NOMDEPT ( id employees.employee_id%type) 
return departments.department_name%type 
is 
nom departments.department_name%type ;
begin
select department_name into nom
from departments d 
join employees e
on d.department_id=e.department_id
where id=e.employee_id; 
return nom; 
end ; 
/
--appel
select FN_NOMDEPT(110) from dual ; 
 --3
create or replace procedure PROC_DETAILS_EMP 
is 
cursor c is select e.first_name nomE, e.last_name prenomE, m.first_name nomM , m.last_name prenomM
from employees e
join employees m 
on m.manager_id= e.employee_id ; 
i c%rowtype ; 
begin
open c ; 
loop 
fetch c into i ; 
dbms_output.put_line('Employee: ' ||i.nomE||' '||i.prenomE||' , manger: '||i.nomM||' '||i.prenomM); 
exit when c%notfound; 
end loop; 
close c ; 
end ; 
/

--appel
execute PROC_DETAILS_EMP


--4
create or replace procedure proc_salmoy ( nb_dept out number) 
is 
cursor c is select avg(salary) nb , department_id from employees group by department_id ; 
i c%rowtype;
begin
open c ; 
loop
fetch c into i ; 
dbms_output.put_line(i.nb||' '||i.department_id) ; 
exit when c%notfound; 
end loop;
close c ; 
select count(department_id) into nb_dept
from departments ; 
end ; 
/ 

declare 
a number ; 
begin
proc_salmoy ( a ) ; 
dbms_output.put_line('le nombre de depts: '||a); 
end ; 
/

--5
create or replace function fn_nbr_salarie ( id_dept in departments.department_id%type) 
return number 
is 
nb number ; 
begin
select count(employee_id) into nb 
from employees
where department_id= id_dept ; 
return nb ; 
end ; 
/ 

--appel
select fn_nbr_salarie(10) from dual ; 
--ou
declare 
id number :=&nb ; 
nb number ; 
begin
nb := fn_nbr_salarie(id);
dbms_output.put_line('nb= '||nb); 
end ; 
/

create or replace procedure PROC_NBR_SALARIE 
( id_dept in departments.department_id%type , nb out number) 
is 
begin
select count(employee_id) into nb 
from employees
where department_id= id_dept ; 
end ; 
/
--appel
declare
id number :=&nb ; 
nb number ; 
begin
 PROC_NBR_SALARIE ( id , nb) ; 
dbms_output.put_line('nb= '||nb); 
end ; 
/

--6
create or replace procedure  PROC_TEST_NBR_SALARIE 
is 
begin
for i in (select department_name 
from departments 
where FN_NBR_SALARIE(department_id)>40) loop
 dbms_output.put_line(i.department_name) ; 
end loop ; 
end ; 
/ 
--appel
execute PROC_TEST_NBR_SALARIE 
--ou 
begin
PROC_TEST_NBR_SALARIE; 
end ; 
/

--7
create or replace procedure PROC_SAL_SUP ( id_emp in employees.employee_id%type ) 
is 
begin
for i in (select first_name 
from employees 
where salary > ( select salary from employees where employee_id=id_emp) ) loop
dbms_output.put_line(i.first_name); 
end loop; 
end ; 
/
--appel
execute proc_sal_sup(121); 
--ou ( bloc anonyme) 
begin
proc_sal_sup(121);
end ; 
/

--8
create or replace function fn_moy_salaire ( id_emp employees.employee_id%type) 
return number
is 
moy number ;
begin
select  avg(salary) into moy
from employees
where department_id = ( select department_id from employees where employee_id=id_emp) ; 
return moy ; 
end ; 
/
--appel
select fn_moy_salaire( 121) from dual ; 

--9
create or replace procedure proc_liste_emp 
is 
begin
for i in (select distinct(manager_id)   id from employees) loop 
dbms_output.put_line('Manager '||i.id) ; 
for j in ( select first_name from employees where manager_id= i.id) loop 
dbms_output.put_line('Employee '||j.first_name) ; 
end loop; 
end loop; 
end ; 
/
--appel
execute proc_liste_emp 

--10
create or replace function FN_TRIMESTRE  ( d date ) 
return number 
is 
nb number ;
begin
select to_char(d , 'q') into nb from dual ; 
return nb ;
end ; 
/
begin
for i in (select first_name
from employees 
where FN_TRIMESTRE (hire_date) >2
and extract ( year from hire_date) =1998) 
loop
dbms_output.put_line(i.first_name) ; 
end loop; 
end ; 
/

--Partie 2
--1
DECLARE
a number ; 
function fn_emp (nom_man employees.first_name%type) return number 
is
nb number ; 
begin
select count(employee_id) into nb 
from employees 
where manager_id = (select employee_id from employees where first_name=nom_man) ; 
return nb ; 
end ; 
BEGIN
a := fn_emp('Payam'); 
dbms_output.put_line(a); 
END;
/
*/

DECLARE 
procedure  PROC_DEPTS
is
 begin
for i in (select department_name  , avg(salary) sal
from departments d
join employees e
on d.department_id =e.department_id 
group by department_name 
having count(employee_id)>20 ) loop 
dbms_output.put_line(i.department_name||' '||i.sal) ; 
end loop; 
end ; 
BEGIN 
PROC_DEPTS; 
END; 
/





