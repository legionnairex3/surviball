#Import "<mojo>"
#Import "GuiMod"

Using mojo..
Class Frame
	Field x:Float
	Field y:Float
	Field lft:Float
	Field top:Float
	Field right:Float
	Field bottom:Float
	Field width:Float
	Field height:Float
	Field color:Float
	
	Field leftTopImg:Image
	Field leftBotImg:Image
	Field rightTopImg:Image
	Field rightBotImg:Image
	
	Field topImg:Image
	Field botImg:Image
	Field leftImg:Image
	Field rightImg:Image
	Field areaImg:Image
	
	Method New(x:Float,y:Float,width:Float,height:Float,color:Int = $FFFFFF)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.color = color
		
		Local atlas:Image = GetAtlas()
		Self.leftTopImg = New Image(atlas,0, 0,16,16)
		Self.leftBotImg = New Image(atlas,0,16,16,16)
		Self.rightTopImg = New Image(atlas,16,0,16,16)
		Self.rightBotImg = New Image(atlas,16,16,16,16)
		
		Self.topImg = New Image(atlas,15, 0, 1,16)
		Self.botImg = New Image(atlas,15,16, 1,16)
		Self.leftImg = New Image(atlas,0,15,16, 1)
		Self.rightImg = New Image(atlas,16,15,16,1)
		Self.areaImg = New Image(atlas,16,16,1,1)
		
		Self.lft = x - 8
		Self.top = y - 8
		Self.bottom = y+height
		Self.right  = x+width
		
	End Method
	
	Method Setxy:Void(x:Float,y:Float)

		Self.x = x
		Self.y = y
		Self.lft = x - 8
		Self.top = y - 8
		Self.bottom = y+height
		Self.right  = y+width
	
	End Method
	
	Method Render(canvas:Canvas)
	
		Local oldColor := canvas.Color
		canvas.Color = SetColor(color)
		
		canvas.DrawImage(leftTopImg, lft, top,0,.5,.5)
		canvas.DrawImage(rightTopImg, right, top,0,0.5,0.5)
		canvas.DrawImage(leftBotImg, lft, bottom,0,0.5,0.5)
		canvas.DrawImage(rightBotImg, right, bottom,0,0.5,0.5)
		
		canvas.DrawImage(topImg, x, top,0,width,.5)
		canvas.DrawImage(botImg, x, bottom,0,width,.5)
		canvas.DrawImage(leftImg,lft,y,0,.5,height)
		canvas.DrawImage(rightImg,right,y,0,.5,height)
		canvas.DrawImage(areaImg,x,y,0,width,height)
		canvas.Color = oldColor
		
	End Method

End Class

