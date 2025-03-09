'Example of dynamic architecture used in Aida
'iDkP from GaragePixel
'2025-02-13

'In this example
'	Random is the program manager, a singleton
'	Randomizer is the program prototype, an abstract class
'	xoroshiro128 is the program implementation, a final class

Class Random Final 'for security
	
	Property Randomizer:Randomizer()
		Return _Randomizer
	Setter(randomizer:Randomizer) 	'<-- 	Can be absent from the implementation,
		_Randomizer=randomizer		'		or protected as a function
	End
	
	Function Name:String()
		'Returns the name of the current used randomizer
		Return "Randomizer: "+_Randomizer
	End
	
	Function Rnd:Double()
		Return _Randomizer.Rnd()
	End
	
	Function Rnd:Double( max:Double )
		Return _Randomizer.Rnd(max)
	End
	
	Function Rnd:Double( min:Double,max:Double )
		Return _Randomizer.Rnd(min,max)
	End

	Function Seed(seed:ULong)
		_Randomizer.Seed(seed)
	End
	
	Private 

	Global _Randomizer:Randomizer=Random._DefautRandomizer 'initialisation
	
	Const _DefautRandomizer:=New xoroshiro128()
End 

Class Randomizer Abstract
	
	Operator To:String() Virtual
		'Must return the name of the randomizer
		Return "No randomizer used."
	End

	Method Rnd:Double() Virtual
		'Must return a pseudo-random number
		Return Null
	End
	
	Method Rnd:Double( max:Double ) Virtual 
		'Must return a pseudo-random number choosen between 0 and max
		Return Null
	End
	
	Method Rnd:Double( min:Double,max:Double ) Virtual
		'Must return a pseudo-random number choosen between min and max
		Return Null
	End
	
	Method Seed(seed:ULong) Virtual
		'Used to seed the random number generator
	End
End

Class xoroshiro128 Extends Randomizer Final

	Operator To:String() Override Final
		Return "xoroshiro128"
	End
	
	Method Rnd:Double() Override Final
		Local x:=RndULong(),y:ULong=$3ff
		Local t:ULong=(y Shl 52) | (x Shr 12)
		Return (Cast<Double Ptr>( Varptr t ))[0]-1
	End
	
	Method Rnd:Double( max:Double ) Override Final
		Return Rnd()*max
	End
	
	Method Rnd:Double( min:Double,max:Double ) Override Final
		Return Rnd(max-min)+min
	End

	Method Seed( seed:ULong ) Override Final
		state0=seed*2|1
		state1=~state0|1
		RndULong()
		RndULong()
	End

	Method RndULong:ULong()
		Local s0:=state0
		Local s1:=state1
		s1~=s0
		state0=rotl( s0,55 ) ~ s1 ~ (s1 Shl 14)
		state1=rotl( s1,36 )
		return state0+state1
	End
	
	Private
	
	Field state0:ULong=1234
	Field state1:ULong=~1234|1
	
	Function rotl:ULong( x:ULong,k:Int )
		Return (x Shl k) | (x Shr (64-k))
	End
End 