Function Main()
	Local bin:= New Int[4] 		'class type allows to pass trough the scope of the lambda
	Local binPtr:= New Int[0] 	'class type allows to pass trough the scope of the lambda
	binPtr[0]=0
	Local _pokeBitsf_:=Lambda(a:Int,b:Int,c:Int,d:Int) 	'Anonymous function as co-routine
		bin[binPtr[0]]=a								'Since class type can overpass the scope
		binPtr[0]+=1									'of the lambda, we can use any objects from
		bin[binPtr[0]]=b								'the outter function.
		binPtr[0]+=1
		bin[binPtr[0]]=c
		binPtr[0]+=1
		bin[binPtr[0]]=d
		binPtr[0]+=1
	End	
	_pokeBitsf_(1,2,3,4)
	For Local n:Int=0 Until binPtr[0]
		Print n+": "+bin[n]
	Next 
End