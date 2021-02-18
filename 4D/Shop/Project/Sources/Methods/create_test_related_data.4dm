//%attributes = {"invisible":true}
TRUNCATE TABLE:C1051([Trade:2])
SET DATABASE PARAMETER:C642([Trade:2]; Table sequence number:K37:31; 0)

$products:=ds:C1482.Product.all()

$year:=2021

For each ($product; $products)
	
	For ($i; 1; 12)
		For ($ii; 1; (Random:C100%100)+1)
			
			$trade:=ds:C1482.Trade.new()
			$trade.date:=Add to date:C393(!00-00-00!; $year; $i; (Random:C100%Day of:C23(Add to date:C393(!00-00-00!; $year; $i+1; 1)-1))+1)
			$trade.product:=$product
			$trade.expense:=((Random:C100%100)+1)*100
			$trade.income:=(((Random:C100%100)+1)*50)+((Random:C100%100)+1)*100
			$trade.save()
			
		End for 
	End for 
	
End for each 