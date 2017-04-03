

#Import "<mojo>"
#Import "<std>"


#Import "char"
#Import "kernpair"

Using mojo..
Using std..
Private 
Global __Afont:AngelFont
Public
Function SetAFont:Void(url:String)
		If __Afont = Null
			__Afont = New AngelFont()
		Endif
		__Afont.italicSkew = 0.15
		__Afont.LoadFont(url)
End Function

Function RenderText:Void(canvas:Canvas,txt:String,x:Float,y:Float)
	__Afont.RenderText(canvas,txt,x,y)
End Function

Class AngelFont
	Private
	
	Global _list:StringMap<AngelFont> = New StringMap<AngelFont>
	
	Field image:Image	
'	Field blockSize:Int
	Field chars:Char[] = New Char[256]
	Field kernPairs:StringMap<KernPair> = New StringMap<KernPair>
'	Field section:String
	Field iniText:String

	Field xOffset:Int
	Field yOffset:Int
	
	Field prevMouseDown:Bool = False

	Public
	Const ALIGN_LEFT:Int = 0
	Const ALIGN_CENTER:Int = 1
	Const ALIGN_RIGHT:Int = 2
	
	Global current:AngelFont
	Global error:String
	
	Field name:String
	Field useKerning:Bool = True

	Field lineGap:Int = 5
	Field height:Int = 0
	Field heightOffset:Int = 9999
	Field scrollY:Int = 0
	
	Field italicSkew:Float = 0.25
	
	Method New(url:String="")
		If url <> ""
			Self.LoadFont(url)
			Self.name = url
			_list.Set(url,Self)
		Endif
	End Method
	Method GetChars:Char[]()
		Return chars
	End

	Method LoadFont:Void(url:String)
		
		error = ""
		current = Self
		iniText = LoadString(AssetsDir()+url+".txt")
		If iniText = Null  RuntimeError("unable to load "+ AssetsDir()+url+".txt")
		Local lines:= iniText.Split(String.FromChar(10))
		For Local line:= Eachin lines
			line=line.Trim()
			If line.StartsWith("id,") Or line = "" Continue
			If line.StartsWith("first,")
				kernPairs = New StringMap<KernPair>
				Continue
			Endif
			Local data:String[] = line.Split(",")
			
			For Local i:=0 Until data.Length
				data[i]=data[i].Trim()
			Next
			error += data.Length+","
			If data.Length > 0
				If data.Length = 3
					kernPairs.Set(String.FromChar(Int(data[0]))+"_"+String.FromChar(Int(data[1])), New KernPair(Int(data[0]), Int(data[1]), Int(data[2])))
				Elseif data.Length >= 8
					chars[Int(data[0])] = New Char(Int(data[1]), Int(data[2]), Int(data[3]), Int(data[4]),  Int(data[5]),  Int(data[6]),  Int(data[7]))
					Local ch := chars[Int(data[0])]
					If ch.height > Self.height Self.height = ch.height
					If ch.yOffset < Self.heightOffset Self.heightOffset = ch.yOffset
					ch.asc = Int(data[0])
				Endif
			Endif
		Next
		
		image = Image.Load("asset::"+url+".png")
	End Method
	
	Method Use:Void()
		current = Self
	End Method
	
	Function GetCurrent:AngelFont()
		Return current
	End
	
	Function Use:AngelFont(name:String)
		For Local af := Eachin _list
			If af.Value.name = name
				current = af.Value
				Return af.Value
			End
		Next
		Return Null
	End
	
	Method RenderItalic:Void(canvas:Canvas,txt:String,x:Float,y:float)
		Local th:Float=TextHeight(txt)
		
		canvas.PushMatrix()
			RuntimeError("fix this")
			'canvas.Transform(1,0,-italicSkew,1, x+th*italicSkew,y)
			RenderText(canvas,txt,0,0)
		canvas.PopMatrix()
	End 
	
	Method RenderBold:Void(canvas:Canvas,txt:String, x:Int, y:Int)
		RenderText(canvas,txt, x,y)
		RenderText(canvas,txt, x+1,y)
	End
	
	
	Method RenderText:Void(canvas:Canvas,txt:String, x:Int, y:Int)
		Local prevChar:String = ""
		xOffset = 0
		
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			Local thisChar:String = String.FromChar(asc)
			If ac  <> Null
				If useKerning
					Local key:String = prevChar+"_"+thisChar
					If kernPairs.Contains(key)
						xOffset += kernPairs.Get(key).amount
					Endif
				Endif
				ac.Render(canvas,image, x+xOffset,y)
				xOffset += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
	End Method
	
	Method RenderText:Void(canvas:Canvas,txt:String, x:Int, y:Int, align:Int)
		xOffset = 0
		Select align
			Case ALIGN_CENTER
				RuntimeError(" fix this")
				RenderText(canvas,txt,x-(TextWidth(txt)/2),y)
			Case ALIGN_RIGHT
				RuntimeError("fix this")
				RenderText(canvas,txt,x-TextWidth(txt),y)
			Case ALIGN_LEFT
				RuntimeError("fix this")
				RenderText(canvas,txt,x,y)
		End Select
	End Method

	Method RenderHTML:Void(canvas:Canvas,txt:String, x:Int, y:Int)
		Local prevChar:String = ""
		xOffset = 0
		Local italic:Bool = False
		Local bold:Bool = False
		Local th:float=TextHeight(txt)
		
		For Local i:= 0 Until txt.Length
			While txt.Right(i).Left(1) = "<" 'txt[i..i+1] = "<"
				Select txt.Right(i+1).Left(3) 'txt[i+1..i+3]
					Case "i>"
						italic = True
						i += 3
					Case "b>"
						bold = True
						i += 3
					Default
						Select txt.Right(i+1).Left(4) 'txt[i+1..i+4]
							Case "/i>"
								italic = False
								i += 4
							Case "/b>"
								bold = False
								i += 4
						End
				End
				If i >= txt.Length
					Return
				End
			Wend
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			Local thisChar:String = String.FromChar(asc)
			If ac  <> Null
				If useKerning
					Local key:String = prevChar+"_"+thisChar
					If kernPairs.Contains(key)
						xOffset += kernPairs.Get(key).amount
					Endif
				Endif
				If italic = False
					ac.Render(canvas,image, x+xOffset,y)
					If bold
						ac.Render(canvas,image, x+xOffset+1,y)
					End
				Else
					canvas.PushMatrix()
					RuntimeError("fix this")
					'canvas.Transform(1,0,-italicSkew,1, (x+xOffset)+th*italicSkew,y)
						ac.Render(canvas,image, 0,0)
						If bold
							ac.Render(canvas,image, 1,0)
						Endif					
					canvas.PopMatrix()
				End	
				xOffset += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
	End Method
	
	Method RenderHTML:Void(canvas:Canvas,txt:String, x:Int, y:Int, align:Int)
		xOffset = 0
		Select align
			Case ALIGN_CENTER
				RenderHTML(canvas,txt,x-(TextWidth(StripHTML(txt))/2),y)
			Case ALIGN_RIGHT
				RenderHTML(canvas,txt,x-TextWidth(StripHTML(txt)),y)
			Case ALIGN_LEFT
			Default
				RenderHTML(canvas,txt,x,y)
		End Select
	End Method
	
	Function StripHTML:String(txt:String)
		Local plainText:String = txt.Replace("</","<")
		plainText = plainText.Replace("<b>","")
		Return plainText.Replace("<i>","")
	End

	Method TextWidth:Int(txt:String)
		Local prevChar:String = ""
		Local width:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			Local thisChar:String = String.FromChar(asc)
			If ac  <> Null
				If useKerning
					Local key:String = prevChar+"_"+thisChar
					If kernPairs.Contains(key)
						width += kernPairs.Get(key).amount
					Endif
				Endif
				width += ac.xAdvance
				prevChar = thisChar
			Endif
		Next
		Return width
	End Method
	
	Method TextHeight:Int(txt:String)
		Local h:Int = 0
		For Local i:= 0 Until txt.Length
			Local asc:Int = txt[i]
			Local ac:Char = chars[asc]
			If ac.height > h h = ac.height
		Next
		Return h
	End

End Class
