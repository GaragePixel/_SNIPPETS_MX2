#Import "<std>"
Using std..

' After having reinvented a ProcedureCall API, I have discovered
' that the idea already exists (of course, I more or less knew that)
' but the concept behind and even the name are exactly the same:
' https://www.google.com/search?q=procedurecall
' So I'm in the right direction ;)
'
' This is the simple version that allows to call a procedure which
' the functions haves only one parameter (the program will be more fast
' with a 1-attribut program.
'
' The idea is to create a stack of Lambda with one or some parameters then
' execute the stack. So I have finally decided to make an API from that.
'
' Note that you can use a List, Stack of Tuple as parameter.
'
' This is a sample of the API and the detailled explication about the technique:

Alias Parameter:Variant
Alias Procedure:Variant
Alias ProgramProcs:Stack<Parameter>

Function MkProgramProcs:ProgramProcs()
	Return New ProgramProcs
End

Function Proceeds(unit:Procedure,arg:Parameter)
	' Read as "execute the specialised procedure unit"
	Local run:=Cast<Void(Parameter)>(unit)
	run(arg)
End

Function ProcedureCall(procedure:Stack<Procedure>,arg:Parameter)
	Local query:=Cast<Stack<Parameter>>(procedure)
	For Local unit:=Eachin query
		Proceeds(unit,arg)
	Next
End

Function Main()  ' Nested lambda with one parameter
	
	' The Stack, it can be global or embedded/instancied in a class.
	'Local _Programs_:=New Stack<Parameter>
	
	' We can use the API:
	Local _Programs_:=MkProgramProcs()
	
	' The procedures, as simple Lambdas:
	Local __Unit1__:=Lambda(args:Parameter)
		Print "AA and "+Cast<String>(args)
	End
	Local __Unit2__:=Lambda(args:Parameter)
		Print "BB"
	End
	
	' If you want it as a local variable (protected scope)
	'Local _Run_:Void(args:Parameter) 
	
	' The Stack is accumulated with the functions in order to
	' create the desired procedure:
	_Programs_.Push(__Unit1__)
	_Programs_.Push(__Unit1__)
	_Programs_.Push(__Unit2__)

	' Then we can call the procedure.
	' Manual version: We write the loop who calls the units:
	For Local n:=Eachin _Programs_ 
'		_Run_=Cast<Void(Parameter)>(n) ' If you want call localy
'		_Run_("blah")
		Proceeds(n,"arg") ' If you want use the API
	Next

	' Finally, the Program can be executed with the help of the API:
	ProcedureCall(_Programs_,"arg") ' Voila the famous name

End
