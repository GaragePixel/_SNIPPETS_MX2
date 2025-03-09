#Import "<std>"
Using std.collections..

Class Animal 
	
	Class Cat Extends Animal

		Method New()
			_typeOf="Cat"
		End
		
		Method Vocalize:String() Override
			Return "Nya"
		End
		
	End
	
	Class Dog Extends Animal
		
		Class Breed Extends Dog
			
			Class Chiwawa Extends Breed

				Method New()
					_typeOf="Chiwawa"
				End
				
				Method Vocalize:String() Override
					Return "ra ra rarara"
				End
			End
			
			Class Rottweiler Extends Breed 

				Method New()
					_typeOf="Rottweiler"
				End
				
				Method Vocalize:String() Override
					Return "Rhwwwwaaaaaaaf"
				End
			End			
			
			Method New()
				_typeOf="Breed of Dog"
			End
			
			Method Vocalize:String() Override
				Return "Woof!"
			End			
			
		End

		Method New()
			_typeOf="Dog"
		End 
		
		Method Vocalize:String() Override
			Return "Woofy"
		End
	End	
	
	Class SuperDog Extends Dog
		
		Method New()
			_typeOf="SuperDog" 
		End 
		
		Method Vocalize:String() Override
			Return "Super Woofy"
		End
	End	
	
	Field _typeOf:String="unidentified specimen"

	Method Vocalize:String() Virtual 
		Return "I vocalize!"
	End
	
End 

function Main()
	Local animal:=New Animal
	Local cat:=New Animal.Cat
	Local dog:=New Animal.Dog
	Local superdog:=New Animal.SuperDog
	Local unknowdog:=New Animal.Dog.Breed
	Local chiwawa:=New Animal.Dog.Breed.Chiwawa
	Local rottweiler:=New Animal.Dog.Breed.Rottweiler
	
'	print animal.Vocalize()
'	print cat.Vocalize()
'	print dog.Vocalize()
'	print superdog.Vocalize()
'	print unknowdog.Vocalize()
'	print chiwawa.Vocalize()
'	print rottweiler.Vocalize()
	
	Local specimens:=New List<Animal>
	specimens.Add(animal)
	specimens.Add(cat)
	specimens.Add(dog)
	specimens.Add(superdog)
	specimens.Add(unknowdog)
	specimens.Add(chiwawa)
	specimens.Add(rottweiler)
	
	For local n:= Eachin specimens
		Print "Type of entity : "+String(Typeof(n)).Split(".")[1]+", "+n._typeOf
		Print "The "+String(n._typeOf).ToLower()+" says: - '"+n.Vocalize()+"'"
		Print ""
	Next 
	
End 