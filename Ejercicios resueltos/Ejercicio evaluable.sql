--Ismael Setti Alonso
--Jose Manuel Pinto Lozano
/*
Ejercicio 0. Para estos ejercicios debes utilizar las tablas y los datos del fichero Script Libreria.sql de los
Ejercicios de SQL (II) del Campus Virtual. Ejecuta este script completo antes de continuar. Vamos a a˜nadir a
la base de datos de la librer´?a una tabla para controlar el stock del almac´en de la tienda (n´umero de ejemplares de
cada libro en el almac´en).
a) Crea una tabla denominada Existencias que contendr´a los datos de los libros que tiene el almac´en de la
librer´?a. Debe tener las siguientes columnas:
• ISBN: C´odigo ISBN de los libros de la librer´?a.
• Stock: n´umero de ejemplares disponibles en el almac´en de este libro.
• StockMin: n´umero de ejemplares m´?nimo que debe haber en el almac´en; por debajo de este valor se
deben pedir m´as ejemplares a la editorial.
b) Escribe una sentencia INSERT que realice una carga inicial de la tabla Existencias. Esta sentencia debe
insertar en esta tabla una fila por cada libro de la tabla Libro con los siguientes datos:
• ISBN: C´odigo ISBN del libro correspondiente.
• Stock: el resultado de la expresi´on 10 ? X, donde X es el n´umero total de ejemplares pedidos de ese
libro hasta el momento (contenidos en la tabla Libros Pedido).
• StockMin: el valor 5 en todas las filas.

Ejercicio 1. Escribe un trigger que cuando se realice alg´un cambio en la tabla Libros Pedido, actualice la informaci´on
de la columna Stock en la tabla Existencias: al a˜nadir una nueva entrada de un pedido, al eliminar
una entrada de un pedido y al modificar la cantidad de una entrada de un pedido. Si la cantidad en Stock se hace
negativa debe mostrar un mensaje de error por pantalla en el que se indique que el libro con ese ISBN tiene stock
negativo.
Inserta y actualiza algunos pedidos para que se ejecute el trigger y de esta forma se modifiquen los datos de la tabla
Existencias de manera que haya varias filas en las que se cumpla Stock < StockMin.

Ejercicio 2. Escribe un procedimiento PL/SQL denominado ListaPedidosUrgentes que escriba en pantalla
(PUT LINE) todos los libros de los que se disponen menos existencias en stock de las indicadas en StockMin. De cada
libro se deben mostrar en pantalla los siguientes datos: ISBN, t´?tulo, el n´umero de ejemplares que hay que pedir a
la editorial para que en el almac´en se disponga de un stock igual a 2*StockMin, y por ´ultimo el importe de compra
de estos ejemplares. Al final del listado se debe mostrar el importe total de los pedidos a realizar a la editorial.

*/
drop table Cliente cascade constraints;
drop table Pedido cascade constraints;
drop table Autor cascade constraints;
drop table Autor_Libro cascade constraints;
drop table Libro cascade constraints;
drop table Libros_Pedido cascade constraints;

create table Cliente
(IdCliente CHAR(10) PRIMARY KEY,
 Nombre VARCHAR(25) NOT NULL,
 Direccion VARCHAR(60) NOT NULL,
 NumTC CHAR(16) NOT NULL);
 
create table Pedido
(IdPedido CHAR(10) PRIMARY KEY,
 IdCliente CHAR(10) NOT NULL REFERENCES Cliente on delete cascade,
 FechaPedido DATE NOT NULL,
 FechaExped DATE);

create table Autor
( idautor NUMBER PRIMARY KEY,
  Nombre VARCHAR(25));

create table Libro
(ISBN CHAR(15) PRIMARY KEY,
Titulo VARCHAR(60) NOT NULL,
Año CHAR(4) NOT NULL,
PrecioCompra NUMBER(6,2) DEFAULT 0,
PrecioVenta NUMBER(6,2) DEFAULT 0);

create table Autor_Libro
(ISBN CHAR(15),
Autor NUMBER,
CONSTRAINT al_PK PRIMARY KEY (ISBN, Autor),
CONSTRAINT libroA_FK FOREIGN KEY (ISBN) REFERENCES Libro on delete cascade,
CONSTRAINT autor_FK FOREIGN KEY (Autor) REFERENCES Autor);


create table Libros_Pedido(
ISBN CHAR(15),
IdPedido CHAR(10),
Cantidad NUMBER(3) CHECK (cantidad >0),
CONSTRAINT lp_PK PRIMARY KEY (ISBN, idPedido),
CONSTRAINT libro_FK FOREIGN KEY (ISBN) REFERENCES Libro on delete cascade,
CONSTRAINT pedido_FK FOREIGN KEY (IdPedido) REFERENCES Pedido on delete cascade);

create table Existencias(
ISBN CHAR(15) primary key,
Stock number(3),
StockMin number(3));

insert into Cliente values ('0000001','Margarita Sanchez', 'Arroyo del Camino 2','1234567890123456');
insert into Cliente values ('0000002','Angel Garcia', 'Puente Viejo 13', '1234567756953456');
insert into Cliente values ('0000003','Pedro Santillana', 'Molino de Abajo 42', '1237596390123456');
insert into Cliente values ('0000004','Rosa Prieto', 'Plaza Mayor 46', '4896357890123456');
insert into Cliente values ('0000005','Ambrosio Perez', 'Corredera de San Antonio 1', '1224569890123456');
insert into Cliente values ('0000006','Lola Arribas', 'Lope de Vega 32', '2444889890123456' );


insert into Pedido values ('0000001P','0000001', TO_DATE('01/12/2011'),TO_DATE('03/12/2011'));
insert into Pedido values ('0000002P','0000001', TO_DATE('01/12/2011'),null);
insert into Pedido values ('0000003P','0000002', TO_DATE('02/12/2011'),TO_DATE('03/12/2011'));
insert into Pedido values ('0000004P','0000004', TO_DATE('02/12/2011'),TO_DATE('05/12/2011'));
insert into Pedido values ('0000005P','0000005', TO_DATE('03/12/2011'),TO_DATE('03/12/2011'));
insert into Pedido values ('0000006P','0000003', TO_DATE('04/12/2011'),null);

insert into Autor values (1,'Matilde Asensi');
insert into Autor values (2,'Ildefonso Falcones');
insert into Autor values (3,'Carlos Ruiz Zafon');
insert into Autor values (4,'Miguel de Cervantes');
insert into Autor values (5,'Julia Navarro');
insert into Autor values (6,'Miguel Delibes');
insert into Autor values (7,'Fiodor Dostoievski');

insert into lIBRO values ('8233771378567', 'Todo bajo el cielo', '2008', 9.45, 13.45);
insert into lIBRO values ('1235271378662', 'La catedral del mar', '2009', 12.50, 19.25);
insert into lIBRO values ('4554672899910', 'La sombra del viento', '2002', 19.00, 33.15);
insert into lIBRO values ('5463467723747', 'Don Quijote de la Mancha', '2000', 49.00, 73.45);
insert into lIBRO values ('0853477468299', 'La sangre de los inocentes', '2011', 9.45, 13.45);
insert into lIBRO values ('1243415243666', 'Los santos inocentes', '1997', 10.45, 15.75);
insert into lIBRO values ('0482174555366', 'Noches Blancas', '1998', 4.00, 9.45);


insert into Autor_lIBRO values ('8233771378567',1);
insert into Autor_lIBRO values ('1235271378662',2);
insert into Autor_lIBRO values ('4554672899910',3);
insert into Autor_lIBRO values ('5463467723747',4);
insert into Autor_lIBRO values ('0853477468299',5);
insert into Autor_lIBRO values ('1243415243666',6);
insert into Autor_lIBRO values ('0482174555366',7);

insert into Libros_Pedido values ('8233771378567','0000001P', 1);
insert into Libros_Pedido values ('5463467723747','0000001P', 2);
insert into Libros_Pedido values ('0482174555366','0000002P', 1);
insert into Libros_Pedido values ('4554672899910','0000003P', 1);
insert into Libros_Pedido values ('8233771378567','0000003P', 1);
insert into Libros_Pedido values ('1243415243666','0000003P', 1);
insert into Libros_Pedido values ('8233771378567','0000004P', 1);
insert into Libros_Pedido values ('4554672899910','0000005P', 1);
insert into Libros_Pedido values ('1243415243666','0000005P', 1);
insert into Libros_Pedido values ('5463467723747','0000005P', 3);
insert into Libros_Pedido values ('8233771378567','0000006P', 5); 

select * from existencias;

insert into Existencias
select libro.isbn, 10 - sum(libros_pedido.cantidad), 5
from libro join libros_pedido on libro.isbn = libros_pedido.isbn
group by libro.isbn, 5;

insert into libros_pedido values ('4554672899910', '0000004P', 9);
insert into libros_pedido values ('0482174555366', '0000003P', 5);

insert into Existencias values ('1235271378662', 'La catedral del mar', 5);
insert into Existencias values ('4554672899910', 'La sombra del viento', 5);
insert into Existencias values ('5463467723747', 'Don Quijote de la Mancha', 5);
insert into Existencias values ('0853477468299', 'La sangre de los inocentes', 5);
insert into Existencias values ('1243415243666', 'Los santos inocentes',5);
insert into Existencias values ('0482174555366', 'Noches Blancas', 5);

commit;
/

CREATE OR REPLACE TRIGGER act_stock
AFTER INSERT OR DELETE OR UPDATE
ON Libros_pedido
FOR EACH ROW
WHEN (NEW.CANTIDAD > 0)
DECLARE 
V_ISBN CHAR(15);
V_STOCK NUMBER(3);
NEGATIVE_STOCK EXCEPTION;
BEGIN
IF INSERTING THEN
  UPDATE EXISTENCIAS SET STOCK = EXISTENCIAS.STOCK - :NEW.CANTIDAD WHERE EXISTENCIAS.ISBN=:NEW.ISBN;
ELSIF DELETING THEN
  UPDATE EXISTENCIAS SET STOCK = EXISTENCIAS.STOCK + :OLD.CANTIDAD WHERE EXISTENCIAS.ISBN=:OLD.ISBN;
ELSE
  UPDATE EXISTENCIAS SET STOCK = EXISTENCIAS.STOCK + (:OLD.CANTIDAD-:NEW.CANTIDAD) WHERE EXISTENCIAS.ISBN=:NEW.ISBN;
END IF;
 SELECT EXISTENCIAS.ISBN, EXISTENCIAS.STOCK into V_ISBN, V_STOCK FROM EXISTENCIAS WHERE EXISTENCIAS.ISBN = :NEW.ISBN;
 IF V_STOCK < 0 THEN
  RAISE NEGATIVE_STOCK;
 END IF;
EXCEPTION
WHEN NEGATIVE_STOCK THEN
  DBMS_OUTPUT.PUT_LINE('El stock del libro ' || V_ISBN || ' es negativo');
END; 

/
 set serveroutput on;

create or replace procedure ListaPedidosUrgentes
is
v_totalpedidos number(6,2):= 0;
cursor cursorLibros is
select existencias.isbn, libro.titulo, 2*existencias.stockmin - existencias.stock as tpedido, libro.PRECIOVENTA
from existencias join libro on existencias.isbn = libro.isbn where existencias.stock < existencias.stockmin;

begin
    for rExistencias in cursorLibros loop
    dbms_output.put_line(rExistencias.isbn || ', ' || rExistencias.titulo || ', ' || rExistencias.tpedido || ', ' || rExistencias.tpedido * rExistencias.precioventa);
    v_totalpedidos := v_totalpedidos + rExistencias.tpedido * rExistencias.precioventa;
    end loop;
     dbms_output.put_line(v_totalpedidos);
end;

/
begin 
ListaPedidosUrgentes;
end;
 
 

