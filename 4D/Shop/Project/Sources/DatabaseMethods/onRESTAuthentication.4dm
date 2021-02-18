C_TEXT:C284($1; $username; $2; $password; $4; $ipAddress)
C_BOOLEAN:C305($0; $accept; $3; $isDigest)

$username:=$1
$password:=$2
$isDigest:=$3

$user:=ds:C1482.User.query("name === :1"; $username).first()

If ($user#Null:C1517)
	$accept:=($password=$user.password)
Else 
	$accept:=Validate password:C638($username; $password; $isDigest)  //4D User
End if 

$0:=$accept