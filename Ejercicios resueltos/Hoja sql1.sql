drop table Ejemplar_Revista cascade constraints;
drop table Suscripcion cascade constraints;
drop table Ejemplar_Libro cascade constraints;
drop table Clasifica cascade constraints;
drop table Tema cascade constraints;
drop table Libro cascade constraints;
drop table Revista cascade constraints;
drop table Socio cascade constraints;
drop table Biblioteca cascade constraints;
drop table Publicacion cascade constraints;
drop table Editorial cascade constraints;

create table Editorial (
  Nombre varchar2(30) primary key,
  Direccion varchar2(30) not null,
  Telefono integer not null);
  
create table Publicacion (
  ISBN varchar2(30) primary key,
  Titulo varchar2(50) not null,
  Idioma varchar2(15) not null,
  NEditorial varchar2(30) not null references Editorial);
  
create table Biblioteca (
  Distrito varchar2(15) primary key);
  
create table Socio(
  NCarnet varchar2(30) primary key,
  Nombre varchar2(30) not null,
  DNI varchar2(15) not null unique,
  email varchar2(30) not null,
  Distrito varchar2(15) not null references Biblioteca);
  
create table Revista(
  ISBN varchar2(30) primary key references Publicacion,
  Periodo varchar2(30) not null);
  
create table Libro(
  ISBN varchar2(30) primary key references Publicacion,
  Edicion integer not null,
  Fecha date not null);
  
create table Tema(
  IdTema varchar2(30) primary key,
  Descripcion long not null);
  
create table Clasifica(
  ISBN varchar2(30) not null CONSTRAINT cl_ISBN_FK REFERENCES Publicacion,
  IdTema varchar2(30) not null CONSTRAINT cl_IdTema_FK REFERENCES Tema,
  CONSTRAINT cl_PK PRIMARY KEY (ISBN, IdTema));
  
create table Ejemplar_Libro(
  ISBN varchar2(30) not null CONSTRAINT EL_ISBN_FK REFERENCES Libro,
  Distrito varchar2(15) not null CONSTRAINT EL_Distrito_FK REFERENCES Biblioteca,
  Numero varchar2(30) not null,
  FechaCompra date not null,
  NSocio varchar2(30) CONSTRAINT EL_NSocio_FK REFERENCES Socio,
  FechaP date,
  CONSTRAINT EL_PK PRIMARY KEY (ISBN, Distrito, Numero));
  
create table Suscripcion(
  ISBN varchar2(30) not null CONSTRAINT sus_ISBN_FK REFERENCES Revista,
  Distrito varchar2(15) not null CONSTRAINT sus_Distristo_FK REFERENCES Biblioteca,
  FechaSuscripcion date not null,
  CONSTRAINT sus_PK PRIMARY KEY (ISBN, Distrito));
  
create table Ejemplar_Revista(
  ISBN varchar2(30) not null,
  Distrito varchar2(15) not null,
  Numero varchar2(30) not null,
  FechaCompra date not null,
  NSocio varchar2(30) CONSTRAINT ER_NSocio_FK REFERENCES Socio,
  FechaP date,
  CONSTRAINT ER_PK PRIMARY KEY (ISBN, Distrito, Numero),
  CONSTRAINT ER_sus_FK FOREIGN KEY (ISBN, Distrito) REFERENCES Suscripcion);
  
  insert into Editorial VALUES ('Pearson Educacion SA', 'Ribera del Loira, 28.', 911234567);
  insert into Publicacion VALUES ('978-84-782-9085-7', 'Fundamentos de Sistemas de Bases de Datos',
'Espanol', 'Pearson Educacion SA');

/*
create table Distribucion(
  codigoPr varchar2(5) primary key,
  DNI varchar2(10),
  horas integer);

insert into Distribucion values ('PR1', '27347234T', 20);
insert into Distribucion values ('PR2', '27347234T', 25);
insert into Distribucion values ('PR3', '27347234T', 25);

SELECT DNI FROM Distribucion WHERE horas > 20;

select * from Publicacion;

SELECT codigoPr || ' - ' || DNI, Horas/8
FROM distribucion;

select DNI "DNI DEL EMPLEADO" FROM Distribucion;

select CodigoPr, DNI, horas FROM Distribucion where horas > 10 order by CodigoPR ASC, horas DESC;
*/
insert into Libro values('978-84-782-9085-7', 555, TO_DATE('18/01/1995'));

