create table salles ( id_salle number primary key , nom varchar(30) , capacite number); 
create table chanteurs(id_chanteur number primary key , nom_chanteur varchar(30), nationnalite varchar(30));
create table spectacles (id_spectacle number primary key , titre varchar(30) , date_spec date , heure_spec number , duree_estimee number , id_chanteur number references chanteurs(id_chanteur), id_salle number references salles(id_salle));
 create table billet (id_billet number primary key , num_place varchar(30), categorie varchar(30), prix number , id_spectacle number references spectacles(id_spectacle)); 

insert into salles values ( 1 , 'salle 1', 500); 
insert into salles values ( 2 , 'salle 2', 500); 
insert into salles values ( 3 , 'salle 3', 500); 
insert into salles values ( 4 , 'salle 4', 500); 
insert into salles values ( 5 , 'salle 5', 500); 
insert into salles values ( 6 , 'salle 6', 500); 

insert into chanteurs values (1, 'nom1', 'tunisie'); 
insert into chanteurs values (2, 'nom2', 'tunisie'); 
insert into chanteurs values (3, 'nom3', 'france'); 
insert into chanteurs values (4, 'nom4', 'italie'); 
insert into chanteurs values (5, 'nom5', 'tunisie'); 
insert into chanteurs values (6, 'nom6', 'france'); 
insert into chanteurs values (7, 'nom7', 'tunisie'); 
insert into chanteurs values (8, 'nom8', 'france'); 
insert into chanteurs values (9, 'nom9', 'italie'); 
insert into chanteurs values (10, 'nom10', 'tunisie'); 


insert into spectacles values (1, 'titre1', sysdate, 19 , 3 , 1, 1) ; 
insert into spectacles values (2, 'titre2', '13/01/2000', 19 , 3 , 5, 2) ; 
insert into spectacles values (3, 'titre3', '13/03/2000',19 , 3 , 7, 2) ; 
--insert into spectacles values (4, 'titre4', '13/05/2023',19 , 3 , 1, 3) ; 
insert into spectacles values (5, 'titre4', '13/09/2022',19 , 3 , 10, 4) ; 

insert into billet values ( 1 , 304 , 'classe A', 34 , 1) ; 
insert into billet values ( 2 , 304 , 'classe A', 34 , 1) ; 
insert into billet values ( 3 , 304 , 'classe A', 34 , 2) ; 
insert into billet values ( 4 , 304 , 'classe A', 34 , 3) ; 
insert into billet values ( 5 , 304 , 'classe B', 34 , 1) ; 
insert into billet values ( 6 , 304 , 'classe C', 34 , 1) ; 
insert into billet values ( 7 , 304 , 'classe B', 34 , 2) ;
insert into billet values ( 8 , 304 , 'classe C', 34 , 3) ; 
--insert into billet values ( 9 , 304 , 'classe B', 34 , 4) ; 
--insert into billet values ( 10 , 304 , 'classe C', 34 , 4) ; 
--insert into billet values ( 11 , 304 , 'classe C', 34 , 4) ; 
--insert into billet values ( 12 , 304 , 'classe C', 34 , 4) ; 
insert into billet values ( 13, 304 , 'classe B', 34 , 3) ; 
insert into billet values ( 14 , 304 , 'classe A', 34 , 3) ; 
insert into billet values ( 15 , 304 , 'classe A', 34 , 2) ; 
insert into billet values ( 16 , 304 , 'classe A', 34 , 1) ; 
insert into billet values ( 17 , 304 , 'classe A', 34 , 1) ; 

--1
begin
execute immediate ('create table spectaclees (id_spectacle number primary key , titre varchar(30) not null, date_spec date , heure_spec number , duree_estimee number check ( duree_estimee between 0 and 3) , id_chanteur number references chanteurs(id_chanteur), id_salle number references salles(id_salle))');
end ; 
/
--2
create view v_spectacles as select titre from spectacles s join chanteurs c on s.id_chanteur=c.id_chanteur where upper(nationnalite)='TUNISIE' and extract(year from date_spec) = extract(year from sysdate) 
group by extract(month from date_spec) , titre; 
--3
create or replace procedure proc_update_prix (nom_c chanteurs.nom_chanteur%type, date_s spectacles.date_spec%type)
is 
nom chanteurs.nom_chanteur%type; 
E exception ; 
begin
select nom_chanteur into nom
from chanteurs
where nom_chanteur=nom_c ; 
if date_s<sysdate then 
raise E; 
end if; 
for i in ( select categorie from billet b join spectacles s on  b.id_spectacle=s.id_spectacle
join chanteurs c on s.id_chanteur=c.id_chanteur where nom_chanteur=nom_c 
and date_spec=date_s) loop
if upper(i.categorie)='CLASSE A' then 
update billet set prix=prix*1.3; 
dbms_output.put_line('MAJ ok'); 
elsif upper(i.categorie)='CLASSE B' then 
update billet set prix=prix*1.2; 
dbms_output.put_line('MAJ ok'); 
elsif upper(i.categorie)='CLASSE C' then 
update billet set prix=prix*1.1; 
dbms_output.put_line('MAJ ok'); 
end if; 
end loop; 
Exception 
when E then 
dbms_output.put_line('spectacle déja passé'); 
when no_data_found then 
dbms_output.put_line('chanteur n''existe pas'); 
end ; 
/
execute proc_update_prix('nom1', '13/05/2023')
--4
create or replace function fn_profit_spectacle (titre_s spectacles.titre%type) 
return number 
is 
nb number ; 
begin
select sum(prix) into nb
from billet b 
join spectacles s
on b.id_spectacle=s.id_spectacle
where titre=titre_s;
return nb; 
end ; 
/
select fn_profit_spectacle('titre1') from dual ; 
--5
create or replace procedure proc_meilleur_profit 
is 
begin
for i in ( select titre from spectacles where fn_profit_spectacle (titre) >30) loop
dbms_output.put_line(i.titre); 
end loop; 
end ; 
/
execute proc_meilleur_profit 
--6
declare
cursor c is select s.id_salle, nom , capacite from salles s inner join spectacles p on p.id_salle=s.id_salle ;
cursor c2(id salles.id_salle%type) is select titre , date_spec from spectacles where id_salle=id ; 
var c%rowtype; 
var2 c2%rowtype; 
begin
open c; 
loop
fetch c into var ; 
exit when c%notfound; 
dbms_output.put_line( var.id_salle||' '||var.nom||' '||var.capacite); 
open c2(var.id_salle); 
loop
fetch c2 into var2 ; 
exit when c2%notfound; 
dbms_output.put_line(var2.titre||' '||var2.date_spec); 
end loop; 
close c2; 
end loop; 
close c; 
end ; 
/
--7
create or replace procedure proc_liste_chanteurs ( annee number) 
is 
begin
for i in ( select nom_chanteur from chanteurs c left join spectacles s on s.id_chanteur=c.id_chanteur where to_char(date_spec,'q')=1 and extract(year from date_spec)=annee) loop
dbms_output.put_line(i.nom_chanteur); 
end loop; 
end ; 
/
execute proc_liste_chanteurs(2000); 

--8

create or replace trigger trig_nbre_spec
after insert or delete 
on spectacles 
declare 
nb number;	
begin
select count(*) into nb from spectacles;
dbms_output.put_line(nb); 
end;
/



