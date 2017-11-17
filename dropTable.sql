Use DataBase1
go
create trigger noDropTable
on DATABASE
for DROP_TABLE
as
print N'You cannot delete this table';
rollback
go