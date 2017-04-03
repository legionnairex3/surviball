
#Import "<mojo>"

Global Text:BitmapText

Class BitmapText
	
	Field chWidth:Int
	Field chHeight:Int

	Field count:Int
		
	Field image:Image[]
	
	Field upper:Int
	
	Method New(image:Image[],count:Int)
		Self.chWidth = image[0].Width
		Self.chHeight = image[0].Height
		Self.image = image
		Self.count = count
	End Method

	Method CharWidth:Int()
		Return chWidth
	End Method
	
	Method CharHeight:Int()
		Return chHeight
	End Method
	
	Method Width:Int(str:String)
		Return str.Length * chWidth
	End Method
	
	Method Height:Int(str:String)
		Return chHeight
	End Method
	
	Method Draw:Void(canvas:Canvas,str:String,x:Int,y:Int)
		Local tx:Int = x
		Local ty:Int = y
		For Local c:Int = Eachin str
			c &= $FF
			If c < 91
				c -= 32
			Else
				c -= 64
			Endif
			canvas.DrawImage(image[c],tx,ty)
			tx += chWidth
		Next
	End Method

End Class
