
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


select titulo, nombre, año 
from libro join autor_libro on libro.isbn = autor_libro.isbn 
join autor on autor_libro.autor = autor.idAutor order by año;


select titulo, nombre, año 
from libro join autor_libro on libro.isbn = autor_libro.isbn 
join autor on autor_libro.autor = autor.idAutor 
where año > 2000
order by año;


select nombre
from cliente join pedido on cliente.idcliente = pedido.idcliente order by nombre;


select nombre 
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join LIBROS_PEDIDO on pedido.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
where ISBN = '4554672899910';


select nombre, titulo
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join LIBROS_PEDIDO on pedido.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
join LIBRO on LIBROS_PEDIDO.ISBN = LIBRO.ISBN
where nombre LIKE '%San%';


select distinct nombre
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join LIBROS_PEDIDO on pedido.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
join LIBRO on LIBROS_PEDIDO.ISBN = LIBRO.ISBN
where precioventa > 10 order by nombre;


select nombre, fechapedido
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
where pedido.FECHAEXPED is NULL;


select distinct nombre
from cliente
minus
select distinct nombre
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join LIBROS_PEDIDO on pedido.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
join LIBRO on LIBROS_PEDIDO.ISBN = LIBRO.ISBN
where precioventa > 10 order by nombre;


select distinct titulo 
from libros_pedido join libro on libros_pedido.ISBN = libro.ISBN
where libro.PRECIOVENTA > 30 or libro.año < 2000;

------------
select nombre, count(*)
from cliente join pedido p1 on cliente.IDCLIENTE = p1.IDCLIENTE
join LIBROS_PEDIDO on p1.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
join pedido p2 on p2.FECHAPEDIDO = p1.FECHAPEDIDO
group by nombre having count(*) > 1;
------------

select titulo, sum(cantidad)
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN
group by titulo;


select nombre, sum(PrecioVenta)
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join LIBROS_PEDIDO on pedido.IDPEDIDO = LIBROS_PEDIDO.IDPEDIDO
join libro on LIBROS_PEDIDO.ISBN = libro.ISBN
group by nombre;

-----------------------------
select sum(PrecioVenta) - sum(PrecioCompra)
from
;
-----------------------------


select fechaPedido, sum(precioVenta)
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN
join pedido on libros_pedido.IDPEDIDO = pedido.IDPEDIDO
where pedido.FECHAEXPED is null
group by fechaPedido having fechaPedido > to_date('01/12/2011');


select pedido.IDPEDIDO, sum(precioVenta)
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN
join pedido on libros_pedido.IDPEDIDO = pedido.IDPEDIDO
group by pedido.IDPEDIDO having sum(precioVenta) > 100;


select pedido.IDPEDIDO, sum(precioVenta)
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN
join pedido on libros_pedido.IDPEDIDO = pedido.IDPEDIDO
group by pedido.IDPEDIDO having count(libro.isbn) > 1;



select pedido.IDPEDIDO, sum(precioVenta), sum(cantidad)
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN
join pedido on libros_pedido.IDPEDIDO = pedido.IDPEDIDO
group by pedido.IDPEDIDO having sum(cantidad) > 4;


select titulo
from libro
where precioVenta = (select MAX(precioVenta) from libro);


select titulo
from libro
minus
select titulo
from libro join libros_pedido on libro.ISBN = libros_pedido.ISBN 
and PRECIOVENTA - PRECIOCOMPRA > 5;


select nombre
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join libros_pedido on pedido.IDPEDIDO = libros_pedido.IDPEDIDO
and (nombre, isbn)
in
(select nombre, isbn
from cliente join pedido on cliente.IDCLIENTE = pedido.IDCLIENTE
join libros_pedido on pedido.IDPEDIDO = libros_pedido.IDPEDIDO
group by nombre, isbn having sum(cantidad) > 1);



select cliente.nombre, pedido.idPedido, libro.isbn, libro.titulo
from cliente left outer join (
pedido join libros_pedido on pedido.IDPEDIDO = libros_pedido.IDPEDIDO
join libro on libros_pedido.ISBN = libro.ISBN) on cliente.IDCLIENTE = pedido.IDCLIENTE;


commit;