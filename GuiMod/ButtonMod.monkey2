#Import "GuiMod"

Class Button
	Field pos:Point
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	Field text:String
	Field offx:Float
	Field offy:Float
	Field activated:Int
	Field selected:Int
	Field oldDown:Int
	Field image:Image[]
	

	Method New(img:Image[],x:Int,y:Int,str:String,p:Point=Null)
		If p = Null
			Self.pos = New Point
			Self.pos.x = x
			Self.pos.y = y
			Self.x = 0
			Self.y = 0
		Else
			pos = p
			Self.x = x
			Self.y = y
		End If
		Self.text = str
		Self.width = img[0].Width
		Self.height = img[0].Height
		Self.offx = offx
		Self.offy = offy
		Self.image = img
		Self.SetText(str)
	End Method
	
	Method SetText:Void(str:String)
		text = str
		If text.Length > 0
			Local w:Int = str.Length*Text.CharWidth()
			offx = (image[0].Width - w)/2.0
			Local h:Int = image[0].Height - Text.CharHeight()
			offy = h/2.0
		Endif
	End Method
	
	Method Update:Void()
		Local thisDown := Mouse.ButtonDown(MouseButton.Left)
		If thisDown
			If Not oldDown And inArea()
				selected = True
			Endif
		Elseif oldDown
			If selected = True
				If activated = False
					If inArea()
						activated = True
						selected = False
					Else
						selected = False
					Endif
				Endif
			Elseif activated
				activated = False
			Endif
		Endif
		oldDown = thisDown
	End Method
	
	Method GetState:Int()
		Local state:Int = activated
		activated = False
		Return state
	End Method

	Method inArea:Int()
		Local tx := Mouse.X
		Local ty := Mouse.Y
		If tx < pos.x+x Return False
		If ty < pos.y+y Return False
		If tx > pos.x+x+width Return False
		If ty > pos.y+y+height Return False
		Return True	
	End Method

	Method Render:Void(canvas:Canvas)
		Local index:Int = 0
		If selected Or inArea() Then index = 1
		canvas.Color = New Color(1,1,1) ' 255,255,255
		canvas.DrawImage(image[index],pos.x+x,pos.y+y)
		If text.Length > 0
			Text.Draw(canvas,text,pos.x+x+offx+index,pos.y+y+offy+index)	
		Endif
	End Method


End Class
