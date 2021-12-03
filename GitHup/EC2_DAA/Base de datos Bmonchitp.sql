Create database DbBodegaMonchito
use DbBodegaMonchito
Go

create table Categoria (
IdCategoria int primary key identity (1,1) not null,
Nombre varchar(50) not null,
Descripcion varchar(200)
);
Go


Create Table Presentacion (
IdPresentacion int primary key identity (1,1) not null,
Nombre varchar(50) not null,
Descripcion varchar(200)
);
Go


Create table Producto (
IdProducto int primary key identity (1,1) not null,
Codigo varchar(50) not null,
Nombre varchar(50) not null,
Descripcion varchar(1000),
Imagen image,
IdCategoria int not null,
IdPresentacion int not null,
Constraint fk_IdCategoria foreign key (IdCategoria) References Categoria (IdCategoria),
Constraint fk_IdPresentacion foreign key (IdPresentacion) References Presentacion (IdPresentacion)
);
Go


Create table Proveedor(
IdProveedor int primary key identity (1,1) not null,
RazonSocial varchar(50) not null,
SectorComercial varchar(50) not null,
TipoDocumento varchar(20) not null,
NumDocumento varchar(11) not null,
Direccion varchar(100) not null,
Telefono varchar(9) not null,
Email varchar(50),
PaginaWeb varchar(100)
);
Go


Create table Empleado (
IdEmpleado int primary key identity (1,1) not null,
Nombre varchar(30) not null,
Apellidos varchar(60) not null,
Sexo varchar(1) not null,
FechaNacimiento date not null,
NumDocumento varchar(8) not null,
Direccion varchar(100) not null,
Telefono varchar(9) not null,
Email varchar(50),
Acceso varchar(20) not null,
Usuario varchar(20) not null,
Contraseña varchar(20) not null
);
Go


Create table Ingreso (
IdIngreso int primary key identity (1,1) not null,
Fecha date not null,
TipoComprobante varchar(20) not null,
Serie varchar(4) not null,
Correlativo varchar(7) not null,
Igv decimal(4,2) not null,
IdEmpleado int not null,
IdProveedor int not null,
Constraint fk_IdEmpleado foreign key (IdEmpleado) References Empleado(IdEmpleado),
Constraint fk_IdProveedor foreign key (IdProveedor) References Proveedor(IdProveedor)
);
Go

-- Agregamos la columna Estado
alter table Ingreso
add Estado varchar(7) not null
Go


Create table DetalleIngreso (
IdDetalleIngreso int primary key identity (1,1) not null,
PrecioCompra money not null,
PrecioVenta  money not null,
StockInicial int not null,
StockActual int not null,
FechaProduccion date not null,
FechaVencimiento date not null,
IdIngreso int not null,
IdProducto int not null,
Constraint fk_IdIngreso foreign key (IdIngreso) references Ingreso (IdIngreso),
Constraint fk_IdProducto foreign key (IdProducto) references Producto (IdProducto)
);
Go

Create table Cliente (
IdCliente int primary key identity (1,1) not null,
Nombre varchar(30) not null,
Apellidos varchar(60),
Sexo varchar(1),
FechaNacimiento date,
TipoDocumento varchar(20),
NumDocumento varchar(8),
Direccion varchar(100),
Telefono varchar(9),
Email varchar(50),
);
Go

alter table Cliente
alter column Apellidos varchar(60) not null;

alter table Cliente
alter column TipoDocumento varchar(20) not null;

alter table Cliente
alter column NumDocumento varchar(8) not null;



Create table Venta (
IdVenta int primary key identity (1,1) not null,
IdCliente int not null,
IdEmpleado int not null,
Fecha date not null,
TipoComprobante varchar(20),
Serie varchar(4) not null,
Correlativo varchar(7) not null,
Igv decimal(4,2) not null,
Constraint fk_IdCliente foreign key (IdCliente) references Cliente (IdCliente),
Constraint fk_IdEmpleadoV foreign key (IdEmpleado) references Empleado (IdEmpleado)
);
Go


Create table DetalleVenta (
IdDetalleVenta int primary key identity (1,1) not null,
IdVenta int not null,
IdDetalleIngreso int not null,
Cantidad int not null,
PrecioVenta money not null,
Descuento money not null,
Constraint fk_IdVenta foreign key (IdVenta) references Venta (IdVenta),
Constraint fk_IdDetalleIngreso foreign key (IdDetalleIngreso) references DetalleIngreso (IdDetalleIngreso)
);
Go


-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA CATEGORIA--------------------------------
-- Mostrar Categoria
Create proc sp_MostrarCategoria
as
Select top 200 * from Categoria
order by IdCategoria desc
Go

--Buscar por nombre
Create proc sp_BuscarCategoria
@TextoBuscar varchar(50)
as
Select * from Categoria
where Nombre like @TextoBuscar + '%'
Go

-- Insertar Categoria
Create proc sp_InsertarCategoria
@IdCategoria int output,
@Nombre varchar(50),
@Descripcion varchar(200)
as
insert into Categoria (Nombre, Descripcion)
Values (@Nombre, @Descripcion)
Go

-- Editar Categoria
Create proc sp_EditarCategoria
@IdCategoria int,
@Nombre varchar(50),
@Descripcion varchar(200)
as
update Categoria set Nombre=@Nombre, Descripcion=@Descripcion
where IdCategoria = @IdCategoria
Go

-- Eliminar Categoria
Create proc sp_EliminarCategoria
@IdCategoria int
as
delete from Categoria
where IdCategoria = @IdCategoria
Go

-- 





-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA PRESENTACION--------------------------------
-- Mostrar PRESENTACION
Create proc sp_MostrarPresentacion
as
Select top 200 * from Presentacion
order by IdPresentacion desc
Go

--Buscar por nombre
Create proc sp_BuscarPresentacionxNombre
@TextoBuscar varchar(50)
as
Select * from Presentacion
where Nombre like @TextoBuscar + '%'
Go

-- Insertar PRESENTACION
Create proc sp_InsertarPresentacion
@IdPresentacion int output,
@Nombre varchar(50),
@Descripcion varchar(200)
as
insert into Presentacion (Nombre, Descripcion)
Values (@Nombre, @Descripcion)
Go

-- Editar PRESENTACION
Create proc sp_EditarPresentacion
@IdPresentacion int,
@Nombre varchar(50),
@Descripcion varchar(200)
as
update Presentacion set Nombre=@Nombre, Descripcion=@Descripcion
where IdPresentacion = @IdPresentacion
Go

-- Eliminar PRESENTACION
Create proc sp_EliminarPresentacion
@IdPresentacion int
as
delete from Presentacion
where IdPresentacion = @IdPresentacion
Go






-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA PRODUCTO--------------------------------
-- Mostrar PRODUCTO
Create proc sp_MostrarProducto
as
Select p.IdProducto, p.Codigo, p.Nombre, p.Descripcion, p.Imagen, p.IdCategoria, 
c.Nombre Categoria, p.IdPresentacion, pres.Nombre Presentacion
from Producto p inner join Categoria c on p.IdCategoria = c.IdCategoria
inner join Presentacion pres on p.IdPresentacion = pres.IdPresentacion
order by p.IdProducto desc
Go

--Buscar por nombre
Create proc sp_BuscarProductoxNombre
@TextoBuscar varchar(50)
as
Select p.IdProducto, p.Codigo, p.Nombre, p.Descripcion, p.Imagen, p.IdCategoria, 
c.Nombre Categoria, p.IdPresentacion, pres.Nombre Presentacion
from Producto p inner join Categoria c on p.IdCategoria = c.IdCategoria
inner join Presentacion pres on p.IdPresentacion = pres.IdPresentacion
where p.Nombre like @TextoBuscar + '%'
order by p.IdProducto desc
Go

-- Insertar PRODUCTO
Create proc sp_InsertarProducto
@IdProducto int output,
@Codigo varchar(50),
@Nombre varchar(50),
@Descripcion varchar(1000),
@Imagen image,
@IdCategoria int,
@IdPresentacion int
as
insert into Producto(Codigo, Nombre, Descripcion, Imagen, IdCategoria, IdPresentacion)
Values (@Codigo, @Nombre, @Descripcion, @Imagen, @IdCategoria, @IdPresentacion)
Go


-- Editar PRODUCTO
Create proc sp_EditarProducto
@IdProducto int,
@Codigo varchar(50),
@Nombre varchar(50),
@Descripcion varchar(1000),
@Imagen image,
@IdCategoria int,
@IdPresentacion int
as
update Producto set Codigo=@Codigo, Nombre=@Nombre, Descripcion=@Descripcion, 
Imagen=@Imagen, IdCategoria=@IdCategoria, IdPresentacion=@IdPresentacion
where IdProducto = @IdProducto
Go

-- Eliminar PRODUCTO
Create proc sp_EliminarProducto
@IdProducto int
as
delete from Producto
where IdProducto = @IdProducto
Go






-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA PROVEEDOR--------------------------------
-- Mostrar PROVEEDOR
Create proc sp_MostrarProveedor
as
Select top 200 * from Proveedor
order by RazonSocial desc
Go

--Buscar por RazonSocial
Create proc sp_BuscarProveedorxRazonSocial
@TextoBuscar varchar(50)
as
Select * from Proveedor
where RazonSocial like @TextoBuscar + '%'
Go

--Buscar por Numero de Documento
Create proc sp_BuscarProveedorxNumDocumento
@TextoBuscar varchar(11)
as
Select * from Proveedor
where NumDocumento like @TextoBuscar + '%'
Go

-- Insertar PROVEEDOR
Create proc sp_InsertarProveedor
@IdProveedor int output,
@RazonSocial varchar(50),
@SectorComercial varchar(50),
@TipoDocumento varchar(20),
@NumDocumento varchar(11),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50),
@PaginaWeb varchar(100)
as
insert into Proveedor (RazonSocial , SectorComercial, TipoDocumento, NumDocumento, Direccion, Telefono, Email, PaginaWeb)
Values (@RazonSocial, @SectorComercial, @TipoDocumento, @NumDocumento, @Direccion, @Telefono, @Email, @PaginaWeb)
Go

-- Editar PROVEEDOR
Create proc sp_EditarProveedor
@IdProveedor int,
@RazonSocial varchar(50),
@SectorComercial varchar(50),
@TipoDocumento varchar(20),
@NumDocumento varchar(11),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50),
@PaginaWeb varchar(100)
as
update Proveedor set RazonSocial=@RazonSocial, SectorComercial=@SectorComercial, TipoDocumento=@TipoDocumento, NumDocumento=@NumDocumento,
Direccion=@Direccion, Telefono=@Telefono, Email=@Email, PaginaWeb=@PaginaWeb
where IdProveedor = @IdProveedor
Go

-- Eliminar PROVEEDOR
Create proc sp_EliminarProveedor
@IdProveedor int
as
delete from Proveedor
where IdProveedor = @IdProveedor
Go






-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA CLIENTE--------------------------------
-- Mostrar CLIENTE
Create or alter proc sp_MostrarCliente
as
Select top 200 * from Cliente
order by Apellidos desc
Go

--Buscar por Apellido
Create or alter proc sp_BuscarClientexApellidos
@TextoBuscar varchar(50)
as
Select * from Cliente
where Apellidos like @TextoBuscar + '%'
Go

--Buscar por Numero de Documento
Create or alter proc sp_BuscarClientexNumDocumento
@TextoBuscar varchar(11)
as
Select * from Cliente
where NumDocumento like @TextoBuscar + '%'
Go

-- Insertar CLIENTE
Create or alter proc sp_InsertarCliente
@IdCliente int output,
@Nombre varchar(30),
@Apellidos varchar(60),
@Sexo varchar(1),
@FechaNacimiento date,
@TipoDocumento varchar(20),
@NumDocumento varchar(8),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50)
as
insert into Cliente(Nombre , Apellidos, Sexo, FechaNacimiento, TipoDocumento, NumDocumento, Direccion, Telefono, Email)
Values (@Nombre, @Apellidos, @Sexo, @FechaNacimiento, @TipoDocumento, @NumDocumento, @Direccion, @Telefono, @Email)
Go

-- Editar CLIENTE
Create or alter proc sp_EditarCliente
@IdCliente int,
@Nombre varchar(30),
@Apellidos varchar(60),
@Sexo varchar(1),
@FechaNacimiento date,
@TipoDocumento varchar(20),
@NumDocumento varchar(8),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50)
as
update Cliente set Nombre=@Nombre, Apellidos=@Apellidos, Sexo=@Sexo, FechaNacimiento=@FechaNacimiento,
					TipoDocumento=@TipoDocumento, NumDocumento=@NumDocumento, Direccion=@Direccion, 
					Telefono=@Telefono, Email=@Email
where IdCliente = @IdCliente
Go

-- Eliminar CLIENTE
Create or alter proc sp_EliminarCliente
@IdCliente int
as
delete from Cliente
where IdCliente = @IdCliente
Go





-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA EMPLEADO--------------------------------
-- Mostrar EMPLEADO
Create or alter proc sp_MostrarEmpleado
as
Select top 200 * from Empleado
order by Apellidos asc
Go

--Buscar por Apellido
Create or alter proc sp_BuscarEmpleadoxApellidos
@TextoBuscar varchar(50)
as
Select * from Empleado
where Apellidos like @TextoBuscar + '%'
Go

--Buscar por Numero de Documento
Create or alter proc sp_BuscarEmpleadoxNumDocumento
@TextoBuscar varchar(11)
as
Select * from Empleado
where NumDocumento like @TextoBuscar + '%'
Go

-- Insertar EMPLEADO
Create or alter proc sp_InsertarEmpleado
@IdEmpleado int output,
@Nombre varchar(30),
@Apellidos varchar(60),
@Sexo varchar(1),
@FechaNacimiento date,
@NumDocumento varchar(8),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50),
@Acceso varchar(20),
@Usuario varchar(20),
@Contraseña varchar(20)
as
insert into Empleado(Nombre , Apellidos, Sexo, FechaNacimiento, NumDocumento, Direccion, Telefono, Email, Acceso, Usuario, Contraseña)
Values (@Nombre, @Apellidos, @Sexo, @FechaNacimiento, @NumDocumento, @Direccion, @Telefono, @Email, @Acceso, @Usuario, @Contraseña)
Go

-- Editar EMPLEADO
Create or alter proc sp_EditarEmpleado
@IdEmpleado int,
@Nombre varchar(30),
@Apellidos varchar(60),
@Sexo varchar(1),
@FechaNacimiento date,
@NumDocumento varchar(8),
@Direccion varchar(100),
@Telefono varchar(9),
@Email varchar(50),
@Acceso varchar(20),
@Usuario varchar(20),
@Contraseña varchar(20)
as
update Empleado set Nombre=@Nombre, Apellidos=@Apellidos, Sexo=@Sexo, FechaNacimiento=@FechaNacimiento, NumDocumento=@NumDocumento, 
					Direccion=@Direccion, Telefono=@Telefono, Email=@Email, Acceso=@Acceso, Usuario=@Usuario, Contraseña=@Contraseña
where IdEmpleado = @IdEmpleado
Go


-- Eliminar EMPLEADO
Create or alter proc sp_EliminarEmpleado
@IdEmpleado int
as
delete from Empleado
where IdEmpleado = @IdEmpleado
Go





-------------------------------- PROCEDIMIENTOS ALMACENADOS DE ACCESO--------------------------------
Create or alter proc sp_Login
@Usuario varchar(20),
@Contraseña varchar(20)
as
Select IdEmpleado, Apellidos, Nombre, Acceso from Empleado
where Usuario=@Usuario and Contraseña=@Contraseña
Go





-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA INGRESO--------------------------------
-- Mostrar INGRESO
Create or alter proc sp_MostrarIngreso
as
Select top 100 i.IdIngreso, e.Apellidos + e.Nombre as Empleado, p.RazonSocial as Proveedor, i.Fecha, i.TipoComprobante, i.Serie, i.Correlativo, i.Estado,
		SUM(d.PrecioCompra * d.StockInicial) as Total
from Ingreso i inner join Empleado e on i.IdEmpleado = e.IdEmpleado 
inner join Proveedor p on i.IdProveedor = p.IdProveedor
inner join DetalleIngreso d on i.IdIngreso = d.IdIngreso
Group by 
i.IdIngreso, e.Apellidos + e.Nombre , p.RazonSocial, i.Fecha, i.TipoComprobante, i.Serie, i.Correlativo, i.Estado
Order by i.IdIngreso desc
Go


--Mostrar Ingresos entre fechas.
Create or alter proc sp_BuscarIngresoxFecha
@FechaInicial varchar(20),
@FechaFinal varchar(20)
as
Select i.IdIngreso, e.Apellidos + e.Nombre as Empleado, p.RazonSocial as Proveedor, i.Fecha, i.TipoComprobante, i.Serie, i.Correlativo, i.Estado,
		SUM(d.PrecioCompra * d.StockInicial) as Total
from Ingreso i inner join Empleado e on i.IdEmpleado = e.IdEmpleado 
inner join Proveedor p on i.IdProveedor = p.IdProveedor
inner join DetalleIngreso d on i.IdIngreso = d.IdIngreso
Group by 
i.IdIngreso, e.Apellidos + e.Nombre , p.RazonSocial, i.Fecha, i.TipoComprobante, i.Serie, i.Correlativo, i.Estado
having i.Fecha>=@FechaInicial and i.Fecha<=@FechaFinal
Go


-- Insertar INGRESO
Create or alter proc sp_InsertarIngreso
@IdIngreso int=null output,
@Fecha date,
@TipoComprabante varchar(20),
@Serie varchar(4),
@Correlativo varchar(7),
@Igv decimal(4,2),
@IdEmpleado int,
@IdProveedor int,
@Estado varchar(7)
as
insert into Ingreso(Fecha, TipoComprobante, Serie, Correlativo, Igv, IdEmpleado, IdProveedor, Estado)
Values (@Fecha, @TipoComprabante, @Serie, @Correlativo, @Igv, @IdEmpleado, @IdProveedor, @Estado)
-- Obtner el codigo autogenerado
Set @IdIngreso=@@IDENTITY
Go





-- Anular INGRESO
Create or alter proc sp_AnularIngreso
@IdIngreso int
as
update Ingreso set Estado='Anulado'
where IdIngreso = @IdIngreso
Go


--Insertar DETALLES DE INGRESO
Create or alter proc sp_InsertarDetalleIngreso
@IdDetalleIngreso int output,
@PrecioCompra money,
@PrecioVenta money,
@StockInicial int,
@StockActual int,
@FechaProduccion date,
@FechaVencimiento date,
@IdIngreso int,
@IdProducto int
as
insert into DetalleIngreso(IdIngreso, PrecioCompra, PrecioVenta, StockInicial, StockActual, FechaProduccion, FechaVencimiento, IdProducto)
values (@IdIngreso, @PrecioCompra, @PrecioVenta, @StockInicial, @StockActual, @FechaProduccion, @FechaVencimiento, @IdProducto)
Go


-- Mostrar DETALLE INGRESO
Create or alter proc sp_MostrarDetalleIngreso
@TextoBuscar int
as
Select d.IdProducto, p.Nombre as Producto, d.PrecioCompra, d.PrecioVenta, d.StockInicial, d.FechaProduccion, d.FechaVencimiento,
(d.StockInicial*d.PrecioCompra) as Subtotal
from DetalleIngreso d inner join Producto p on d.IdProducto = p.IdProducto
where d.IdIngreso=@TextoBuscar
Go


-------------------------------- PROCEDIMIENTOS ALMACENADOS DE LA TABLA VENTAS--------------------------------
--Mostrar Ventas
Create or alter proc sp_MostrarVenta
as
Select top 100 v.IdVenta,
(e.Apellidos+' '+e.Nombre) as Empleado,
(c.Apellidos+' '+c.Nombre) as Cliente,
v.Fecha, v.TipoComprobante, v.Serie, v.Correlativo,
sum((d.Cantidad*d.PrecioVenta)-d.Descuento) as Total
from DetalleVenta d inner join Venta v on d.IdVenta = v.IdVenta
inner join Empleado e on v.IdEmpleado = e.IdEmpleado
inner join Cliente c on v.IdCliente = c.IdCliente
group by v.IdVenta,
(e.Apellidos+' '+e.Nombre),
(c.Apellidos+' '+c.Nombre),
v.Fecha, v.TipoComprobante, v.Serie, v.Correlativo
order by v.IdVenta desc
Go


-- Buscar ventas oir fechas
Create or alter proc sp_BuscarVentaxFecha
@FechaInicial varchar(50),
@FechaFinal varchar(50)
as
Select v.IdVenta,
(e.Apellidos+' '+e.Nombre) as Empleado,
(c.Apellidos+' '+c.Nombre) as Cliente,
v.Fecha, v.TipoComprobante, v.Serie, v.Correlativo,
sum((d.Cantidad*d.PrecioVenta)-d.Descuento) as Total
from DetalleVenta d inner join Venta v on d.IdVenta = v.IdVenta
inner join Empleado e on v.IdEmpleado = e.IdEmpleado
inner join Cliente c on v.IdCliente = c.IdCliente
group by v.IdVenta,
(e.Apellidos+' '+e.Nombre),
(c.Apellidos+' '+c.Nombre),
v.Fecha, v.TipoComprobante, v.Serie, v.Correlativo
having v.Fecha >= @FechaInicial and v.Fecha <=@FechaFinal
Go


-- Insertar VENTA
Create or alter proc sp_InsertarVenta
@IdVenta int = null output,
@IdCliente int,
@IdEmpleado int,
@Fecha date,
@TipoComprobante varchar(20),
@Serie varchar(4),
@Correlativo varchar(7),
@Igv decimal(4,2)
as
insert into Venta (IdCliente, IdEmpleado, Fecha, TipoComprobante, Serie, Correlativo, Igv)
values (@IdCliente, @IdEmpleado, @Fecha, @TipoComprobante, @Serie, @Correlativo, @Igv)
--Codigo autogenerado
set @IdVenta = @@IDENTITY
Go


--Eliminar VENTA
Create or alter proc sp_EliminarVenta
@IdVenta int
as
delete from Venta
where IdVenta = @IdVenta
Go


---Insertar detalle de venta
Create or alter proc sp_InsertarDetalleVenta
@IdDetalleVenta int output,
@IdVenta int,
@IdDetalleIngreso int,
@Cantidad int,
@PrecioVenta money,
@Descuento money
as
insert into DetalleVenta (IdVenta, IdDetalleIngreso, Cantidad, PrecioVenta, Descuento)
values (@IdVenta, @IdDetalleIngreso, @Cantidad, @PrecioVenta, @Descuento)
Go


--Restablecer el stock despues de eliminar una venta y sus detalles
Create or alter trigger tr_RestablecerStock
on	[DetalleVenta]
for delete
as
update di set di.StockActual=di.StockActual+dv.Cantidad
from DetalleIngreso as di inner join deleted as dv on di.IdDetalleIngreso=dv.IdDetalleIngreso
Go


-- Dismunir el sotck despues de una venta
Create or alter proc sp_DisminuirStock
@IdDetalleIngreso int,
@Cantidad int
as
update DetalleIngreso set StockActual = StockActual-@Cantidad
where IdDetalleIngreso = @IdDetalleIngreso 
Go


--Mostrar detalles de una venta
Create or alter proc sp_MostrarDetalleVenta
@TextoBuscar int
as
Select d.IdDetalleIngreso, p.Nombre as Producto, d.Cantidad, d.PrecioVenta, d.Descuento,
((d.PrecioVenta*d.Cantidad)-d.Descuento) as Subtotal
from DetalleVenta d inner join DetalleIngreso di on d.IdDetalleIngreso = di.IdDetalleIngreso
inner join Producto p on di.IdProducto=p.IdProducto
where d.IdVenta = @TextoBuscar
Go


--Mostrar los Productos para la venta
Create or alter proc sp_BuscarProductoVentaNombre
@TextoBuscar varchar(50)
as
Select d.IdDetalleIngreso, p.Codigo, p.Nombre, c.Nombre as Categoria, pre.Nombre as Presentacion,
d.StockActual, d.PrecioCompra, d.PrecioVenta, d.FechaVencimiento
from Producto p inner join Categoria c on p.IdCategoria = c.IdCategoria
inner join Presentacion pre on p.IdPresentacion = pre.IdPresentacion
inner join DetalleIngreso d on p.IdProducto = d.IdProducto
inner join Ingreso i on d.IdIngreso = i.IdIngreso
where p.Nombre like @TextoBuscar +'%'
and d.StockActual > 0
and i.Estado <> 'ANULADO'
Go


--Mostrar los Productos para la venta
Create or alter proc sp_BuscarProductoVentaCodigo
@TextoBuscar varchar(50)
as
Select d.IdDetalleIngreso, p.Codigo, p.Nombre, c.Nombre as Categoria, pre.Nombre as Presentacion,
d.StockActual, d.PrecioCompra, d.PrecioVenta, d.FechaVencimiento
from Producto p inner join Categoria c on p.IdCategoria = c.IdCategoria
inner join Presentacion pre on p.IdPresentacion = pre.IdPresentacion
inner join DetalleIngreso d on p.IdProducto = d.IdProducto
inner join Ingreso i on d.IdIngreso = i.IdIngreso
where p.Codigo = @TextoBuscar
and d.StockActual > 0
and i.Estado <> 'ANULADO'
Go



----------------------------- PROCEDIMIENTO ALMACENADO - REPORTES -----------------------------

Create or alter proc sp_ReporteFactura
@IdVenta int
as
Select v.IdVenta, (e.Apellidos+' '+e.Nombre) as Empleado, (c.Apellidos+' '+c.Nombre) as Cliente, c.Direccion, c.Telefono, c.NumDocumento,
v.Fecha, v.TipoComprobante, v.Serie, v.Correlativo, v.Igv,
p.Nombre, dv.PrecioVenta, dv.Cantidad, dv.Descuento,
(dv.Cantidad * dv.PrecioVenta - dv.Descuento) as TotalParcial
from DetalleVenta dv inner join DetalleIngreso di on dv.IdDetalleIngreso = di.IdDetalleIngreso
inner join Producto p on p.IdProducto = di.IdProducto
inner join Venta v on v.IdVenta = dv.IdVenta
inner join Cliente c on c.IdCliente = v.IdCliente
inner join Empleado e on e.IdEmpleado = v.IdEmpleado
where v.IdVenta = @IdVenta
Go



----------------------------- VISTA - CONSULTAS -----------------------------
Create or alter proc sp_StockProductos
As
Select p.Codigo, p.Nombre, c.Nombre as Categoria, Sum(di.StockInicial) as CantidadIngreso, Sum(di.StockActual) as CantidadStock,
(Sum(di.StockInicial) - Sum(di.StockActual) ) as CantidadVenta
from producto p inner join categoria c on p.idcategoria = c.idcategoria
inner join detalleingreso di on p.idproducto = di.IdProducto 
inner join Ingreso i on i.IdIngreso = di.IdIngreso
Where i.Estado <> 'ANULADO'
Group by p.Codigo, p.Nombre, c.Nombre




Select * from Categoria
Select * from Presentacion
Select * from Producto
Select * from Cliente
Select * from empleado
Select * from Ingreso



