Function Main()
	Print TestVarString()
	Print TestVarStringArr()[1]
End 

Function TestVarString:String()
	Return Cast<String>(TestVar(True))
End

Function TestVarStringArr:String[]()
	Return Cast<String[]>(TestVar(False))
End

Function TestVar:Variant( option:Bool )
	If option Return Cast<Variant>(String("test"))
	Return Cast<Variant>(New String[]("1","2"))
End 