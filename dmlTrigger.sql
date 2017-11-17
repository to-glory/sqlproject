create trigger auditTrigger on TUsers
after update, insert, delete

as 

declare @ID int, 
@columnsCount int,
@user varchar(20),
@activity varchar(20),
@result varchar(500);

if exists(select * from inserted) and exists (select * from deleted)
	begin
		set @activity = 'UPDATE';
		set @user = CURRENT_USER;
		select @columnsCount = COUNT(*) from inserted;
		set @result = '<' + convert(varchar, GETDATE()) + '> <' + @activity
		+ '> <' + @user + '> <' + convert(varchar, @columnsCount) + '>'; 
		insert into TUserLogInfo(TUsersLogInfo) values (@result)
	end
	
if exists(select * from inserted) and not exists ( select * from deleted)
	begin
		set @activity = 'INSERT';
		set @user = CURRENT_USER;
		select @columnsCount = COUNT(*) from inserted;
		set @result = '<' + convert(varchar, GETDATE()) + '> <' + @activity
		+ '> <' + @user + '> <' + convert(varchar, @columnsCount) + '>'; 
		insert into TUserLogInfo(TUsersLogInfo) values (@result)
	end

if exists(select * from deleted) and not exists ( select * from inserted)
	begin
		set @activity = 'DELETE';
		set @user = CURRENT_USER;
		select @columnsCount = COUNT(*) from deleted;
		set @result = '<' + convert(varchar, GETDATE()) + '> <' + @activity
		+ '> <' + @user + '> <' + convert(varchar, @columnsCount) + '>'; 
		insert into TUserLogInfo(TUsersLogInfo) values (@result)
	end
go