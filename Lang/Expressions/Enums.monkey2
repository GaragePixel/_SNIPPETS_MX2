Enum CodeStr
	All=$0	' 		.	'all characters
	Alpha=$1' 		%a	'letters
	Ctrl=$2' 		%c	'control characters
	Digits=$3' 		%d	'digits
	LCase=$4' 		%l	'lower case letters
	Ponct=$5' 		%p	'punctuation characters
	Space=$6' 		%s	'space characters
	UCase=$7' 		%u	'upper case letters
	Alphanum=$8' 	%w	'alphanumeric characters
	hexadigits=$9' 	%x	'hexadecimal digits
	zero=$A' 		%z	'the character with representation 0
End 

Function test:UByte()
	Return CodeStr.Alpha
End

Function Main()
	If test()=$1
		Print "ok"
	Else 
		Print "no"
	End 
End 