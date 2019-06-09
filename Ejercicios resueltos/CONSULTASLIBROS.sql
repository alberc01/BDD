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

insert into lIBRO values ('8233771378567', 'Todo bajo el cielo', '2008', 9.45, 13.45);--
insert into lIBRO values ('1235271378662', 'La catedral del mar', '2009', 12.50, 19.25);
insert into lIBRO values ('4554672899910', 'La sombra del viento', '2002', 19.00, 33.15);--
insert into lIBRO values ('5463467723747', 'Don Quijote de la Mancha', '2000', 49.00, 73.45);--
insert into lIBRO values ('0853477468299', 'La sangre de los inocentes', '2011', 9.45, 13.45);
insert into lIBRO values ('1243415243666', 'Los santos inocentes', '1997', 10.45, 15.75);--
insert into lIBRO values ('0482174555366', 'Noches Blancas', '1998', 4.00, 9.45);--


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

-- 1. Lista de libros disponibles con su autor y año de publicación ordenada por este último.

select l.isbn, l.titulo, au.nombre, l.año
from libro l join AUTOR_LIBRO al on l.ISBN = al.ISBN
join AUTOR au on al.AUTOR = au.IDAUTOR
order by año;

-- 2. Lista de libros disponibles publicados después del año 2000.

select l.isbn, l.titulo, au.nombre, l.año
from libro l join AUTOR_LIBRO al on l.ISBN = al.ISBN
join AUTOR au on al.AUTOR = au.IDAUTOR
where l."AÑO" > 2000
order by año;

-- 3. Lista de Clientes que han realizado algún pedido

select cl.idcliente, cl.nombre
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE;

-- 4. Lista de clientes que han adquirido el libro con ISBN = 4554672899910.

select cl.idcliente, cl.nombre
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
where lp.ISBN = '4554672899910'; 

-- 5. Lista de los clientes y los libros adquiridos por ellos cuyo nombre (del cliente) contenga ‘San’.

select cl.idcliente, cl.nombre, l.ISBN, l.TITULO
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
where cl.NOMBRE like '%San%'; 

-- 6. Lista de Clientes que hayan comprado libros de más de 10 euros.

select distinct cl.idcliente, cl.nombre
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
where l.PRECIOVENTA > 10; 

-- 7. Clientes y fecha de pedidos que han realizado que no han sido expedidos aun.

select distinct cl.idcliente, cl.nombre, p.FECHAPEDIDO
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
where p.FECHAEXPED is null; 

-- 8. Lista de clientes que NO han comprado libros de precio superior a 10 euros

select distinct cl.idcliente, cl.nombre
from cliente cl 
where cl.IDCLIENTE not in 
(select cl2.IDCLIENTE
from cliente cl2 join pedido p on cl2.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
where l.precioventa > 10);

-- 9. Lista de libros vendidos con precio superior a 30 euros o publicados antes del año 2000

select l.isbn, l.titulo, l."AÑO", l.PRECIOVENTA
from libro l join LIBROS_PEDIDO lp on l.ISBN = lp.ISBN
where l.PRECIOVENTA > 30 or l."AÑO" < 2000;

-- 10. Clientes que han hecho más de un pedido el mismo día.

select cl.IDCLIENTE, cl.NOMBRE, p.FECHAPEDIDO
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
group by cl.idcliente, cl.nombre, p.FECHAPEDIDO having count(*) > 1;

-- 11. Lista de títulos de libros vendidos y cantidad.

select l.isbn, l.titulo, sum(lp.cantidad) as cantidad
from libro l join LIBROS_PEDIDO lp on l.ISBN = lp.ISBN
group by l.isbn, l.titulo;

-- 12. Lista de Clientes junto al importe total gastado en la librería

select cl.IDCLIENTE, cl.NOMBRE, sum(l.PRECIOVENTA) as TOTAL_GASTADO
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
group by cl.idcliente, cl.nombre;

-- 13. Ganancias obtenidas por la librería con las ventas

select sum(l.precioventa) - sum(l.preciocompra) as ganancias_libreria
from libro l join LIBROS_PEDIDO lp on l.ISBN = lp.ISBN;

-- 14. Lista de importe total de pedidos por fecha, que se hayan realizado después del 01/12/2011 y no hayan sido expedidos

select p.FECHAPEDIDO, sum(l.PRECIOVENTA) as importe_total
from libro l join LIBROS_PEDIDO lp on l.ISBN = lp.ISBN
join pedido p on p.IDPEDIDO = lp.IDPEDIDO
where p.FECHAPEDIDO > to_date('01/12/2011') and p.FECHAEXPED is null
group by p.FECHAPEDIDO;

-- 15. Pedidos con importe superior a 100 euros

select lp.idpedido, sum(l.PRECIOVENTA *lp.CANTIDAD) as importe_total
from LIBROS_PEDIDO lp join libro l on l.ISBN = lp.ISBN 
group by lp.idpedido having sum(l.precioventa * lp.CANTIDAD) > 100;

-- 16. Pedidos con importe total que contengan más de un titulo

select lp.idpedido, sum(l.PRECIOVENTA), count(*) as num_titulos
from LIBROS_PEDIDO lp join libro l on l.ISBN = lp.ISBN 
group by lp.idpedido having count(*) > 1;

-- 17. Pedidos con importe total que contengan más de 4 libros (ejemplares)

select lp.idpedido, sum(l.PRECIOVENTA), sum(lp.CANTIDAD) as num_libros
from LIBROS_PEDIDO lp join libro l on l.ISBN = lp.ISBN 
group by lp.idpedido having sum(lp.cantidad) > 4;
 
-- 18. Lista de libros más caros.

select l.ISBN, l.TITULO
from libro l
where l.PRECIOVENTA = 
(select max(l2.precioventa)
from libro l2);

-- 19. Libros de los que no se haya vendido ningún ejemplar o cuyo beneficio sea inferior a 5 euros

select l.ISBN, l.TITULO
from libro l
where l.ISBN not in 
(select l2.ISBN 
from libro l2 join LIBROS_PEDIDO lp on l2.ISBN = lp.ISBN)
or l.isbn not in
(select l3.ISBN 
from libro l3 join LIBROS_PEDIDO lp on l3.ISBN = lp.ISBN 
group by l3.ISBN having sum(lp.CANTIDAD)* (sum(l3.PRECIOVENTA) - sum(l3.PRECIOCOMPRA)) >= 5);

----------------------------------------------------------------
select l.ISBN, l.TITULO
from libro l
minus
((select l2.ISBN, l2.titulo
from libro l2 join LIBROS_PEDIDO lp on l2.ISBN = lp.ISBN 
group by l2.ISBN, l2.titulo having sum(sum(l2.PRECIOVENTA) - sum(l2.PRECIOCOMPRA) >= 5)
union
(select l3.ISBN, l3.titulo
from libro l3 join LIBROS_PEDIDO lp2 on l3.ISBN = lp2.ISBN));

---------------------------------------------------------
select l.ISBN, l.TITULO
from libro l
where not exists
(select l2.ISBN 
from libro l2 join LIBROS_PEDIDO lp on l2.ISBN = lp.ISBN
where l.ISBN = l2.ISBN)
or not exists
(select l3.ISBN 
from libro l3 join LIBROS_PEDIDO lp on l3.ISBN = lp.ISBN 
where l.ISBN = l3.isbn
group by l3.ISBN having sum(l3.PRECIOVENTA) - sum(l3.PRECIOCOMPRA) >= 5);

-- 20. Clientes que hayan comprado más de un ejemplar de un título en alguna ocasión

select cl.IDCLIENTE, cl.NOMBRE, l.TITULO, sum(lp.CANTIDAD) as cantidad
from cliente cl join pedido p on cl.IDCLIENTE = p.IDCLIENTE
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join LIBRO l on l.ISBN = lp.ISBN
group by cl.idcliente, cl.nombre, l.titulo having sum(lp.cantidad) > 1;

-- 21. Lista de Nombre de cliente, numero de pedido, isbn y título de libros adquiridos. Si no han adquirido ningún libro mostrar el nombre del cliente también.

select cl.nombre, lp.idpedido, lp.isbn, l.titulo
from cliente cl left outer join (pedido p
join LIBROS_PEDIDO lp on lp.IDPEDIDO = p.IDPEDIDO
join libro l on l.ISBN = lp.ISBN) on cl.IDCLIENTE = p.IDCLIENTE;


