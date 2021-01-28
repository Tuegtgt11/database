create database lab10
go

use AdventureWorks2019
go

select* into lab10.dbo.WorkOrder from Production.WorkOrder
go

use lab10
go

select*into WorkOrderIX from WorkOrder 
go

select* from WorkOrder
go

select *from WorkOrderIX
go

create index IX_WorkOrderID on WorkOrderIX(WorkOrderID)
go

select * from WorkOrder where WorkOrderID=72000
go

select *from WorkOrderIX where WorkOrderID=72000
go