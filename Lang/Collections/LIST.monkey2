
Namespace myapp

#Import "<std>"

Using std..

Function Main()

	Local myList:=New List<Int>
	myList.Add(10)
	myList.Add(20)
	myList.Add(30)

	Local a:=myList.LastNode().Value
	Local b:=myList.LastNode().Pred.Value

	For Local n:=Eachin myList
		Print n
	Next 
	
End