Function Main()  ' Nested lambda with arguments
	Local myProgram:Void(a:String)
	Local func1:=Lambda(text:String)
		Print text 
	End
	Local func2:=Lambda(text:String)
		Print text+"a"
	End
	myProgram=func1
	myProgram("a")
	myProgram=func2
	myProgram("a")
End

#rem
Function Main() ' Nested lambda without arguments
	Local myProgram:Void()
	Local func1:=Lambda()
		Print "a"
	End
	myProgram=func1
	myProgram()
End
end