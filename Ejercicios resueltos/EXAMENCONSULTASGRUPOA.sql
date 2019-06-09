-- ------------------------------------------------
-- Ejercicio 1. Creación de tablas.
-- ------------------------------------------------
DROP TABLE Resultado CASCADE CONSTRAINTS;
DROP TABLE Carrera CASCADE CONSTRAINTS;
DROP TABLE Tipo CASCADE CONSTRAINTS;
DROP TABLE Corredor CASCADE CONSTRAINTS;
DROP TABLE Historico CASCADE CONSTRAINTS;

CREATE TABLE Corredor
(NIF CHAR(10) PRIMARY KEY,
 Nombre VARCHAR2(25) NOT NULL,
 FecNacim DATE NOT NULL);

CREATE TABLE Tipo
(IdTipo CHAR(4) PRIMARY KEY,
 Descripcion VARCHAR2(50) NOT NULL);

CREATE TABLE Carrera
(IdCarrera NUMBER(5) PRIMARY KEY,
 Nombre VARCHAR2(50) NOT NULL,
 Fecha DATE NOT NULL,
 Tipo CHAR(4) NOT NULL REFERENCES Tipo);

CREATE TABLE Resultado
(NIF CHAR(10) REFERENCES Corredor,
 IdCarrera NUMBER(5) REFERENCES Carrera,
 Tiempo NUMBER(8,2) NOT NULL CHECK(Tiempo > 0),
 CONSTRAINT resultado_PK PRIMARY KEY (NIF,IdCarrera));

alter session set nls_date_format='DD/MM/YYYY';
INSERT INTO Corredor VALUES ('0123456789','Bikila', TO_DATE('25/01/1983'));
INSERT INTO Corredor VALUES ('0123456444','Carl Lewis', TO_DATE('01/07/1961'));
INSERT INTO Corredor VALUES ('0123456555','Caballo Blanco', TO_DATE('01/07/1985'));
INSERT INTO Corredor VALUES ('0123456666','Scott Jurek',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450001','Paula Radcliffe',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450002','Mo Farah',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450003','Jessica Ennis',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450004','Paula González',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450005','Alessandra Aguilar',TO_DATE('27/04/1981'));
INSERT INTO Corredor VALUES ('0123450006','Estela Navascués',TO_DATE('27/04/1981'));

INSERT INTO Tipo VALUES ('10K','Chatarrilla');
INSERT INTO Tipo VALUES ('21K','Media Maratón');
INSERT INTO Tipo VALUES ('42K','Maratón');
INSERT INTO Tipo VALUES ('ULT','Ultramaratón');
INSERT INTO Tipo VALUES ('100K','100 Km ultra');

INSERT INTO Carrera VALUES (1,'San Silvestre Vallecana 2016',TO_DATE('31/12/2016'),'10K');
INSERT INTO Carrera VALUES (2,'San Silvestre Vallecana 2015',TO_DATE('31/12/2015'),'10K');
INSERT INTO Carrera VALUES (3,'San Silvestre Vallecana 2014',TO_DATE('31/12/2014'),'10K');
INSERT INTO Carrera VALUES (4,'San Silvestre Vallecana 2013',TO_DATE('31/12/2013'),'10K');
INSERT INTO Carrera VALUES (5,'San Silvestre Vallecana 2012',TO_DATE('31/12/2012'),'10K');

INSERT INTO Carrera VALUES (6,'San Lorenzo 2016',TO_DATE('18/07/2016'),'10K');
INSERT INTO Carrera VALUES (7,'San Lorenzo 2015',TO_DATE('28/07/2015'),'10K');
INSERT INTO Carrera VALUES (8,'100 Km de Santander - Cantabria',TO_DATE('25/07/2016'),'100K');
INSERT INTO Carrera VALUES (9,'Media Maratón Ciudad de Segovia',TO_DATE('19/09/2015'),'21K');
INSERT INTO Carrera VALUES (10,'San Lorenzo 2014',TO_DATE('25/07/2014'),'10K');
INSERT INTO Carrera VALUES (11,'Media Maratón Ciudad Universitaria 2016',TO_DATE('13/03/2016'),'21K');
INSERT INTO Carrera VALUES (12,'Media Maratón Ciudad Universitaria 2015',TO_DATE('08/03/2015'),'21K');
INSERT INTO Carrera VALUES (13,'Media Maratón Ciudad Universitaria 2014',TO_DATE('09/03/2014'),'21K');

INSERT INTO Resultado VALUES ('0123456789',1, 31.58);
INSERT INTO Resultado VALUES ('0123456789',2, 31.58);
INSERT INTO Resultado VALUES ('0123456789',3, 31.58);
INSERT INTO Resultado VALUES ('0123456789',4, 31.58);
INSERT INTO Resultado VALUES ('0123456789',5, 31.58);
INSERT INTO Resultado VALUES ('0123456789',6, 31.58);
INSERT INTO Resultado VALUES ('0123456789',10, 32.48);

INSERT INTO Resultado VALUES ('0123456444',2, 33.44);
INSERT INTO Resultado VALUES ('0123456444',3, 33.45);
INSERT INTO Resultado VALUES ('0123456444',5, 33.46);
INSERT INTO Resultado VALUES ('0123456444',11, 75.24);
INSERT INTO Resultado VALUES ('0123456444',12, 71.44);
INSERT INTO Resultado VALUES ('0123456444',13, 70.28);

INSERT INTO Resultado VALUES ('0123456789',11, 75.24);
INSERT INTO Resultado VALUES ('0123456555',11, 75.24);
INSERT INTO Resultado VALUES ('0123456666',11, 75.24);


INSERT INTO Resultado VALUES ('0123456555',8,650.0);
INSERT INTO Resultado VALUES ('0123456555',12,68.05);
INSERT INTO Resultado VALUES ('0123456555',13,65.55);
INSERT INTO Resultado VALUES ('0123456666',9,63.25);
INSERT INTO Resultado VALUES ('0123456666',13,58.33);
INSERT INTO Resultado VALUES ('0123456666',6,30.24);

INSERT INTO Resultado VALUES ('0123450001',11,33.24);
INSERT INTO Resultado VALUES ('0123450002',11,33.25);
INSERT INTO Resultado VALUES ('0123450003',11,33.26);
INSERT INTO Resultado VALUES ('0123450004',11,33.27);
INSERT INTO Resultado VALUES ('0123450005',11,33.28);
INSERT INTO Resultado VALUES ('0123450006',11,33.29);

-- ------------------------------------------------
-- Ejercicio 2. Creación de tablas.
-- ------------------------------------------------

-- 2.1 Dada una tabla HISTORICO con la misma estructura que la
--     tabla RESULTADO, escribe una sentencia SQL que inserte en
--     HISTORICO todos los resultados de carreras de fechas 
--     anteriores a 2016.

CREATE TABLE HISTORICO(
 NIF CHAR(10) REFERENCES Corredor,
 IdCarrera NUMBER(5) REFERENCES Carrera,
 Tiempo NUMBER(8,2) NOT NULL CHECK(Tiempo > 0),
 CONSTRAINT historico_PK PRIMARY KEY (NIF,IdCarrera));

insert into historico
select r.NIF, r.IDCARRERA, r.TIEMPO
from carrera c join resultado r on c.idcarrera = r.IDCARRERA
where c.FECHA < to_date('01/01/2016');

-- 2.2 Debido a un error en el cronómetro oficial de algunas carreras,
--     algunas medidas de tiempos se deben corregir. Proporciona una
--     sentencia SQL que actualice la columna Tiempo incrementándolo
--     en un 15% para las carreras con IdCarrera con valor 3 y 5.

update resultado r set r.TIEMPO = r.TIEMPO * 1.15 
where r.IDCARRERA in (3,5);

-- ------------------------------------------------
-- Ejercicio 3. Consultas SQL.
-- ------------------------------------------------

-- 3.1 Listado con los datos de las carreras del segundo
--     semestre de 2016, ordenadas por tipo. Dentro de cada tipo, deben
--     aparecer en orden cronológico inverso.

select *
from carrera r
where r.FECHA >= to_date('01/07/2016')
and r.FECHA <= to_date('31/12/2016')
order by r.TIPO, r.FECHA desc;

-- 3.2 Listado con los corredores que han participado en la
--     carrera 'San Lorenzo 2016' y que han nacido entre 1980 y 1990.

select co.nif, co.nombre, r.tiempo
from corredor co join resultado r on co.NIF = r.NIF
join carrera car on car.IDCARRERA = r.IDCARRERA
where extract(year from co.FECNACIM) between 1980 and 1990
and car.NOMBRE like '%San Lorenzo 2016%';

-- 3.3 Listado de los corredores que han participado en
--     carreras con {IdTipo = '21K'}, proporcionando el mejor
--     tiempo y el tiempo medio de cada corredor.

select co.nif, co.nombre, min(r.tiempo), round(avg(r.TIEMPO), 2)
from corredor co join resultado r on co.NIF = r.NIF
join carrera car on car.IDCARRERA = r.IDCARRERA
where car.TIPO like '%21K%'
group by co.nif, co.nombre;

-- 3.4 Listado de los corredores que han participado en
--     alguna carrera de tipo {'Media Maratón'}, pero nunca han
--     participado en una San Silvestre

select distinct co.nif, co.nombre
from corredor co join resultado r on co.NIF = r.NIF
join carrera car on car.IDCARRERA = r.IDCARRERA
join tipo t on t.IDTIPO = car.TIPO
where t.DESCRIPCION = 'Media Maratón'
and co.nif not in 
    (select r2.nif
    from resultado r2 join carrera car2 on r2.IDCARRERA = car2.IDCARRERA
    where car2.NOMBRE like '%San Silvestre%');

-- 3.5 Listado de los mejores corredores de su misma
--     edad: debe mostrar el nombre de los corredores y las carreras en las
--     que han participado en las que han obtenido el mejor tiempo de todos
--     los corredores que nacieron el mismo año que ellos. Para extraer el
--     año de una fecha puedes utilizar la función EXTRACT(YEAR FROM
--     fecha).
--¿¿es igual??
select co.nif, co.nombre, car.nombre, r.TIEMPO
from corredor co join resultado r on co.NIF = r.NIF
join carrera car on car.IDCARRERA = r.IDCARRERA
where r.TIEMPO <= all
    (select r2.TIEMPO 
    from resultado r2 join carrera car2 on car2.IDCARRERA = r2.IDCARRERA
    join corredor co2 on co2.NIF = r2.NIF
    where car.IDCARRERA = car2.IDCARRERA
    and extract(year from co2.FECNACIM) = extract(year from co.FECNACIM))
order by co.nif;
    
----------profe-----------------

 SELECT co.NIF, co.nombre, ca.Nombre, re.Tiempo
  FROM Corredor co
  JOIN Resultado re ON co.NIF = re.NIF
  JOIN Carrera ca ON ca.IdCarrera = re.IdCarrera
  WHERE re.Tiempo = (
    SELECT MIN(re2.Tiempo) FROM Resultado re2
    JOIN Corredor co2 ON re2.NIF = co2.NIF
    JOIN Carrera ca2 ON ca2.IdCarrera = re2.IdCarrera
    WHERE ca2.IdCarrera = ca.IdCarrera 
    AND EXTRACT(YEAR FROM co2.FecNacim) = EXTRACT(YEAR FROM co.FecNacim))
order by co.nif;
    
-- 3.6 Listado de los tipos de carreras en los que han
--     participado al menos 10 corredores distintos en el año 2016. Además
--     de la descripción del tipo, debe mostrar el número de corredores y
--     el tiempo medio obtenido.

select t.IDTIPO, t.DESCRIPCION, count(distinct co.nif), avg(r.TIEMPO)
from corredor co join resultado r on co.NIF = r.NIF
join carrera car on car.IDCARRERA = r.IDCARRERA
join tipo t on t.IDTIPO = car.TIPO
where extract(year from car.FECHA) = 2016
group by t.IDTIPO, t.DESCRIPCION having count(distinct co.NIF) >= 10;
