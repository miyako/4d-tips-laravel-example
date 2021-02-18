//%attributes = {"invisible":true}
C_OBJECT:C1216($request; $response)

$protocol:="http:"
$port:=String:C10(WEB Get server info:C1531.options.webPortID)
$ipAddress:="127.0.0.1"

ARRAY TEXT:C222($names; 0)
ARRAY TEXT:C222($values; 0)

If (Storage:C1525.session=Null:C1517)
	
	APPEND TO ARRAY:C911($names; "username-4D")
	APPEND TO ARRAY:C911($names; "session-4D-length")
	APPEND TO ARRAY:C911($names; "hashed-password-4D")
	
	$user:=ds:C1482.User.query("name == :1"; "user").first()
	
	APPEND TO ARRAY:C911($values; $user.name)
	APPEND TO ARRAY:C911($values; "60")
	APPEND TO ARRAY:C911($values; $user.password)
	
	$url:=New collection:C1472($protocol; ""; $ipAddress+":"+$port; "rest"; "$directory"; "login").join("/")
	$status:=HTTP Request:C1158(HTTP POST method:K71:2; $url; $request; $response; $names; $values; *)
	
	If ($status=200)
		$headers:=New object:C1471
		For ($i; 1; Size of array:C274($values))
			$headers[$names{$i}]:=$values{$i}
		End for 
		
		$setCookie:=$headers["Set-Cookie"]
		
		ARRAY LONGINT:C221($pos; 0)
		ARRAY LONGINT:C221($len; 0)
		
		If (Match regex:C1019("(WASID4D=[^;]+)"; $setCookie; 1; $pos; $len))
			Use (Storage:C1525)
				Storage:C1525.session:=New shared object:C1526("cookie"; Substring:C12($setCookie; $pos{1}; $len{1}))
			End use 
		End if 
		
	End if 
	
End if 

If (Storage:C1525.session#Null:C1517)
	
	ARRAY TEXT:C222($names; 0)
	ARRAY TEXT:C222($values; 0)
	
	APPEND TO ARRAY:C911($names; "Cookie")
	APPEND TO ARRAY:C911($values; Storage:C1525.session.cookie)
	
	$url:=New collection:C1472($protocol; ""; $ipAddress+":"+$port; "rest"; "Product(1)"; "getThisMonthProfit").join("/")
	$status:=HTTP Request:C1158(HTTP POST method:K71:2; $url; $request; $response; $names; $values; *)
	
	ARRAY TEXT:C222($names; 0)
	ARRAY TEXT:C222($values; 0)
	
	APPEND TO ARRAY:C911($names; "Cookie")
	APPEND TO ARRAY:C911($values; Storage:C1525.session.cookie)
	
	$url:=New collection:C1472($protocol; ""; $ipAddress+":"+$port; "rest"; "Product"; "getThisMonthProfit").join("/")
	$status:=HTTP Request:C1158(HTTP POST method:K71:2; $url; $request; $response; $names; $values; *)
	
	ARRAY TEXT:C222($names; 0)
	ARRAY TEXT:C222($values; 0)
	
	APPEND TO ARRAY:C911($names; "Cookie")
	APPEND TO ARRAY:C911($values; Storage:C1525.session.cookie)
	
	$url:=New collection:C1472($protocol; ""; $ipAddress+":"+$port; "rest"; "Product").join("/")
	$status:=HTTP Request:C1158(HTTP GET method:K71:1; $url; $request; $response; $names; $values; *)
	
End if 