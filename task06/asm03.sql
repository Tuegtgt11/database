create database thongtin
go
use thongtin
go

create table giaydangki(
tenkhachhang varchar(900),
socmt int primary key,
diachi nvarchar(900),
sothuebao nvarchar(900),
loaithuebao nvarchar(900),
ngaydangki datetime,
)
go
INSERT INTO giaydangki VALUES('Mai Van Tue',123456789,'nam dinh',123456789,'tra truoc',12/12/02);
INSERT INTO giaydangki VALUES('Vu Duc Tue',134456456,'nam dinh',123454467,'tra sau',20/08/02);
INSERT INTO giaydangki VALUES('pham minh',135456456,'thai binh',123456789,'tra sau',21/01/02);
INSERT INTO giaydangki VALUES('mai thi thuy linh',130446456,'nam dinh',123454467,'tra sau',29/08/02);
INSERT INTO giaydangki VALUES('do thi my hanh',194456456,'hai duong',123456789,'tra sau',29/01/02);
go

select*from giaydangki
go