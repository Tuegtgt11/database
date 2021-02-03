use AdventureWorks2019
go
--tạo ra một thủ tục lưu trữ lấy ra toàn bộ nhân viên vào làm theo năm có tham số đầu vào là một năm
create procedure sp_DispalyEmployeesHireYear
	@HireYear int
as
select *from HumanResources.Employee
where DATEPART (YY,HireDate)=@HireYear
go
--để chạy thủ tục này cần phải truyền tham số vào là năm mầ nhân viên vào làm
Execute sp_DispalyEmployeesHireYear 2003
go
--tạo thủ tục lưu trữ đếm số người vào làm trong một năm xác định có tham số đầu vào là 1 năm,
--tham số đầu ra là số người vào làm trong năm này
create procedure sp_EmployeesHireYearCount
	@HireYear int,
	@Count int OUTPUT
as
select @Count=Count(*) from HumanResources.Employee
where DATEPART(YY, HireDate)=@HireYear
go
--chạy thủ tục lưu trữ cần phải truyền vào môt tham số đầu vào và một tham số đầu ra,
Declare @Number  int
Execute sp_EmployeesHireYearCount 2003, @Number output
print @Number
go

--tạo thủ tục lưu trữ đếm sô người vào làm trong một năm xác định có tham sô đầu vào một năm, hàm trả về sô người vào lầm năm đó
create procedure sp_EmployeesHireYearCount2
	@HireYear int
as
declare @Count int
select @Count=count(*) from HumanResources.Employee
where DATEPART(YY,HireDate)=@HireYear
return @Count
go

--chạy thủ tục lưu trữ cần pahri truyền vào 1 tham số đầu vào và lấy ra một sô người lầm trong nâm đó.
declare @Number int
execute @Number = sp_EmployeesHireYearCount2 2003
print @Number
go

--tạo bảng tạm #Students
create table #Students
(
	RollNo varchar(6) Constraint PK_Students Primary key,
	FullName nvarchar(100),
	Birthday datetime constraint DF_StudentsBirthday default DATEADD(yy,-18,Getdate())
)
go

--tạo thủ tục lưu tạm để chèn dữu liệu vào bảng tạm
create procedure #spInsertStudents
	@rollNo varchar(6),
	@fullName nvarchar(100),
	@birthday datetime
as begin
	IF(@birthday is null)
		set @birthday=DATEADD(yy, -18,getdate())
	insert into #Students(RollNo,FullName,Birthday)
		values (@rollNo,@fullName,@birthday)
end
go

--sử dụng thủ tục lưu trữ để chèn dữ liệu vào bảng tạm
EXEC #spStudents 'A12345', 'abc', NULL
EXEC #spStudents 'A54321', 'abc', '12/24/2011'
SELECT * FROM #Students

--Tạo thủ tục lưu trữ tạm để xóa dữ liệu từ bảng tạm theo RollNo
CREATE PROCEDURE #spDeleteStudents
@rollNo varchar(6)
AS BEGIN
DELETE FROM #Students WHERE RollNo=@rollNo
END
--Xóa dữ liệu sử dụng thủ tục lưu trữ
EXECUTE #spDeleteStudents 'A12345'
GO

--Tạo một thủ tục lưu trữ sử dung lệnh RETURN để trả về một số nguyên
CREATE PROCEDURE Cal_Square @num int=0 AS
BEGIN
RETURN (@num * @num);
END
GO
--Chạy thủ tục lưu trữ
DECLARE @square int;
EXEC @square = Cal_Square 10;
PRINT @square;
GO

--Xem định nghĩa thủ tục lưu trữ bằng hàm OBJECT_DEFINITION
SELECT
OBJECT_DEFINITION(OBJECT_ID('HumanResources.uspUpdateEmployeePersonalI
nfo')) AS DEFINITION

--Xem định nghĩa thủ tục lưu trữ bằng
SELECT definition FROM sys.sql_modules
WHERE
object_id=OBJECT_ID('HumanResources.uspUpdateEmployeePersonalInfo')
GO

--Thủ tục lưu trữ hệ thống xem các thành phần mà thủ tục lưu trữ phụ
thuộc
sp_depends 'HumanResources.uspUpdateEmployeePersonalInfo'
GO

USE AdventureWorks
GO
--Tạo thủ tục lưu trữ sp_DisplayEmployees
CREATE PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
GO

--Thay đổi thủ tục lưu trữ sp_DisplayEmployees
ALTER PROCEDURE sp_DisplayEmployees AS
SELECT * FROM HumanResources.Employee
WHERE Gender='F'
GO
--Chạy thủ tục lưu trữ sp_DisplayEmployees
EXEC sp_DisplayEmployees
GO

--Xóa một thủ tục lưu trữ
DROP PROCEDURE sp_DisplayEmployees
GO

--
CREATE PROCEDURE sp_EmployeeHire
AS
BEGIN
--Hiển thị
EXECUTE sp_DisplayEmployeesHireYear 1999
DECLARE @Number int
EXECUTE sp_EmployeesHireYearCount 1999, @Number OUTPUT
PRINT N'Số nhân viên vào làm năm 1999 là: ' +
CONVERT(varchar(3),@Number)
END
GO
--Chạy thủ tục lưu trữ
EXEC sp_EmployeeHire
GO

--Thay đổi thủ tục lưu trữ sp_EmployeeHire có khối TRY ... CATCH
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
BEGIN TRY
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ

truyền 2 tham số mà ta truyền 3

EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT,

'123'

PRINT N'Số nhân viên vào làm năm là: ' +

CONVERT(varchar(3),@Number)
END TRY
BEGIN CATCH
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
END CATCH
PRINT N'Kết thúc thủ tục lưu trữ'
END
GO
--Chạy thủ tục sp_EmployeeHire
EXEC sp_EmployeeHire 1999
--Xem thông báo lỗi bên Messages không phải bên Result
GO

--Thay đổi thủ tục lưu trữ sp_EmployeeHire sử dụng hàm @@ERROR
ALTER PROCEDURE sp_EmployeeHire
@HireYear int
AS
BEGIN
EXECUTE sp_DisplayEmployeesHireYear @HireYear
DECLARE @Number int
--Lỗi xảy ra ở đây có thủ tục sp_EmployeesHireYearCount chỉ truyền 2 tham số mà ta truyền 3
EXECUTE sp_EmployeesHireYearCount @HireYear, @Number OUTPUT,
'123'
IF @@ERROR <> 0
PRINT N'Có lỗi xảy ra trong khi thực hiện thủ tục lưu trữ'
PRINT N'Số nhân viên vào làm năm là: ' +
CONVERT(varchar(3),@Number)
END
GO
--Chạy thủ tục sp_EmployeeHire
EXEC sp_EmployeeHire 1999
--Xem thông báo lỗi bên Messages không phải bên Result