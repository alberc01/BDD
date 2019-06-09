--Ejercicio 1
/*
a. Escribir un procedimiento que reciba una referencia de contrato (que se asume que existe) 
como parámetro de entrada y actualice su contador de trayectos (NumTrayectos) con el número 
que tiene registrados en la tabla Trayectos y lo imprima por consola. Se debe declarar una 
excepción que se lance para dar un mensaje si la referencia no tiene trayectos.

b. Crear un trigger que mantenga actualizado el atributo redundante NumTrayectos al
insertar y borrar en la tabla (se asume que antes de la actualización este atributo es consistente).
*/
drop table trayectos;
CREATE TABLE Contratos(
Referencia VARCHAR(10) PRIMARY KEY,
Empresa VARCHAR(100),
Fecha DATE,
NumTrayectos NUMBER(2,0));

CREATE TABLE Trayectos(
Referencia VARCHAR(10) REFERENCES Contratos ON DELETE CASCADE,
Origen VARCHAR(50),
Destino VARCHAR(50),
Vehículo VARCHAR(20),
PRIMARY KEY (Referencia, Origen, Destino));
 
 insert into Contratos values ('ismael', 'nose', to_date('18/01/1995'), 0);
 insert into Contratos values ('josema', 'jaj', to_date('19/02/1997'), 0);
 insert into Trayectos values ('ismael', 'alameda', 'madrid', 'coche');
 insert into Trayectos values ('ismael', 'barcelona', 'toledo', 'moto');
 insert into Trayectos values ('ismael', 'barc', 'tdo', 'mo');
 insert into Trayectos values ('josema', 'peru', 'toledo', 'barco');
 
truncate table contratos;
truncate table trayectos;
  select * from contratos;
  select * from trayectos;
  
CREATE OR REPLACE PROCEDURE contadorTrayectos (v_referencia VARCHAR)
IS
  v_contador NUMBER;
  NO_TRAYECTOS EXCEPTION;
  BEGIN
    SELECT COUNT(*) INTO v_contador FROM Trayectos WHERE REFERENCIA = v_referencia;
    IF v_contador = 0 THEN RAISE NO_TRAYECTOS;
    END IF;
    dbms_output.put_line(v_contador);
    UPDATE Contratos set numTrayectos = v_contador WHERE REFERENCIA = v_referencia;

    EXCEPTION WHEN NO_TRAYECTOS THEN
    dbms_output.put_line('La referencia no tiene trayectos');

  END;
----------------------------------  
 /
drop trigger act_numTrayectos;
CREATE OR REPLACE TRIGGER act_numTrayectos
  AFTER DELETE OR INSERT ON Trayectos
  FOR EACH ROW
  BEGIN
  IF DELETING THEN
    UPDATE Contratos SET NUMTRAYECTOS = NUMTRAYECTOS - 1 WHERE REFERENCIA = :NEW.REFERENCIA;
  ELSE 
    UPDATE Contratos SET NUMTRAYECTOS = NUMTRAYECTOS + 1 WHERE REFERENCIA = :NEW.REFERENCIA;
  END IF;
  END;

 /
 
 set serveroutput on;
 
 begin
 contadorTrayectos('ismael');
 contadorTrayectos('josema');
 end;
 
 /
 
 /*2
a. Implementar un trigger que registre en la tabla Cambios cualquier modificación 
que se produzca en el salario de un empleado, indicando el usuario en la que se
realizó.El identificador se obtendrá de una secuencia denominada SEQCambios.
b. Escribir un procedimiento almacenado que liste por departamento el nombre y 
salario de cada empleado cuyo salario sea inferior a la media del departamento. 
Incluir el total de dichos salarios por departamento
 */

CREATE TABLE Empleados( DNI CHAR(9) PRIMARY KEY,
 Nombre VARCHAR(100),
 CodDept CHAR(5) REFERENCES Departamentos on
 delete set NULL,
 Salario NUMBER(4,0));
 
CREATE TABLE Departamentos(
 CodDept CHAR(5) PRIMARY KEY,
 Nombre VARCHAR(100));
 
CREATE TABLE Cambios(IdCambio VARCHAR(10) PRIMARY KEY,
 Usuario VARCHAR(12),
 SalarioAnt NUMBER(4,0),
 SalarioNew NUMBER(4,0));
 
 insert into departamentos values ('002', 'tecnologia');
 insert into departamentos values ('003', 'putoamismo');
 insert into empleados values ('254', 'pepe', '002', 450);
  insert into empleados values ('315', 'jjaa', '002', 300);
   insert into empleados values ('335', 'lñkl', '002', 300);
   insert into empleados values ('86', 'puta', '003', 500);
    insert into empleados values ('584', 'putoamo', '003', 500);
    insert into empleados values ('685', 'ismael', '003', 400);
    insert into empleados values ('698', 'ismaelputa', '003', 400);
 update empleados set salario = salario * 1.5 where DNI = '254';
 select * from departamentos;
 select * from empleados;
 select * from cambios;

select e.nombre, e.salario, e.CODDEPT
from empleados e join departamentos d on d.CODDEPT = e.CODDEPT
where e.SALARIO <= 
(select avg(e2.salario) 
from empleados e2 
where e2.CODDEPT = e.CODDEPT
group by e2.coddept)
order by e.coddept desc;

 /
CREATE SEQUENCE SEQCambios INCREMENT BY 1;
drop sequence seqcambios;
/
--¿Como consigo el nombre de usuario para insertarlo en cambios?
create or replace trigger reg_cambios
before update of salario
on empleados
for each row

begin

insert into cambios values(SEQcambios.NEXTVAL, user, :old.salario, :new.salario);
end;
 
/
---------------------------------------------------
create or replace procedure info_dep
is
/*cursor cursorDep is
select distinct d.coddept, d.NOMBRE
from empleados e join departamentos d on d.CODDEPT = e.CODDEPT
where e.SALARIO <=
(select avg(e2.salario) 
from empleados e2 
where e2.CODDEPT = d.CODDEPT
group by e2.coddept)
order by d.coddept desc;*/
depActual char(5) := '-';
v_total number := 0;

cursor cursorDepEmp is
select e.nombre, e.salario, e.CODDEPT
from empleados e join departamentos d on d.CODDEPT = e.CODDEPT
where e.SALARIO <= 
(select avg(e2.salario) 
from empleados e2 
where e2.CODDEPT = e.CODDEPT
group by e2.coddept)
order by e.coddept desc;

--rDepEmp cursorDepEmp%ROWTYPE;
---rEmpleados cursorEmp%ROWTYPE;
begin

--open cursorDepEmp;
--open cursorEmp;
    --fetch cursorDepEmp into rDepEmp;
for rDepEmp in cursorDepEmp loop
   -- exit when cursorDepEmp%notfound;
      if(rDepEmp.coddept != depActual and depActual = '-') then
          dbms_output.put_line(rDepEmp.coddept);
      elsif (rDepEmp.coddept != depActual) then
          dbms_output.put_line(v_total);
          dbms_output.put_line(rDepEmp.coddept);
          v_total := 0;
      END IF;
       v_total := v_total + rDepEmp.salario;
       dbms_output.put_line(rDepEmp.nombre || ' ' || rDepEmp.salario);
       depActual := rDepEmp.coddept;
       
end loop;

if(v_total) != 0 then
  dbms_output.put_line(v_total);
end if;
--close cursorDepEmp;
--close cursorEmp;
end;
 
 /
 begin 
 info_dep();
 end;
 /
 
 /*3
 a. Escribir un procedimiento almacenado que reciba por argumento el nombre de
una revista y muestre por consola los datos de la revista (ISSN, Nombre) y los
nombres y apellidos de todos sus autores. Si no tiene autores debe indicar ‘No
tiene autores’.

b. Implementar un trigger que mantenga actualizada la columas NúmAutores.
 */
 
 Create table Autor2 (
DNI CHAR(9) PRIMARY KEY,
Nombre VARCHAR(50) NOT NULL,
Apellido VARCHAR(50) NOT NULL,
Pais VARCHAR(30) NOT NULL,
NumArticulos NUMBER(3,0) NOT NULL);

Create table Revista2 (
ISSN VARCHAR(9) PRIMARY KEY,
Nombre VARCHAR(100) NOT NULL);

Create table Articulo2 (
DOI CHAR(30) PRIMARY KEY,
Titulo VARCHAR(100) NOT NULL,
ISSNRevista VARCHAR(9) NOT NULL REFERENCES Revista2(ISSN) ON DELETE CASCADE,
NumAutores NUMBER(1,0) NOT NULL);

Create table Firma2 (
DNI CHAR(9) NOT NULL REFERENCES Autor2,
DOI CHAR(30) NOT NULL REFERENCES Articulo2 ON DELETE CASCADE,
PRIMARY KEY(DNI, DOI));
  
  insert into autor2 values ('jaja00000', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into autor2 values ('pedro', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into autor2 values ('mariano', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into autor2 values ('juan', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into autor2 values ('elias', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into autor2 values ('jaime', 'idsdj', 'sdmfd', 'jdsf', 5);
  insert into revista2 values ('5555', 'ismael');
  insert into revista2 values ('55df', 'hola');
  insert into revista2 values ('sdif', 'mundo');
  insert into articulo2 values ('doi', 'titulo', '5555', 1);
  insert into articulo2 values ('puta', 'tisdo', '55df', 1);
  insert into articulo2 values ('pepe', 'dsfd', 'sdif', 1);
  insert into firma2 values ('jaja00000', 'doi');
  insert into firma2 values ('pedro', 'doi');
  insert into firma2 values ('mariano', 'puta');
  insert into firma2 values ('juan', 'pepe');
  insert into firma2 values ('elias', 'pepe');
  insert into firma2 values ('jaime', 'pepe');
  delete from firma2 where DOI = 'puta';
  delete from firma2 where DNI = 'pedro';
  drop table firma2;
  drop table articulo2;
  drop table revista2;
  truncate table firma2;
  truncate table articulo2;
  truncate table revista2;
  truncate table autor2;
  select  * from revista2;
  select * from autor2;
  select * from articulo2;
  select * from firma2;
  /

create or replace procedure infoRevista (v_nombre_revista varchar)
is
cursor cursorRevistas  is
select r.issn, au.nombre, au.apellido
from revista2 r join articulo2 ar on r.issn = ar.issnRevista
join firma2 f on ar.doi = f.doi 
join autor2 au on f.DNI = au.DNI
where r.nombre = v_nombre_revista;

v_cont_autores number := 0;
NO_AUTORES EXCEPTION;

begin 

for rRevistas in cursorRevistas loop
  dbms_output.put_line(rRevistas.issn || ', ' || v_nombre_revista 
  || ', ' || rRevistas.nombre || ', ' || rRevistas.apellido);
  v_cont_autores := v_cont_autores + 1;
end loop;
  
  if(v_cont_autores = 0) then
    RAISE NO_AUTORES;
  end if;
  
  EXCEPTION 
  when NO_AUTORES THEN
  dbms_output.put_line('No tiene autores');
end;

 /
 begin
 infoRevista('ismael');
 end;
 
 /
 --¿essta bien?
 create or replace trigger act_autores 
 after insert or delete 
 on firma2
 for each row
 begin
 if inserting then
  update articulo2 set numAutores = numAutores + 1 
  where :new.doi = articulo2.doi;
 else 
  update articulo2 set numAutores = numAutores - 1 
  where :old.doi = articulo2.doi;
 end if;
end;
 
 /
 alter trigger act_autores enable;
 
 /
 
 /*4
 a. Escribir un procedimiento almacenado que reciba por argumentos una fecha, los
códigos de un aeropuerto de origen y uno de destino y un pasaporte y registre
un billete en el primer vuelo en el que haya plazas libres. En caso de que no haya
vuelos disponibles se informará mediante un mensaje.

b. Implementar un trigger que registre en la tabla Ventas el número total de billetes
vendidos y el importe total de las ventas para cada vuelo. En el caso de
devolución de un billete tan solo se reintegrará un importe fijo de 150€, no el
importe total del billete.
 */
 
 DROP TABLE VENTAS;
 DROP TABLE BILLETES;
 DROP TABLE VUELO;
 DROP TABLE AEROPUERTO;
 
 Create table Aeropuerto(
Codigo CHAR(6) PRIMARY KEY,
Nombre VARCHAR(30) NOT NULL,
Pais VARCHAR(30)NOT NULL);

Create table Vuelo(
Numero CHAR(6),
Fecha DATE,
Origen CHAR(6) NOT NULL,
Destino CHAR(6) NOT NULL,
Importe NUMBER(6,2),
Plazas NUMBER(3) DEFAULT 100,
primary key (numero,fecha),
unique (fecha, origen, destino),
check(origen<>destino));

Create table Billetes(
Numero CHAR(6),
Fecha DATE NOT NULL,
Pasaporte CHAR(10) NOT NULL,
PRIMARY KEY(Numero, fecha, pasaporte),
FOREIGN KEY(Numero, fecha) REFERENCES vuelo);

Create table Ventas(
Numero CHAR(6),
Fecha DATE,
Importe NUMBER(6,2),
Vendidos NUMBER(3) DEFAULT 0,
primary key (Numero, Fecha),
foreign key (Numero, Fecha) REFERENCES Vuelo);

insert into aeropuerto values ('codigo', 'nombre', 'pais');
insert into aeropuerto values ('cod2', 'nomb2', 'pais2');
insert into vuelo values ('111', to_date('18/01/1995'), 'mad', 'bar', 180.00, 100);
insert into billetes values('111',  to_date('18/01/1995'), 'pass01');
delete from billetes where pasaporte  = 'jaja';
update vuelo set plazas = 100;

delete from vuelo;
select * from aeropuerto;
select * from vuelo;
select * from billetes;
select * from ventas;
/

CREATE OR REPLACE PROCEDURE reg_billete (v_fecha date, v_origen CHAR, v_destino CHAR, v_pasaporte CHAR) 
IS
v_vuelo_libre char(6);
no_vuelos_libres exception;
begin

select max(v.NUMERO) into v_vuelo_libre
from vuelo v 
where v.FECHA = v_fecha
and v.ORIGEN = v_origen
and v.DESTINO = v_destino
and v.PLAZAS - (select count(*) from billetes b where b.numero = v.NUMERO) > 0
order by v.numero desc;

if(v_vuelo_libre is null) then
  raise no_vuelos_libres;
end if;

insert into billetes values(v_vuelo_libre, v_fecha, v_pasaporte);

exception
when no_vuelos_libres then
  dbms_output.put_line('no hay vuelos libres');
end;

/
begin
reg_billete(to_date('18/01/1995'), 'mad', 'bar','puto amo');
end;
/

create or replace trigger act_ventas 
after insert or delete on billetes
for each row

declare
v_importe number;
v_cont number;
begin
  if inserting  then
      select distinct v.importe
      into v_importe
      from vuelo v 
      where v.numero = :new.numero and v.fecha = :new.fecha;
      
      select count(*) into v_cont from ventas where NUMERO = :new.numero;
      if (v_cont = 0) then 
           insert into ventas values (:new.numero, :new.fecha, v_importe, 1);
      else 
           update ventas set vendidos = vendidos + 1 where FECHA = :new.fecha and NUMERO = :new.numero;
           update ventas set importe = v_importe * VENDIDOS where FECHA = :new.fecha and NUMERO = :new.numero;
      end if;
  else 
      select distinct v.importe
      into v_importe
      from vuelo v 
      where v.numero = :old.numero and v.fecha = :old.fecha;
      
      update ventas set vendidos = vendidos - 1 where FECHA = :old.fecha and NUMERO = :old.numero;
      update ventas set importe = IMPORTE - 150 where FECHA = :old.fecha and NUMERO = :old.numero;
     
  end if;
end;

/

/*5. Diseñar un trigger asociado a la operación delete de la tabla ComisionCC, de modo que si
la cuenta del registro que se borre se encuentra en la tabla deposito indique en log un
mensaje que indique la cc, el importe y el texto “Deposito asociado”. En caso contrario el
texto indicará “Cliente preferente”
*/

--Error al probar el delete
drop table ComisionCC;
drop table deposito;
drop table log;
create table ComisionCC(cc char(20), importe number(10,2));
create table deposito(cc char(20));
create table log( msg varchar(50));

/
create or replace trigger delete_com
before delete on ComisionCC
for each row
declare 
v_cont number;
begin

select count(*) into v_cont from deposito d where d.CC = :old.cc;

  if v_cont = 0 THEN
    insert into log values ('Deposito asociado ' || :old.cc || ' ' || :old.importe);
  ELSE  
   insert into log values ('Cliente preferente' || :old.cc || ' ' || :old.importe);
  END IF;
end;

/
-----pruebas-----
select * from comisioncc;
select * from deposito;
select * from log;
truncate table log;
insert into Comisioncc values ('12345678900987654321',13.9);
insert into Comisioncc values('12345123131333344321',13.0);
insert into Comisioncc values ('37423462487654321478',13.9);
insert into deposito values ('37423462487654321478');
delete from ComisionCC;
/

/*6. Diseñar un trigger asociado a la operación de inserción de la tabla Marcas, de modo que si
el tiempo de la prueba que se inserte es un nuevo record se actualice el registro
correspondiente en la tabla Records. */

drop table Records;
drop table Marcas;
create table Records(prueba number primary key, tiempo number);
create table Marcas(prueba number, fecha date, tiempo number, primary key
(prueba,fecha));

/

CREATE OR REPLACE TRIGGER act_records
after insert on marcas
for each row
declare
v_cont number;
v_menor_tiempo number;
begin

select count(*) into v_cont from records r where r.prueba = :new.prueba;

  if v_cont = 0 then
    insert into records values(:new.prueba, :new.tiempo);
  else 
  
    select r.tiempo into v_menor_tiempo from records r where r.PRUEBA = :new.prueba;
    If(:new.tiempo < v_menor_tiempo) then
      update records set tiempo = :new.tiempo where prueba = :new.prueba;
    end if;
  end if;
end;

/
alter trigger act_records enable;
delete from Marcas;
delete from Records;
insert into Marcas values (1, to_date('01/02/2013'),3.8);
insert into Marcas values (1, to_date('02/02/2013'),4.2);
insert into Marcas values (1, to_date('03/02/2013'),3.5);
select * from marcas;
select * from records;

/

/*
7. Escribir un trigger asociado a la inserción de filas en Ejemplares, de forma que si el isbn no
aparece en Libros, se cree una fila en Libros con dicho isbn y copias con valor 1, de forma
que se evite el error por la violación de la foreign key. En caso de existir, el número de
ejemplares se incrementará en uno. Prueba insertando Ejemplares que satisfagan ambas
condiciones.
*/

drop table Libros cascade constraints;
drop table Ejemplares cascade constraints;
create table Libros(
 isbn char(13) primary key,
 copias integer);
create table Ejemplares(
 signatura char(5) primary key,
 isbn char(13) not null,
 FOREIGN KEY (isbn) REFERENCES Libros);
  
  insert into ejemplares values('puta', '111');
  insert into ejemplares values('perra', '111');
  insert into ejemplares values('jose', '222');
  
  select * from ejemplares;
  select * from libros;
/

create or replace trigger inser_ejemplares
before insert on ejemplares
for each row
declare
v_cont number;
begin

select count(*) into v_cont from libros l where l.isbn = :new.isbn;

if(v_cont = 0) then
  insert into libros values(:new.isbn, 1);
else 
  update libros  l set copias = copias + 1 where l.ISBN = :new.isbn;
end if;
end;

/

/*Examen febrero 2015-EJercicio 3.a
 Escribe un procedimiento almacenado que recibe como parámetros de entrada la
referencia de un recorrido (que se asume que existe) y una fecha. El procedimiento asignará el
primer guía libre por orden alfabético (asumimos que no hay guías con el mismo nombre) y dará
de alta al grupo (en la tabla Grupos) con un identificador de reserva que se obtendrá de una
secuencia denominada seq_grupos. Se debe imprimir un mensaje indicando el guía asignado y
declarar una excepción que se lance para dar un mensaje si no hay guías libres. */

create table Guias(
Nombre varchar2(30), 
Referencia varchar2(30),
constraint guias_pk primary key(Nombre, Referencia));

create table Grupos(
IdReserva varchar2(30) primary key, 
Fecha date not null, 
Nombre varchar2(30), 
Referencia varchar2(30));

create table Recuento(
Referencia varchar2(30),
Visitas number(3));

/
create sequence seq_grupos increment by 1;
drop sequence seq_grupos;
create or replace procedure asigna_guia(v_referencia varchar2, v_date date)
is
v_nombre_guia varchar2(30);
v_cont number;
no_guia exception;
begin
select min(g.nombre), count(*) into v_nombre_guia, v_cont from guias g 
where g.nombre not in 
    (select gru.nombre from grupos gru where gru.FECHA = v_date);

if (v_cont = 0) then
raise no_guia;
end if;

insert into grupos values(seq_grupos.nextval, v_date, v_nombre_guia, v_referencia);
dbms_output.put_line('Guia asignado ' || v_nombre_guia);

exception 
when no_guia then
dbms_output.put_line('No hay guias libres');
end;
/
/*
b. Para evitar mantener todas las reservas de grupos en la base de datos se utiliza la tabla
Recuento, que incluye el número total de visitas por cada recorrido en el campo Visitas. Crea un
disparador (trigger) que mantenga la tabla Recuento al borrar en la tabla Grupos
*/

create or replace trigger tri_actualizar_recuento
before delete on grupos
for each row
declare 
v_cont number;
begin
  select count(*) into v_cont from recuento where referencia = :old.referencia;

  if(v_cont = 0) then
    insert into recuento values(:old.referencia, 1);
  else 
    update recuento set visitas = visitas + 1
    where referencia = :old.referencia;
  end if;
end;