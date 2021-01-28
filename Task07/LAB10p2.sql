create database CodeLean

use AdventureWorks2019 

create table Classes(
	ClassName char(6) primary key,
	Teacher varchar(30),
	TimeSlot varchar(30),
	Class int,
	Lab int,
)
go

create unique index MyClusteredIndex on Classes(ClassName)
go
create nonclustered index TeacherIndex on Classes(Teacher)
go

drop index teacherIndex go

alter index MyClusteredIndex on Classes rebuild with(FILLFACTOR=60)
go

create  index ClassLabIndex on Classes(Class, Lab)
go

select * from CodeLean.dbo.Classes
go