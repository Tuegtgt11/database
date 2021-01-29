Use AdventureWorks2019
go

CREATE DATABASE Lab11
GO
USE Lab11
go

CREATE VIEW ProductList AS
SELECT ProductID, Name FROM AdventureWorks2019.Production.Product
go

SELECT * FROM ProductList