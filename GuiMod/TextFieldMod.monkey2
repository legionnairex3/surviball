
#Import "<mojo>"
#Import "GuiMod"

Using mojo..

Class PPoint
	Field x:Float
	Field y:Float
End Class


Class TextField
	Field x:Int
	Field y:Int
	Field pos:PPoint
	Field text:String
	Field maxChars:Int
	Field cursorx:Int
	Field textImg:Image
	
	Field blink			:Int
	Field delay			:Int
	Field time			:Int
	
	Method New(x:Float,y:Float,txt:String,maxChr:Int,txtImg:Image=Null,p:PPoint= Null,blinkDelay:Int = 200)
		If p = Null
			pos = New PPoint
			pos.x = x
			pos.y = y
			Self.x = 0
			Self.y = 0
		Else
			Self.pos = p
			Self.x = x
			Self.y = y
			
		Endif
		Self.maxChars = maxChr
		If txtImg = Null
			RuntimeError("fix this line")
'			Self.textImg = GetFont()
		Else
			Self.textImg = txtImg
		Endif
		Self.delay = blinkDelay
		Self.time = Millisecs()
		Self.text = txt
		If text.Length > maxChr text = text.Left(maxChr)
		cursorx = text.Length
	End Method
	
	Method SetFont:Void(image:Image)
		textImg = image
	End Method
	
	Method GetPixelWidth:Int()
		Return (maxChars+1)*textImg.Width
	End Method
	
	Method GetText:String()
		Return text
	End Method
	
	Method Update:Void()
		RuntimeError("fix this ")
		Local chr:Int = Keyboard.GetChar()
		If chr
			Select chr
				Case Key.Tab
				Case Key.Backspace 'CHAR_BACKSPACE
					If cursorx > 0
						text = text.Left(cursorx-1)+text.Right(cursorx)
						cursorx -= 1
					Endif
				Case Key.Enter 'CHAR_ENTER

				Case Key.Escape 'CHAR_ESCAPE
				
				Case Key.PageUp 'CHAR_PAGEUP
					cursorx = 0
				Case Key.PageDown 'CHAR_PAGEDOWN
					cursorx = text.Length
				Case Key.KeyEnd 'CHAR_END
					cursorx = text.Length
				Case Key.Home 'CHAR_HOME
					cursorx = 0
				Case Key.Left 'CHAR_LEFT
					If cursorx > 0 
						cursorx -= 1
					Endif
				Case Key.Up 'CHAR_UP
				Case Key.Right 'CHAR_RIGHT
					If cursorx < text.Length
						cursorx += 1
					Endif
				Case Key.Down 'CHAR_DOWN
				Case Key.Insert 'CHAR_INSERT
				Case Key.Backspace 'CHAR_DELETE
					If cursorx < text.Length
							text = text.Left(cursorx)+text.Right(cursorx+1)
					Endif				
				Default
					If text.Length< maxChars
						RuntimeError(" fix this line")
						text = text.Left(cursorx)+String.FromChar(chr)+text.Right(cursorx)'****************************************
						cursorx +=1
					Endif	
			End Select
		Endif
		
		If Millisecs() > time+delay
			blink = Not blink
			time = Millisecs()
		Endif

	End Method

	Method Render:Void(canvas:Canvas)
		canvas.DrawText(text,pos.x+x,pos.y+y)
		If blink
			canvas.DrawRect(pos.x+x+cursorx*textImg.Width,pos.y+y+textImg.Height,8,3)
		Endif
	End Method
		

End Class

