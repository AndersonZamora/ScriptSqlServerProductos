USE MASTER
GO

CREATE DATABASE POSPRODUCTOSAND
GO

--Creacion de Tablas

CREATE  TABLE Usuario
(
    [Id_Usu] [int] IDENTITY(1,1)  NOT NULL,	
	[Name] [nvarchar] (50) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[Email][varchar] (50)NOT NULL,
	primary key (Id_Usu)
) 
GO

CREATE TABLE Producto (
	[Id_Pro] [int] IDENTITY(1,1) NOT NULL,	
	[Id_Usu] int NOT NULL,
	[Usuario] [nvarchar] (50),
	[Nombre] [nvarchar] (50) NOT NULL,
	[Precio] real NOT NULL,
	[Stock] real NOT NULL,
	[Proveedor] [nvarchar] (50) NOT NULL,
	[Estado] [nvarchar] (10) NOT NULL,
	primary key (Id_Pro)
	)
GO

-- Realciones del producto
ALTER TABLE [dbo].[Producto] ADD 
	CONSTRAINT [FK_provd] FOREIGN KEY 
	(
		[Id_Usu]
	) REFERENCES [dbo].[Usuario] (
		[Id_Usu]
	)
GO

-- Agregar Usuario
create proc Sp_Add_Usuario
(
@name nvarchar (50),
@password nvarchar (100),
@email nvarchar (50)
)
As
insert into Usuario
values
(
@name,
@password,
@email
)
select @@IDENTITY;
Go

-- Agregar Producto
create proc Sp_Add_Producto
(
@idUsu int,
@usuario nvarchar (50),
@nombre nvarchar (50),
@precio real,
@stock real,
@proveedor nvarchar (50),
@estado nvarchar (10)
)
As
insert into Producto
values
(
@idUsu,
@usuario,
@nombre,
@precio,
@stock,
@proveedor,
@estado
)
select @@IDENTITY;
Go

--update:
create procedure Sp_Editar_Producto (
@idPro int,
@idUsu int,
@usuario nvarchar (50),
@nombre nvarchar (50),
@precio real,
@stock real,
@proveedor nvarchar (50),
@estado nvarchar (10)
)
As
Update Producto set
Id_Usu=@idUsu,
Usuario=@usuario,
Nombre=@nombre,
Precio=@precio,
Stock=@stock ,
Proveedor=@proveedor,
Estado=@estado
where
Id_Pro=@idPro
go

--Unimos Las Tablas en Vistas:
Create view v_Productos_yDependientes
As
select 
p.Id_Pro, p.Nombre , p.Precio , p.Proveedor , p.Stock,p.Estado , p.Usuario,
x.Id_Usu , x.Name
from Producto p, Usuario x
where
p.Id_Usu =x.Id_Usu
go

--Todos los productos:
create procedure Sp_Listar_Todos_Productos
As
select * from v_Productos_yDependientes
where
Estado ='Activo'
order by Nombre Asc
go

--Todos los productos:
create procedure Sp_Listar_Todos_Productos_Usuario
@idUsu int
As
select * from v_Productos_yDependientes
where
Id_Usu = @idUsu AND
Estado ='Activo'
order by Nombre Asc
go

--Sp_Buscar_ProductO
--Sp_Buscar_Producto
exec Sp_Listar_Todos_Productos_Usuario 1
go

create Procedure Sp_Buscar_Producto(
@Id_Pro int
)
As
Select * from Producto
Where
Estado= 'Activo' and
Id_Pro=@Id_Pro



--eliminar
create procedure Sp_Eliminar_Producto(
@idpro int
)
As
Delete from Producto
where
Id_Pro =@idpro
go

-- Login
create View v_Usuarios
As
Select Id_Usu,u.Email , u.Name ,u.Password 
From Usuario U
Go

create Procedure Sp_Usuario_Login(
	@Email nvarchar(50)
)
As
	Select * from v_Usuarios
	Where
	Email=@Email
Go

create procedure Sp_Validar_Correo (
@email nvarchar (20)
)
as
select COUNT(*) from Usuario 
where
Email =@email
go