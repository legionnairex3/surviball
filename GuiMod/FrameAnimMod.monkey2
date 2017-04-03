
#Import "<mojo>"
#Import "GuiMod"

Class FrameAnimation

	Field x					:Float
	Field y					:Float
	
	Field px				:Int
	Field py				:Int
	
	Field width				:Int
	Field height			:Int
	
	Field delay				:Int
	Field currentWidth		:Int
	Field currentHeight		:Int
	
	Field stp				:Int
	Field time				:Int
	
	Field animating			:Int
	
	Field frameTopImg		:Image
	Field frameBotImg		:Image
	Field topImg			:Image
	Field botImg			:Image
	Field lrImg				:Image[]
	Field rectImg			:Image
	
	Method New(x:Int,y:Int,width:Int,height:Int,delay:Int = 2,stp:Int = 40)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.delay = delay
		Self.currentWidth = 1
		Self.currentHeight = 1
		Self.stp = stp
'		Self.frameTopImg = media.frameTopImg '*************
'		Self.frameBotImg = media.frameBotImg '*************
'		Self.topImg =      media.topImg '******************
'		Self.botImg =      media.botImg '******************
'		Self.lrImg =       media.lrImg '*******************
'		Self.rectImg =	   media.rectImg '*****************
	End Method
	
	Method Init:Void()
		animating = True
		currentWidth = 1
		currentHeight = 1
		px = x+width/2
		py = y+height/2
		time = Millisecs()
	End Method
	
	Method Update:Int()
		If animating = True
			If Millisecs() > time+delay
				currentWidth += stp		
				currentHeight += stp
				px -= stp/2
				py -= stp/2
				If currentWidth > width  Then 
					currentWidth = width 
					px = x
				Endif
				If currentHeight > height Then 
					currentHeight = height 
					py = y
				Endif
				If currentHeight = height And currentWidth = width 
					animating = False
				Endif
				time = Millisecs()
			Endif
		Endif
		Return animating
		
	End Method
		 

	Method Render:Void(canvas:Canvas)

		Local tw:Int = 4
		Local th:Int = 4
		Local fx:Float = px-tw
		Local fy:Float = py-th
		
		canvas.DrawImage(frameTopImg,fx,fy,0)
		canvas.DrawImage(topImg,fx+tw,fy,0,currentWidth,1)
		canvas.DrawImage(frameTopImg,fx+currentWidth+tw,fy,1)
		
		canvas.DrawImage(lrImg[0],fx,fy+th,0,1,currentHeight)
		canvas.DrawImage(lrImg[1],fx+tw+currentWidth,fy+th,0,1,currentHeight)
		
		canvas.DrawImage(frameBotImg,fx,fy+th+currentHeight,0)
		canvas.DrawImage(botImg,fx+tw,fy+th+currentHeight,0,currentWidth,1)
		canvas.DrawImage(frameBotImg,fx+tw+currentWidth,fy+th+currentHeight,1)
		canvas.DrawImage(rectImg,px,py,0,currentWidth,currentHeight)
	End Method

End Class