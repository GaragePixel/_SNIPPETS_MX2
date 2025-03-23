#Import "<std>"
#Import "<mojo>"

Using stdlib..
Using sdk_mojo.m2..

Const WIDTH:Int =640
Const HEIGHT:Int =400

Class MyWindow Extends Window
	
	Field showFPS:Bool=True
	Field t:Float
	
	Method MouseCanvasLocation:Vec2f( canvas:Canvas )
		Return -canvas.Matrix*App.MouseLocation
	End
	
	'-----------------------------------------------------------------------------------------------------------
	Method New(title:String, width:Int, height:Int, flags:WindowFlags=Null)
		Super.New(title,width,height,flags)
		ClearColor=Color.Black
		SwapInterval=0
	End Method
	'-----------------------------------------------------------------------------------------------------------
	Method OnCreateWindow() Override
	End 	
	'-----------------------------------------------------------------------------------------------------------
	Method OnRender( canvas:Canvas ) Override
		App.RequestRender()
		If Keyboard.KeyReleased(Key.Escape) App.Terminate()
			
		t+=.1
		Local mouse:=MouseCanvasLocation(canvas)
		
		If showFPS canvas.DrawText( App.FPS,10,10 )
		
	End
End
Function Main()

	New AppInstance
	
	New MyWindow("Mojo App Hello World",WIDTH,HEIGHT, WindowFlags.Resizable)
	App.Run()
End
