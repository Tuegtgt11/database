use AdventureWorks2019
go

--tạo khung nhìn lấy ra thông tin cơ bản trong bảng Person.Contact
create view V_Contact_Info As
select FirstName, MiddleName, LastName
from Person.Person
go

--tạo khung nhìn lấy ra thông tin về nhân viên
create view V_Employee_Contact As
select p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
from HumanResources.Employee e
Join Person.Person As p on e.BusinessEntityID = p.BusinessEntityID;
go

--xem một khung nhìn
select *from V_Employee_Contact
go

--thay đổi khung nhìn V_Employee-Contact bằng việc thêm cột Birthdate
Alter View V_Employee_Contact AS
Select p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate, Birthdate
from HumanResources.Employee e
join Person.Person as p on e.BusinessEntityID = p.BusinessEntityID
where p.FirstName like '%B%';
go

--xóa một khung nhìn
drop view V_Contact_Info
go

--xem định nghĩa khung nhìn V_Employee_Contact
Execute sp_helptext 'V_Employee_Contact'

--xem các thành phần mà khung nhìn phụ thuộc
execute sp_depends 'V_Employee_Contact'

--tạo khung nhìn ẩn mà định nghĩa bị ẩn đi(không xem được định nghĩa khung nhìn)
create view OrderRejects
with ENCRYPION
 AS
select PurchaseOrderID, ReceivedQty, RejectedQty,
	RejectedQty / ReceivedQty as RejectRatio, DueDate
from Purchasing.PurchaseOrderDetail
where ReceivedQty / ReceivedQty >0
and DueDate > Convert (datetime,'20010630',010);

--không xem được định nghĩa khung nhìn V_Contact_Info
execute sp_helptext 'OrderRejects'
go

--thay đổi khung hình nhìn thêm tùy chonj CHECK OPTION
alter view V_Employee_Contact As
select p.FirstName, p.LastName, e.BusinessEntityID, e.HireDate
from HumanResources.Employee e
join Person.Person as p on e.BusinessEntityID = p.BusinessEntityID
where p.FirstName like 'A%'
with check option
go

select * from V_Employee_Contact
-- cập nhật được khug hình khi FirstName bắt đầu bằng ký tự 'A'
Update V_Employee_Contact set FirstName= 'Atest' where LastName='Amy'
--không cập nhật được khung nhìn khi FirstName bắt đầu bằng ký tự khác 'A'
update V_Employee_Contact set FirstName='BCD' where LastName='Atest'
go

--phải xóa khung nhìn trước
drop view V_Employee_Contact
go

--tạo khung nhìn có giản đồ
create view V_Contact_Info with SCHEMABINDING AS
select FirstName, MiddleName, LastName, EmailAddress
from Person.Contact
go
--không thể truy vấn trên cột EmailAddress trên khung nhìn V_Contact_Info
select*from V_Contact_Info
go

--tạo chỉ mục duy nhất trên cột EmailAddress trên khung nhìn V_contact_Info
create unique clustered index IX_Contact_Email
on V_Contact_Info(EmailAddress)
go

--thực hiện đổi tên khung nhìn
exec sp_rename V_Contact_Info,V_Contact_Infomation

--truy vấn khung nhìn
select * from V_Contact_Infomation

--không thể thêm bản ghi vào khung nhìn
--vì có cột không cho phép NULL trong bảng Contact
insert into V_Contact_Infomation values ('ABC','DEF','GHI','abc@yahoo.com')
--Không thể xóa bản ghi của khung nhìn V_Contact_Infomation
--vì bảng Person.Contact còn có các khóa ngoại
delete from V_Contact_Infomation where LastName='Gilbert' and FirstName='Guy'
