
Namespace myapp

#Import "<std>"

Using std..

Enum CarWheel
	One
	Two
	Three
	Four
End 

Class Car
	Field _wheels:Wheel[]
	Field _weight:Int
	Method New()
		Init()
		OnCreate()
	End
	Method Init()
		_weight=1000
	End
	Method OnCreate() Virtual
	End 
	Struct Wheel
		Field _value:Int
		Method New(value:Int)
			_value=value
		End 
	End 
End 

Class Viper Extends Car
	Method New()
		Init()
		OnCreate()
	End	
	Method OnCreate() Override 
		_wheels = New Wheel[4]
		_wheels[CarWheel.One] = New Wheel(CarWheel.One)
		_wheels[CarWheel.Two] = New Wheel(CarWheel.Two)
		_wheels[CarWheel.Three] = New Wheel(CarWheel.Three)
		_wheels[CarWheel.Four] = New Wheel(CarWheel.Four)		
	End 
End 

Function Main()
	
	Local _myCar:Viper
	
	_myCar = New Viper
	
	Print _myCar._wheels[CarWheel.One]._value
	Print _myCar._wheels[CarWheel.Two]._value
	Print _myCar._wheels[CarWheel.Three]._value
	Print _myCar._wheels[CarWheel.Four]._value
	Print _myCar._weight
	
	_myCar._wheels[CarWheel.One]._value=10
	_myCar._wheels[CarWheel.Two]._value=11
	_myCar._wheels[CarWheel.Three]._value=12
	_myCar._wheels[CarWheel.Four]._value=13

	Print _myCar._wheels[CarWheel.One]._value
	Print _myCar._wheels[CarWheel.Two]._value
	Print _myCar._wheels[CarWheel.Three]._value
	Print _myCar._wheels[CarWheel.Four]._value
	
End