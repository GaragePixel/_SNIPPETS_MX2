
Namespace myapp

#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo.m2..

Class MyWindow Extends Window

	Method New( title:String="Simple mojo app",width:Int=640,height:Int=480,flags:WindowFlags=Null )

		Super.New( title,width,height,flags )
	End

	Method OnRender( canvas:Canvas ) Override
	
		App.RequestRender()
		If Keyboard.KeyReleased(Key.Escape) App.Terminate()
	
		canvas.DrawText( "Hello World!",Width/2,Height/2,.5,.5 )
	End
	
End

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End
