//%attributes = {"invisible":true}
$protocol:="http:"
$port:=String:C10(WEB Get server info:C1531.options.webPortID)
$ipAddress:="127.0.0.1"

$url:=New collection:C1472($protocol; ""; $ipAddress+":"+$port; "rest"; "Product").join("/")

OPEN URL:C673($url)