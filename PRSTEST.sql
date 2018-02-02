use master
	go
drop database if exists PRSTEST
	go
Create database PRSTEST
	go
use PRSTEST
	go

drop table if exists PurchaseRequestLineItem
drop table if exists PurchaseRequest
drop table if exists Product
drop table if exists Vendor
drop table if exists [User]
	go

Create table [User] (
Id int primary key identity(1,1),
UserName nvarchar(30) not null unique(UserName),
[Password] nvarchar(30) not null,
FirstName nvarchar (30) not null,
LastName nvarchar (30) not null,
Phone nvarchar(12),
Email nvarchar(80),
IsReviewer bit not null default 0,
IsAdmin bit not null default 0,
Active bit not null default 1
)
go

Insert into [User] (UserName, [Password], FirstName, LastName, Phone, Email) 
	values ('jSmith', '123abc', 'John', 'Smith', '513-555-7744', 'jSmith@gmail.com')
go

Create table Vendor (
Id int primary key identity(1,1),
Code nvarchar(10) not null unique(Code),
[Name] nvarchar(30) not null,
[Address] nvarchar(30) not null,
City nvarchar(30) not null,
[State] nvarchar(2) not null check([State] = 'OH' or [State] = 'KY' or [State] = 'IN'),
Zip nvarchar(10) not null,
Phone nvarchar(12),
Email nvarchar(80),
IsRecommended bit not null default 0,
Active bit not null default 1
)
	go

Insert into Vendor (Code, [Name], [Address], City, [State], Zip, Phone, Email) 
	values ('1234', 'WeSellThings', '1 Main Street', 'Cincinnati', 'OH', '45281', '513-123-4567', 'Sales@WeSellThings.com')
go

Create table Product (
Id int primary key identity(1,1),
[Name] nvarchar(130) not null,
VendorPartNumber nvarchar(50) not null,
Price decimal(20,2) not null, 
Unit nvarchar(10) not null,
PhotoPath nvarchar(255),
VendorId int not null foreign key references Vendor(Id),
Active bit not null default 1
)
	go

Insert into Product ([Name], VendorPartNumber, Price, Unit, VendorId) 
	values ('Really Good Thing', 'AM489IZ', '500.00', 'Each', '1')
go

Create table PurchaseRequest (
Id int primary key identity(1,1),
[Description] nvarchar(80) not null,
Justification nvarchar(255),
DateNeeded datetime not null default dateadd(dd, 7, getdate()),
DeliveryMode nvarchar(25),
[Status] nvarchar(10) not null default 'NEW',
Total decimal(20,2) not null default '0.0',
UserId int not null foreign key references [User](Id), --Default logged in user
Active bit not null default 1
)
	go

Insert into PurchaseRequest ([Description], Justification, DeliveryMode, Total, UserId)
	values ('This thing is REALLY nice', 'I want it', 'USPS', '1', '1')
go

Create Table PurchaseRequestLineItem (
Id int primary key identity(1,1),
PurchaseRequestId int not null foreign key references PurchaseRequest(Id),
ProductId int not null foreign key references Product(Id),
Quantity int not null default 1,
Active bit not null default 1
)
	go

Insert into PurchaseRequestLineItem (PurchaseRequestId, ProductId, Quantity) 
	values ('1', '1', '1')
go
