Function Main()
	
	Local a:Int[]
	Local b:=Lambda:Int[](c:Int)
		Return New Int[](0+c,1+c,2+c)
	End
	
	a=b(1)
	Print a[0]+" "+a[1]+" "+a[2]	
End 
