
#Import "<mojo>"
#Import "GuiMod"

Using mojo..

Class TextFieldGui
	Field x				:Int
	Field y				:Int
	Field pos			:Point
	Field textField		:TextField
	Field text			:String
	Field cancelBtn		:Button
	Field okBtn			:Button
	Field image			:Image
	
	Method New(x:Int,y:Int,txt:String,p:Point = Null,blinkDelay:Int = 200)
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
		Endif
		RuntimeError("fix this 4 lines")
'		Self.image = media.getNameImg
'		Self.cancelBtn = New Button(media.smallBtnImg,50,110,"Cancel",pos)
'		Self.okBtn = New Button(media.smallBtnImg,200,110,"Ok",pos)
'		Self.textField = New TextField(30,72,txt,15,Null,pos,blinkDelay)
		
	End Method
	
	Method GetText:String()
		Return textField.GetText()
	End Method
	
	Method Update:Int()
		textField.Update()
		cancelBtn.Update()
		okBtn.Update()
		Select True
			Case cancelBtn.GetState()
				Return -1
			Case okBtn.GetState()
				If textField.GetText() = ""
					Return 1
				Endif
				Return 0
		End Select
		Return 1
	End Method
	
	Method Render:Void(canvas:Canvas)
		canvas.DrawImage(image,pos.x+x,pos.y+y)
		textField.Render(canvas)
		cancelBtn.Render(canvas)
		okBtn.Render(canvas)	
	End Method
	
End Class
			
