drop table prestamo cascade constraints;
drop table ejemplar_libro cascade constraints;
drop table socio cascade constraints;
drop table libro cascade constraints;

CREATE TABLE LIBRO (
isbn varchar2(15) primary key,
titulo varchar2(50) not null,
autor varchar2(50) not null,
genero varchar2(50) not null);

CREATE TABLE SOCIO (
numsocio number(5) primary key,
nombre varchar2(50) not null,
maxejemplares number(3) not null,
edad number(3) not null);

CREATE TABLE EJEMPLAR_LIBRO (
idejemplar number(6) primary key,
isbn varchar2(15) not null references libro,
fechacompra date not null);

CREATE TABLE PRESTAMO (
ejemplar number(6) references ejemplar_libro,
fechaptmo date,
numsocio number(5) references socio,
fechavto date not null,
constraint prestamo_pk primary key (ejemplar, fechaptmo));

alter session set nls_date_format='DD/MM/YYYY';

INSERT INTO Socio VALUES(1,'Arturo Pérez-Ramírez',3,57);
INSERT INTO Socio VALUES(2,'Andrés Iniesta García',25,32);
INSERT INTO Socio VALUES(3,'Fernando Alonso Fernández',2,35);
INSERT INTO Socio VALUES(4,'Miguel Induráin Ruiz',3,51);
INSERT INTO Socio VALUES(5,'Andrés Fiz Albert',3,59);
INSERT INTO Socio VALUES(6,'Ramón Bilbao Bilbao',3,23);
INSERT INTO Socio VALUES(7,'Rodrigo Rato de Guevara',3,61);

INSERT INTO Libro VALUES ('8233771378567', 'Todo bajo el cielo', 'Matilde Asensi', 'Historia');
INSERT INTO Libro VALUES ('1235271378662', 'La catedral del mar', 'Ildefonso Falcones', 'Historia');
INSERT INTO Libro VALUES ('0853477468299', 'La sangre de los inocentes', 'Julia Navarro','Historia');
INSERT INTO Libro VALUES ('1243415243666', 'Diez negritos', 'Agatha Christie','Misterio');
INSERT INTO Libro VALUES ('0482174555366', 'El nombre de la rosa', 'Umberto Eco','Misterio');
INSERT INTO Libro VALUES ('0482174555367', '2001 Una Odisea del Espacio', 'Arthur C. Clarke','Ciencia-ficción');
INSERT INTO Libro VALUES ('0482174555368', 'Cita con Rama', 'Arthur C. Clarke','Ciencia-ficción');
INSERT INTO Libro VALUES ('0482174555369', 'La fundación', 'Isaac Asimov','Ciencia-ficción');


INSERT INTO Ejemplar_Libro VALUES (1,'8233771378567', TO_DATE('01/01/2016'));
INSERT INTO Ejemplar_Libro VALUES (2,'1235271378662', TO_DATE('01/01/2016'));
INSERT INTO Ejemplar_Libro VALUES (3,'1235271378662', TO_DATE('01/06/2016'));
INSERT INTO Ejemplar_Libro VALUES (4,'1235271378662', TO_DATE('23/08/2016'));
INSERT INTO Ejemplar_Libro VALUES (5,'0853477468299', TO_DATE('05/06/2014'));
INSERT INTO Ejemplar_Libro VALUES (6,'1243415243666', TO_DATE('05/06/2014'));
INSERT INTO Ejemplar_Libro VALUES (7,'0482174555366', TO_DATE('05/06/1990'));
INSERT INTO Ejemplar_Libro VALUES (8,'0482174555366', TO_DATE('05/06/1990'));
INSERT INTO Ejemplar_Libro VALUES (9,'0482174555366', TO_DATE('22/05/1999'));
INSERT INTO Ejemplar_Libro VALUES (10,'0482174555366', TO_DATE('22/05/1999'));
INSERT INTO Ejemplar_Libro VALUES (11,'0482174555366', TO_DATE('30/01/2005'));
INSERT INTO Ejemplar_Libro VALUES (12,'0482174555366', TO_DATE('05/06/2015'));
INSERT INTO Ejemplar_Libro VALUES (13,'0482174555367', TO_DATE('05/06/2015'));
INSERT INTO Ejemplar_Libro VALUES (14,'0482174555368', TO_DATE('05/06/2015'));
INSERT INTO Ejemplar_Libro VALUES (15,'0482174555369', TO_DATE('05/06/2015'));

INSERT INTO Prestamo VALUES (1,TO_DATE('05/06/2015'),1,TO_DATE('31/12/2015'));
INSERT INTO Prestamo VALUES (1,TO_DATE('05/07/2016'),1,TO_DATE('31/12/2017'));
INSERT INTO Prestamo VALUES (3,TO_DATE('05/08/2016'),1,TO_DATE('31/12/2017'));
INSERT INTO Prestamo VALUES (6,TO_DATE('05/09/2016'),1,TO_DATE('31/12/2017'));

INSERT INTO Prestamo VALUES (2,TO_DATE('05/06/2015'),2,TO_DATE('15/06/2015'));
INSERT INTO Prestamo VALUES (14,TO_DATE('05/08/2016'),2,TO_DATE('31/12/2016'));
INSERT INTO Prestamo VALUES (8,TO_DATE('05/12/2016'),2,TO_DATE('15/12/2016'));
INSERT INTO Prestamo VALUES (15,TO_DATE('05/12/2016'),2,TO_DATE('15/12/2016'));
INSERT INTO Prestamo VALUES (13,TO_DATE('01/12/2016'),2,TO_DATE('15/12/2017'));
INSERT INTO Prestamo VALUES (14,TO_DATE('02/12/2016'),2,TO_DATE('15/12/2017'));
INSERT INTO Prestamo VALUES (3,TO_DATE('02/12/2016'),2,TO_DATE('15/12/2017'));
INSERT INTO Prestamo VALUES (4,TO_DATE('15/12/2016'),2,TO_DATE('25/12/2017'));


INSERT INTO Prestamo VALUES (6,TO_DATE('05/10/2016'),3,TO_DATE('15/10/2016'));
INSERT INTO Prestamo VALUES (9,TO_DATE('05/11/2016'),4,TO_DATE('15/12/2016'));
INSERT INTO Prestamo VALUES (12,TO_DATE('05/12/2016'),5,TO_DATE('15/12/2016'));
INSERT INTO Prestamo VALUES (4,TO_DATE('02/12/2016'),5,TO_DATE('15/12/2016'));

INSERT INTO Prestamo VALUES (6,TO_DATE('05/07/2016'),6,TO_DATE('15/07/2016'));
INSERT INTO Prestamo VALUES (9,TO_DATE('05/08/2016'),6,TO_DATE('15/08/2016'));
INSERT INTO Prestamo VALUES (12,TO_DATE('05/09/2016'),6,TO_DATE('15/09/2016'));
INSERT INTO Prestamo VALUES (15,TO_DATE('02/12/2016'),6,TO_DATE('15/12/2016'));

-- 2.1 Supongamos (solo para este apartado) que, además de las tablas
--     anteriores, existe una tabla COMPRAS con dos columnas,
--     ISBN y NumEjemplares sin claves ni restricciones
--     definidas. Escribe una sentencia SQL que inserte en COMPRAS
--     los ejemplares de libros que se deben comprar próximamente.  Deben
--     ser aquellos libros que han sido pedidos en préstamo al menos 15
--     veces desde el 1 de septiembre. Se debe comprar un ejemplar de
--     cada libro por cada 15 peticiones de préstamo.

CREATE TABLE COMPRAS (
isbn varchar(15) not null,
numejemplares number(3) not null);

insert into compras
select el.isbn, trunc(count(*) / 15)
from  ejemplar_libro el join prestamo p on el.IDEJEMPLAR = p.EJEMPLAR
where p.FECHAPTMO >= to_date('01/09/2016')
group by el.isbn
having count(*) >= 15;

-- 2.2 Actualiza la información de la BD para incrementar en un 10% el
--     número máximo de ejemplares que pueden tomar prestados los socios
--     que han pedido prestados más de 5 ejemplares desde el 1 de
--     diciembre. 

update socio s set s.maxejemplares = round(s.maxejemplares*1.1)
where (select count(*) from prestamo p 
      where s.numsocio = p.numsocio and p.fechaptmo > to_date('01/12/1016')) > 5; 

-----------profe------------
UPDATE Socio SET MaxEjemplares = round(MaxEjemplares*1.1)
WHERE NumSocio IN (SELECT NumSocio FROM Prestamo
      WHERE FechaPtmo >= TO_DATE('01/12/2016')
      GROUP BY NumSocio 
      HAVING count(*) > 5);

-- 3.1 Listado de los ejemplares prestados
--     (IdEjemplar, FechaPtmo, FechaVto) durante el
--     tercer trimestre de 2016 que no han vencido a fecha de hoy
--     (SYSDATE). Los resultados deben estar ordenados por mes de
--     inicio del préstamo y, dentro de cada mes, por número de socio.

select * 
from prestamo p
where p.FECHAPTMO >= to_date('01/07/1016')
and p.FECHAPTMO <= to_date('30/09/2016') 
and p.FECHAVTO >= sysdate
order by extract(month from p.fechaptmo), p.NUMSOCIO;

-- 3.2 Listado de los libros que se han prestado durante 2016
--     y cuyo autor es {Arthur C. Clarke}.

select *
from prestamo p join EJEMPLAR_LIBRO el on el.IDEJEMPLAR = p.EJEMPLAR
join libro l on l.ISBN = el.ISBN
where extract(year from p.FECHAPTMO) = 2016 
and l.AUTOR like '%Arthur C. Clarke%';

-- 3.3 Listado de los libros prestados en diciembre de
--     2016, mostrando el ISBN, título y número de veces que se han prestado
--     sus ejemplares a socios distintos. 

select l.ISBN, l.TITULO, count(distinct p.NUMSOCIO) as veces_prestado
from prestamo p join EJEMPLAR_LIBRO el on el.IDEJEMPLAR = p.EJEMPLAR
join libro l on l.ISBN = el.ISBN
where p.FECHAPTMO >= to_date('01/12/2016')
and p.FECHAPTMO <= to_date('31/12/2016')
group by l.isbn, l.titulo;

-- 3.4 Listado de los socios que han tomado en préstamo al
--     menos 10 ejemplares de libros durante el segundo semestre de 2016,
--     pero no tienen prestado ningún libro de misterio. 

select s.NUMSOCIO, s.NOMBRE
from socio s join prestamo p on s.NUMSOCIO = p.NUMSOCIO
where p.FECHAPTMO >= to_date('01/04/2016')
and p.FECHAPTMO <= to_date('30/06/2016')
and s.NUMSOCIO not in
    (select s2.numsocio 
    from socio s2 join prestamo p2 on p2.NUMSOCIO = s2.numsocio
    join EJEMPLAR_LIBRO el on el.IDEJEMPLAR = p2.EJEMPLAR
    join libro l on l.ISBN = el.ISBN
    where l.GENERO = 'Misterio')
group by s.NUMSOCIO, s.NOMBRE having count(*) >= 10;

-- 3.5 Listado de aquellos socios que más libros distintos
--     han tomado prestados respecto a los demás socios de su 
--     misma edad.

select s.numsocio, s.nombre, s.EDAD
from socio s join prestamo p on s.NUMSOCIO = p.NUMSOCIO
join ejemplar_libro el on p.EJEMPLAR = el.IDEJEMPLAR
group by s.NUMSOCIO, s.nombre, s.EDAD
having count(distinct el.isbn) >= all
    (select count(distinct el2.isbn) 
    from socio s2 join prestamo p2 on s2.NUMSOCIO = p2.NUMSOCIO
    join EJEMPLAR_LIBRO el2 on el2.IDEJEMPLAR = p2.EJEMPLAR
    where s.EDAD = s2.EDAD
    group by s2.NUMSOCIO);

-- 3.6 Listado con los autores de libros que han sido prestados a como
--     mucho 10 socios distintos entre el 1 de junio y el 31 de agosto
--     de 2016.  Además del nombre del autor, se debe mostrar el número de
--     préstamos a socios distintos y la edad del socio más joven que
--     ha tomado en préstamo uno de sus libros.

select l.autor, l.isbn, count(distinct p.numsocio), min(s.EDAD) as socio_mas_joven
from libro l join EJEMPLAR_LIBRO el on el.ISBN = l.ISBN
join prestamo p on p.EJEMPLAR = el.IDEJEMPLAR
join socio s on s.NUMSOCIO = p.NUMSOCIO
where p.FECHAPTMO >= to_date('01/06/2016') 
and p.FECHAPTMO <= to_date('31/08/2016')
group by l.autor, l.isbn having count(distinct p.NUMSOCIO) <= 10;
