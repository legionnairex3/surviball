
#Import "<mojo>"
#Import "FontMod"

Class TextBox
	Global lineGap:Int = 5
	
	Global yOffset:Int = 0
	
	Global font:AngelFont
	
	Global align:Int = AngelFont.ALIGN_LEFT
		
	Function Render:Void(canvas:Canvas,text:String, x:Int, y:Int, width:Int, alignment:Int = AngelFont.ALIGN_LEFT)	
		Local thisLine:String = ""
		Local charOffset:Int = 0
		
		Local wordLen:Int = 0
		Local word:String = ""
		
		font = AngelFont.current
		align = alignment
		
		yOffset = 0
		For Local i := 0 Until text.Length
			RuntimeError("fix this for app width")
			'If y+yOffset > app.View.Width
			'	Return
			'Endif		
		
			Local asc:Int = text[i]
			Select asc
				Case 32	' space
					wordLen = font.current.TextWidth(word)
					If charOffset + wordLen > width
						RenderTextLine(canvas,thisLine, x,y+yOffset)
						thisLine = ""
						charOffset = 0
					Endif
					charOffset += wordLen+font.GetChars()[32].xAdvance
					thisLine += word + " "
					
					word = ""
				Case 10' newline
					wordLen = font.TextWidth(word)
					If charOffset + wordLen > width
						RenderTextLine(canvas,thisLine, x,y+yOffset)
						thisLine = ""
					Endif
					thisLine += word
				
					RenderTextLine(canvas,thisLine, x,y+yOffset)

					thisLine = ""
					charOffset = 0
					word = ""
				Default
					Local ch:Char = font.GetChars()[asc]
					word += String.FromChar(asc)
			End Select
		Next

		If word <> ""
			wordLen = font.TextWidth(word)
			If charOffset + wordLen > width
				RenderTextLine(canvas,thisLine, x,y+yOffset)
				thisLine = ""
			Endif
			thisLine += word
		Endif
		If thisLine <> ""
			RenderTextLine(canvas,thisLine, x,y+yOffset)
		Endif
	End
	
	Function RenderHTML:Void(canvas:Canvas,text:String, x:Int, y:Int, width:Int, alignment:Int = AngelFont.ALIGN_LEFT)	
		Local thisLine:String = ""
		Local charOffset:Int = 0
		
		Local wordLen:Int = 0
		Local word:String = ""
		
		font = AngelFont.current
		align = alignment
		
		yOffset = 0
		For Local i := 0 Until text.Length
			RuntimeError("fix this for the app height")
			'If y+yOffset > App.Height
			'	Return
			'Endif		
		
			Local asc:Int = text[i]
			Select asc
				Case 32	' space
					wordLen = font.current.TextWidth(AngelFont.StripHTML(word))
					If charOffset + wordLen > width
						RenderTextLineHTML(canvas,thisLine, x,y+yOffset)
						thisLine = ""
						charOffset = 0
					Endif
					charOffset += wordLen+font.GetChars()[32].xAdvance
					thisLine += word + " "
					
					word = ""
				Case 10	' newline
					wordLen = font.TextWidth(AngelFont.StripHTML(word))
					If charOffset + wordLen > width
						RenderTextLineHTML(canvas,thisLine, x,y+yOffset)
						thisLine = ""
					Endif
					thisLine += word
				
					RenderTextLineHTML(canvas,thisLine, x,y+yOffset)

					thisLine = ""
					charOffset = 0
					word = ""
				Case 60	' <
					If text.Right(i+1).Left(i+3) = "i>" Or text.Right(i+1).Left(i+3) 'text[i+1..i+3] = "i>" Or text[i+1..i+3] = "b>"
						word += text.Right(i).Left(i+3) 'text[i..i+3]
						i += 2
					Else
						If text.Right(i+1).Left(i+4) = "/i>" Or text.Right(i+1).Left(i+4) 'text[i+1..i+4] = "/i>" Or text[i+1..i+4] = "/b>"
							word += text.Right(i).Left(i+4) 'text[i..i+4]
							i += 3
						End
					End
				Default
					Local ch:Char = font.GetChars()[asc]
					word += String.FromChar(asc)
			End Select
		Next

		If word <> ""
			wordLen = font.TextWidth(AngelFont.StripHTML(word))
			If charOffset + wordLen > width
				RenderTextLine(canvas,thisLine, x,y)
				thisLine = ""
			Endif
			thisLine += word
		Endif
		If thisLine <> ""
			RenderTextLineHTML(canvas,thisLine, x,y)
		Endif
	End
	
	Function RenderTextLine:Void(canvas:Canvas,txt:String, x:Int,y:Int)
		font.RenderText(canvas,txt, x,y, align)
		yOffset += lineGap+font.height
	End
	
	Function RenderTextLineHTML:Void(canvas:Canvas,txt:String, x:Int,y:Int)
		font.RenderHTML(canvas,txt, x,y, align)
		yOffset += lineGap+font.height
	End


End Class

