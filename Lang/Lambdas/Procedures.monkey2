#Import "<std>"

Using std..
'Using std.collections.stack

' Mini ProcedureCall Library
' Author: iDkP for GaragePixel
' 2024-12
'
' This is the simple version that allows to call a procedure which
' the functions haves only one parameter and can return a value.
' We can hold many parameters and return values in containers (array, stack... ).
'
' This implentation over-use the pointer, so any objects, stacks, functions and
' uniform blocks sharing the same memory space attached to the binding Unit,
' actually the query, and the memory grows at run time exactly according 
' the query's complexity. The performances on a Ryzen 5 3600 (3.6 GHz-4.2 GHz) 
' is about 4,878,048 calls by seconds.
'
' The way this library takes the procedure call synthaxe is really similar to 
' the IBM's language PL/I: https://en.wikipedia.org/wiki/PL/I
' -> see the axample in: https://en.wikipedia.org/wiki/Function_(computer_programming)
' The scope is the same than the closure: 
' https://en.wikipedia.org/wiki/Closure_(computer_programming)
' This implementation isn't an code adaptation but an original work before having learn
' the theorie.
'
' Basically, it implements the idea behind currying a primary function with a
' set of uniforms, sharing a set of parameters which the arity isn't fixed. 
' Technically using the 1st-class function available as a 
' feature of the transpiler's language, the variant, the casting system and the
' stacks are the three other features used in the core library. The nested functions
' are achieved by assigning the lambdas, allowing dynamic programming at run time.
' 
' The set of parameters implements the idea of the variadic function 
' (variable number of arguments) since we can use the collection types 
' (List, Stack, Map) or any Tuple as parameter because the
' parameter's type is actually variant. The program is faster with a 
' 1-design query implementation but we need to cast any parameters, we
' can't implicitally assign or read the parameter(s) without knowing exactly its/theirs
' data type unless using a Map, for example, for key-value searching, with significant 
' performance drop. So the blocks should be designed according the data's structure
' but any blocks can accesses the set of parameter(s) in the query, in such way the
' query's system's design is balanced as a Levi graph sharing the same memory.
' This type of design is absolutly necessary in the case where the factoring
' is a part of the core features of a program.
'
' About the writting convention:
'
'	A closure (variable container for a 1st class function) is
'	surounded by _
'		Example: _closure_
'
'	A lambda (1st class function) is surounded by the sign __
'		Example: __codeBlock__
'
'	The logic behind this convention is about the depth of an nested object from the main scope.
'	The more depth is, the more _ we add around the name.
'
' A sample of the API and the detailled explication is given as an example usage.

Alias Parameter:Variant
Alias CodeBlock:Variant
Alias CodeBlockStack:Stack<CodeBlock>

Alias Result:Parameter
Alias ResultStack:Stack<Result>

Struct MiniProcedure

	' Mini Procedure Library
	' Author: iDkP for GaragePixel
	' 	2024-12-07: First commit
	' 	2025-01-21: Upgrade about Sub and output, record parameters
	'		Added:
	'			Sub (simple procedure call without any returned variable (subroutine style programming))
	'			Apply (query with an output parameter who can return a record, in this case called Clause)
	'			Bind (overloaded version for handling Apply)
	'			Add (sugar, same than Push)
	'			RemoveIf (remove a block from a procedure according a custom condition)

'TODO:
	'Make a version of Procedure Unit and Serial where the passed parameters and copied but not the returned ones
	
	Function Init:CodeBlockStack()
		'Sugar
		Return Init_Procedure()
	End

	Function Init_Procedure:CodeBlockStack()
		' Init the program of procedures. 
		'
		' Note:
		' 	After calling this function, 
		'	we define some lambda (the blocks), then we pushes 
		' 	these functions into the stack of the query.
		' 	The query is then executed with MiniProcedure.Call
		Return New CodeBlockStack
	End

	Function Init_Block:CodeBlock()
		' Init the procedure.
		' Semi-sugar
		'
		' Actually, this version stores only one block.
		' So, if we declare a variable:
		'	Local _query_:Query
		' We only have to assign the block to the _query_ alike:
		'	_query_=__block1__
		'
		' Note:
		' 	Because the Stack malloc 10 empty nodes,
		' 	the query ain't hold a Stack for binding
		' 	a unique block!
		'
		Return Null
	End
	
	Function Call(procedure:CodeBlockStack Ptr,params:Parameter Ptr,out:Result Ptr=Null)
		' Executes each blocks referenced by the procedure's stack.
		Local query:=Cast<Stack<Parameter>>(Read(procedure))
		For Local block:=Eachin query
			MiniProcedure.Bind(Varptr block,params,out)
		Next
	End

	Function Call(procedure:CodeBlock Ptr,params:Parameter Ptr,out:Result Ptr=Null)
		' Executes the only block referenced by the procedure's Unit.
		Local block:=Cast<Parameter>(Read(procedure))
		MiniProcedure.Bind(Varptr block,params,out)
	End

	Function Bind(block:CodeBlock Ptr,params:Parameter Ptr,out:Result Ptr=Null)
		' Bind in a 1st class function the specialised procedure block and execute (apply) it
		' Note:
		' 	What is being binded is the block with its parameters in the closure of a first class function 
		' 	which is called at run time.
		If Cast<Parameter>(Read(block))<>Null 'Guard
			If out<>Null 'Guard
				Local _apply_:=Cast<Void(Parameter Ptr, Result Ptr)>(Read(block))
				_apply_(Varptr params[0],out)
			Else
				Local _apply_:=Cast<Void(Parameter Ptr)>(Read(block))
				_apply_(Varptr params[0])
			End 
		End
	End
	
	Function Bind(block:CodeBlock Ptr,params:Parameter Ptr,clause:ResultStack Ptr)
		' Bind in a 1st class function the specialised procedure block and execute (apply) it
		' Note:
		' 	Specialised version where the closure which can hold a stack for more one returned variables
		'	of different types as variants
		If Cast<Parameter>(Read(block))<>Null 'Guard
			Local _apply_:=Cast<Void(Parameter Ptr, ResultStack Ptr)>(Read(block))
			_apply_(Varptr params[0],Varptr clause[0])
		End
	End	

	Function Sub(block:CodeBlock Ptr,params:Parameter Ptr)
		' Sugar
		' Executes a block as a sub program (no returned value)
		MiniProcedure.Call(block,params)
	End
	
	Function Apply(block:CodeBlock Ptr,params:Parameter Ptr,clause:ResultStack Ptr)
		' Executes a block and passes a stack for storing the clause.
		' This is equivalent to a function call, but it can return a record
		MiniProcedure.Bind(block,params,clause)
	End 

	Function Push(procedure:CodeBlockStack Ptr,block:CodeBlock Ptr)
		' Push a block into the procedure stack
		Local query:=Cast<Stack<Parameter>>(Read(procedure))
		If query<>Null 'Guard		
			query.Push(Varptr block)
		End
	End

	Function Add(procedure:CodeBlockStack Ptr,block:CodeBlock Ptr)
		' Sugar
		' This method behaves identically to Push( procedure:CodeBlockStack Ptr,block:Procedure Ptr ).
		Push(procedure,block)
	End 
	
	Function Dup:CodeBlockStack(procedure:CodeBlockStack Ptr)
		' Duplicate a procedure, doesn't "imports" the in/out parameters.
		' Make it clear: The Query is duplicated, the blocks are instanciated,
		' the parameter(s)'s set in and out are ignored.
		Local result:CodeBlockStack
		Local query:=Cast<Stack<Parameter>>(Read(procedure))
		If query<>Null 'Guard
			result=MiniProcedure.Init()
			For Local block:=Eachin query 	' It's actually a semi-instanciation who can works
				result.Push(Varptr block)	' with a complet different set of parameters and out variables.
			Next
		End
		Return result
	End 

	Function Dup:CodeBlock(block:CodeBlock Ptr)
		' Duplicate a block without its in and out parameters.
		Return Cast<Parameter>(Read(block))
	End

	Function RemoveIf<T>:Int( procedure:CodeBlockStack Ptr, condition:Bool( value:T ) )
		' Remove a block from the procedure if the block satisfy the condition passed as argument.
		' Returns the number of deletion(s).
		' Note: 
		'	It's the adapted function used in the Stack implementation.
		Local put:=0,n:=0
		Local p:=Read(procedure)
		For Local get:=0 Until p.Length
			If condition( p.Set[get] )
				n+=1
				Continue
			Endif
			p.Set[p.Get[get]]
			put+=1
		Next
		p.Resize( put )
		Return n
	End
	
	Function Clear(procedure:CodeBlockStack Ptr)
		' Clear the closure (procedure stack version).
		Cast<Stack<CodeBlock>>(procedure[0])=Null
	End 

	Function Clear(block:CodeBlock Ptr)
		' Clear the closure (procedure's unit version).
		Cast<CodeBlock>(block[0])=Null
	End
	
'	Function Monad:ResultStack(procedure:CodeBlock Ptr, params:Parameter) 'The param(s) is/are copied
'		Local record:=New ResultStack ' Create the record
'		'Local r:=Cast<ResultStack>(record)
'		Local _apply_:=Cast<Void(Parameter Ptr, ResultStack Ptr)>(Read(procedure)) ' Bind the codeblock
'		_apply_(Varptr params[0], Varptr record[0]) ' Apply the codeblock
'		Return record
'	End

'	Function Bind(block:CodeBlock Ptr,params:Parameter Ptr,clause:ResultStack Ptr)
'		' Bind in a 1st class function the specialised procedure block and execute (apply) it
'		' Note:
'		' 	Specialised version where the closure which can hold a stack for more one returned variables
'		If Cast<Parameter>(Read(block))<>Null 'Guard
'			Local _apply_:=Cast<Void(Parameter Ptr, ResultStack Ptr)>(Read(block))
'			_apply_(Varptr params[0],Varptr clause[0])
'		End
'	End	
End 
'#rem
Function Main()
	
	' Declare the closure:
	
	'Local _closure_:=MiniProcedure.Init_Block() 'Init_Block for holding only one code block	
	Local _closure_:CodeBlock

	' Sub, with border effect on params:
	Local __Pow2_Sub_noborderFx__:=Lambda(params:Parameter Ptr)
		Print "must be 4: "+CastUInt(Read(params))*CastUInt(Read(params))
	End

	' Sub, without out, allows the override a set of variables by border effect:
	Local __Pow2_Sub_borderFx__:=Lambda(params:Parameter Ptr)
		Assign(params, CastUInt(Read(params))*CastUInt(Read(params))) 'Border effect on A allows to simulate out
	End
	
	' Procedure with border effect:
	Local __Pow2_borderFx__:=Lambda(params:Parameter Ptr,out:Result Ptr)
		Assign(params, CastUInt(Read(params))*CastUInt(Read(params)))
		Assign(out, CastUInt(Read(params))*CastUInt(Read(params))) 'Border effect on A
	End

	' Procedure without border effect #1:
	Local __Pow2_noborderFx1__:=Lambda(params:Parameter Ptr,out:Result Ptr)

		Assign(out, CastUInt(Read(params))*CastUInt(Read(params))) 'No border effect on A

	End

	' Procedure without border effect #2:
	Local __Pow2_noborderFx2__:=Lambda(params:Parameter Ptr,out:Result Ptr)
	
		Local A:=CastUInt(Read(params)) 'No border effect (the param is copied and untouched)
		
		Assign(out, A*CastUInt(Read(params)))
	End

	' Procedure with multi out values of the same type
	Local __MultiOutTest__:=Lambda(params:Parameter Ptr,out:Result Ptr)
	
		Local A:=CastUInt(Read(params)) 'No border effect (the param is copied and untouched)

		'out[1]=A/CastUInt(Read(params))
'		Read(Read(out))[0]=A/CastUInt(Read(params))
		Assign(out,1,A*CastUInt(Read(params))) ' Border effect
		
		'Print "a: "+CastUInt(Cast<Variant>(var_out[0]))
		Print "a: "+CastUInt(Read(out,1))
		
		'out=Cast<Result Ptr>(Varptr outv)

	End

	' Call the procedure from the closure:
	
	' --------------------
	' Create a sub
	' --------------------
	
	_closure_=__Pow2_Sub_noborderFx__
	Local param:=Cast<Parameter>(UInt(2)) 'The params holder, we need to declare that outside the call.
	
	'MiniProcedure.Call(Varptr _closure_,Varptr param)
	MiniProcedure.Sub(Varptr _closure_,Varptr param) 'sugar for the precedent line
	
	' Get the result (no border effect):
	Print "must be 2: "+CastUInt(param)

	' --------------------
	' Create a sub with border effect
	' --------------------

	_closure_=__Pow2_Sub_borderFx__

	MiniProcedure.Sub(Varptr _closure_,Varptr param)

	' Get the result (use the border effect):
	Print "must be 4: "+CastUInt(param)

	' --------------------
	' Create a procedure with out and border effect
	' --------------------
	
	_closure_=__Pow2_borderFx__
	param=Cast<Parameter>(UInt(2))
	Local out:=Cast<Result>(VarUInt())

	MiniProcedure.Call(Varptr _closure_,Varptr param,Varptr out)

	' Get the result (use the border effect):
	Print "must be 4: "+CastUInt(param)
	Print "must be 16: "+CastUInt(out)

	' --------------------
	' Create a procedure with out and no border effect #1
	' --------------------

	_closure_=__Pow2_noborderFx1__
	param=Cast<Parameter>(UInt(2))
	out=Cast<Result>(VarUInt())

	MiniProcedure.Call(Varptr _closure_,Varptr param,Varptr out)

	' Get the result (use the border effect):
	Print "must be 2: "+CastUInt(param)
	Print "must be 4: "+CastUInt(out)

	' --------------------
	' Create a procedure with out and no border effect #1
	' --------------------

	_closure_=__Pow2_noborderFx2__
	param=Cast<Parameter>(UInt(2))
	'out=Cast<Result>(VarUInt())
	out=VarUInt() ' We can write this instead of out=Cast<Result>(VarUInt())

	MiniProcedure.Call(Varptr _closure_,Varptr param,Varptr out)

	' Get the result (use the border effect):
	Print "must be 2: "+CastUInt(param)
	Print "must be 4: "+CastUInt(out)

	' --------------------
	' Create a procedure with multi out
	' --------------------

	_closure_=__MultiOutTest__
	param=Cast<Parameter>(UInt(2))
	out=VarUInt() 'Embbed the default data type uint in the variant out

	MiniProcedure.Call(Varptr _closure_,Varptr param,Varptr out)

	' Get the result (use the border effect):
	Print "must be 4: "+CastUInt(param)+" instead of 2, because the border effect in the function" 
	Print "must be 4: "+CastUInt((Varptr out)[1])
	Print "must be 4: "+CastUInt(Varptr out,1)

'	Print "must be 4: "+CastUInt(out)

	'Local param:=Cast<Parameter>(UInt(1)) 'The params holder, we need to declare that outside the call.
	'Local out:=Cast<Result>(String(""))	'The return holder, we need to declare that outside the call.	
	'MiniProcedure.Call(Varptr _closure_,Varptr params, varptr out)
	
End
'#End

#rem - Mini-Procedure How-to, quick example:

	' Declare the closure:
	
	Local _closure_:=MiniProcedure.Init() 'Init_Block for holding only one code block
	' For holding only one code block, we can write: Local _closure_:Query
	
	' Write a code block and push it in/assign it to the closure:
	
	Local __block1__:=Lambda(params:Parameter Ptr, out:Result)
		Print "AA and "+Cast<String>(Read(params))
		Assign(out, "AA and "+Cast<String>(Read(params)))
	End
	_closure_.Push(__block1__) ' We can write _closure_=__block1__ for the Unit version (only one code block)
	
	' Call the procedure from the closure:
	
	Local params:=Cast<Parameter>("param") 'The params holder, we need to declare that outside the call.
	Local out:=Cast<Result>(String(""))	'The return holder, we need to declare that outside the call.	
	MiniProcedure.Call(Varptr _closure_,Varptr params, varptr out)
	
	' Get the out value:

	Print Cast<String>(out) 	' The returned value the one for each calls.
								' To get a different return value, we should declare
								' a stack "out" instead of a single string value, then
								' add to this stack the wanted returned value, some
								' strategies are possible.
								' Note: We need to cast the variable with the attended type.
	
#end 


#rem
Function Main()  ' Nested lambdas with one parameter, using pointers and "returns" a variable
	
	' The Stack, it can be global or embedded/instancied in a class.
	'Local _query_:=New Stack<Parameter>
	
	' Instead of doing it manually, we call the API:
	Local _closure_:=MiniProcedure.Init()
	
	' The custom procedure-blocks are simply anonymous functions:
	Local __block1__:=Lambda(params:Parameter Ptr,out:Result Ptr)
		Assign(out, "AA and "+Cast<String>(Read(params)))
		Print "The block 1 is running"
	End
	Local __block2__:=Lambda(params:Parameter Ptr,out:Result Ptr)
		Print "The block 2 is running"
	End
	
	' If you want it as a local variable (protected scope)
	'Local _Run_:Void(params:Parameter)
	
	' The Stack is accumulated with the functions in order to
	' create the desired query:
	_closure_.Push(__block1__)
	_closure_.Push(__block1__)
	_closure_.Push(__block2__)
	_closure_.Push(__block2__)

	' Then we can call the procedure.

	' Manual version: We write the loop who calls the blocks:
	
'	For Local block:=Eachin _query_ 
'
''		_Run_=Cast<Void(Parameter)>(block) ' If you want call localy
''		_Run_("param")
'
'		' "If you want use the API" version:
'
'		Local params:=Cast<Variant>("param") 	' We can't fold it directly in the function call 
'												' because the transpiler limitation:
'		Bind(VarPtr block,VarPtr params) 		' "not a valid variable reference"

'	Next

	' Finally, the query can be bound with the help of the API:
	
'	For Local n:=0 Until 100000000 	' Running 400,000,000 calls (without the prints) is 
'									' about 82 seconds, so 4,878,048 by seconds, meaning
'									' ~5,000 calls each milliseconds 
'	Local out:=Cast<Variant>(String(""))	'The return holder, we need to declare that outside the function!
	Local out:=VarString()	'The return holder, we need to declare that outside the function!
	'Local params:=Cast<Variant>("param BB") 'The params holder, we need to declare that outside the function!
	Local params:=VarT("param BB") 'The params holder, we need to declare that outside the function!
	MiniProcedure.Call(Varptr _closure_,Varptr params,Varptr out)
'	Local r:=Cast<String>(eval)
	 		' The returned value the one for each calls.
	Print Cast<String>(out)		' We need to cast the variable with the attended type.
								' The returned value the one for each calls.
								' To get a different return value, we should declare
								' a stack "out" instead of a single string value, then
								' add to this stack the wanted returned value, some
								' strategies are possible.
	Print String(out)			' Note: We can just cast by type like that
	Print CastString(out)		' Note: Or with this sugar
																
'	Next 
	'
	' If the "not a valid variable reference" transpiler's error was not, the following
	' synthaxe should be valid:
	' 	MiniProcedure.Call(Varptr _query_,Varptr Cast<Variant>("param"), Varptr Cast<Variant>(String("")) )
	'
	' Unfortunaly, we need to reference the parameters via a variable declared out there.
	' We can't declare it inside the call's parameters, neither as the result of a 
	' function, but we need to declare the variant like shown in the example.
	'
	' For clarity, you can't write:
	'	MiniProcedure.Call(Varptr _query_,Varptr Cast<Variant>("param"),Varptr Cast<Variant>(String(""))) 'or any other strategy...
	'
	' ... but you must write:
	' 	MiniProcedure.Call(Varptr _query_,Varptr params,Varptr out)
	'
	' It's the same thing, but not for the transpiler.
	
	' -------------------------------------------------------------
	' Test with the Query:
	
	' The program is initialized:
''	Local _query_:=MiniProcedure.Init_Block()
	
	' The subProgram (code block) is assignated:
''	_query_=__block1__
	
	' The procedure is called
''	MiniProcedure.Call(Varptr _query_,Varptr params,Varptr out)
	
	' We can clear the closure:
''	MiniProcedure.Clear(Varptr _query_)

	' There not any procedure's instance in the closure:
''	MiniProcedure.Call(Varptr _query_,Varptr params,Varptr out)
	' -------------------------------------------------------------

End

#end
'#end