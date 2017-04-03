
#Import "<mojo>"
#Import "GuiMod/GuiMod"

Class Menu
	Field x:Float
	Field y:Float
	Field backImg:Image
	Field button:Button
	
	Method New(imgAtlas:Image,x:Float,y:Float)
		Self.x = x
		Self.y = y
		Self.backImg = New Image(imgAtlas,0,160,500,400)
		Self.button = New Button(LoadFrames(imgAtlas,0,560,283,34,2),x,y,"")
	End Method
	
	Method Update:Int()
		button.Update()
		Return  Not button.GetState()
	End Method
	
	Method Render(canvas:Canvas)
		canvas.DrawImage(backImg,0,0)
		button.Render(canvas)
	End Method
	
End Class
	
		
Function LoadFrames:Image[](img:Image,x:Int,y:Int,width:Int,height:Int,count:Int)
	Local frames:Image[] = New Image[count]
	Local index:Int = 0
	Local posx:Int = x
	Local posy:Int = y
	While index < count
		If posx > (img.Width-width)
			Print posx
			posx = 0
			posy += height	
		Endif
		frames[index] = New Image(img,posx,posy,width,height)
		index += 1
		posx += width
	Wend
	Return frames
End Function

