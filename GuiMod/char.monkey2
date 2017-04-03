#Import "<mojo>"

Class Char
	Field asc:Int
	Field x:Int
	Field y:Int
	
	Field width:Int
	Field height:Int = 0
	
	Field xOffset:Int = 0
	Field yOffset:Int = 0
	Field xAdvance:Int = 0
	
	
	Method New(x:Int,y:Int, w:Int, h:Int, xoff:Int=0, yoff:Int=0, xadv:Int=0)
		Self.x = x
		Self.y = y
		Self.width = w
		Self.height = h
		
		Self.xOffset = xoff
		Self.yOffset = yoff
		Self.xAdvance = xadv
	End
	
	Method Render(canvas:Canvas,fontImage:Image, linex:Int,liney:Int)
		canvas.DrawRect(linex+xOffset,liney+yOffset, width,height,fontImage,x,y )
	End Method
	Method toString:String()
		Return String.FromChar(asc)+"="+asc
	End Method
End Class






