open symmetric key MyKey
decryption by certificate mySert
go
update TUsers
	set 
	LName = ENCRYPTBYKEY(Key_GUID('myKey'), 'Name'),
	Fname = ENCRYPTBYKEY(Key_GUID('myKey'), 'FName'),
	TUser = '223'
	where ID = 3 or ID = 4;
go