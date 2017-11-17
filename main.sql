use myDataBase
go

create table TUser(
id integer not null primary key,
TUserName char(32) not null,
Lname varbinary(256) not null,
Fname varbinary(256) not null,
Phone varbinary(256),
Addres varbinary(256),
Tpassword varbinary(8000)
)

create master key encryption by password = '12345Hello!'

create certificate mySert
with subject = 'subj'

create symmetric key myKey with
identity_value = 'key',
algorithm = AES_256,
key_source = 'key'
encryption by certificate mySert

go
create procedure AddUser(
 @id integer,
 @Tuser varchar(32),
 @Lname varchar(32),
 @Fname varchar(32),
 @Phone varchar(15),
 @Address varchar(32),
 @Tpassword varchar(32)
)
as
begin
declare @EncLname varbinary(256)
declare @EncFname varbinary(256)
declare @EncPhone varbinary(256)
declare @EncAddress varbinary(256)
declare @PassHash varbinary(8000)

open symmetric key myKey
decryption by certificate mySert

set @EncLname = ENCRYPTBYKEY(Key_GUID('myKey'), @Lname)
set @EncFname = ENCRYPTBYKEY(Key_GUID('myKey'), @Fname)
set @EncPhone = ENCRYPTBYKEY(Key_GUID('myKey'), @Phone)
set @EncAddress = ENCRYPTBYKEY(Key_GUID('myKey'), @Address)
set @PassHash = HASHBYTES('MD5', @Tpassword);

insert into TUser (id, TUserName, Lname, Fname, Phone, Addres, Tpassword)
values (@id, @Tuser, @EncLname, @EncFname, @EncPhone, @EncAddress, @PassHash)
end
go

exec AddUser
@id = 1,
@Tuser = 'user1',
@Lname = 'lname1',
@Fname = 'fname1',
@Phone = 'phone1',
@Address = 'address1',
@Tpassword = 'password1';
go

go
create procedure isPasswordCorrect(
 @Tuser varchar(32),
 @Tpassword varchar(32)
)
as
begin
declare @Result varchar(32)
declare @PassHash varbinary(8000)

set @PassHash = HASHBYTES('MD5', @Tpassword);
set @Result = (select Tpassword from TUser where TUserName = @Tuser )

if @PassHash = @Result
begin
print 'Password is correct'
return 1
end
else
begin
print 'Password is wrong'
return 0
end

end
go

exec isPasswordCorrect
 @Tuser = 'user1',
 @Tpassword = 'password1'
 go

 exec isPasswordCorrect
 @Tuser = 'user1',
 @Tpassword = 'password12'
 go

 go
create procedure updatePassword(
 @Tuser varchar(32),
 @Tpassword varchar(32)
)
as
begin
declare @PassHash varbinary(8000)

set @PassHash = HASHBYTES('MD5', @Tpassword);
update TUser
set Tpassword = @PassHash
where TUserName = @TUser

print 'Password successfully updated'

end
go

exec updatePassword
 @Tuser = 'user1',
 @Tpassword = 'password12'
 go