
Namespace myapp

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Interface Pmap
	
	Method Draw()
	
End

Class RGBmap Implements Pmap 
	Field pixmap:Pixmap
	Method Draw()
	End
End

Class RGBAmap Implements Pmap 
	Field pixmap:Pixmap
	Method Draw()
	End
End

Class StencilMap Implements Pmap
	Field data:Pmap
	Method New(type:UByte)
		Select type
			Case 1
				data=New RGBAmap
			Default
				data=New RGBmap
	End
		data=New RGBAmap
	End
	Method Draw()
		data.Draw()
	End
End

Function Do(this:Pmap)
	this.Draw()
End 

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
