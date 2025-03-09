Class Image Extension 'Common
	
	' iDkP for Garagepixel
	' About some useful functions that complete the Image class

	Function Load:Image(	path:String,
							format:PixelFormat=PixelFormat.RGB8,
							textureflags:TextureFlags=TextureFlags.Filter,
							pmAlpha:Bool=False,
							shader:Shader=Null	)
		
		' iDkP for Garagepixel
		' New version of the Load from file with premultiplyAlpha
		' and color format takes in account.
		
		Return New Image(Pixmap.Load(path,format,pmAlpha),textureflags,shader)
	End
End