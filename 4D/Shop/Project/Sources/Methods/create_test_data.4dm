//%attributes = {"invisible":true}
TRUNCATE TABLE:C1051([Product:1])
SET DATABASE PARAMETER:C642([Product:1]; Table sequence number:K37:31; 0)

$product:=ds:C1482.Product.new()
$product.name:="Apple"
$product.code:=$product.generateCode()
$product.save()

$product:=ds:C1482.Product.new()
$product.name:="Banana"
$product.code:=$product.generateCode()
$product.save()

$product:=ds:C1482.Product.new()
$product.name:="Cucumber"
$product.code:=$product.generateCode()
$product.save()
