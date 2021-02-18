//%attributes = {"invisible":true}
TRUNCATE TABLE:C1051([User:3])
SET DATABASE PARAMETER:C642([User:3]; Table sequence number:K37:31; 0)

$user:=ds:C1482.User.new()
$user.name:="user"
$user.password:=Generate digest:C1147("pass"; 4D digest:K66:3)
$user.save()
