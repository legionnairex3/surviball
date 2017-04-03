#Import "<mojo>"
#Import "<std>"
#Import "MouseMod"
#Import "ButtonMod"
#Import "bitmapFont"
#Import "varyFontMod"
#Import "FrameAnimMod"
#Import "TextFieldMod"
'#Import "GetNameGuiMod"
#Import "FrameMod"
'#Import "TextBoxMod"
#Import "FontMod"

#Import "data/frame.png"

Using mojo..
Using std..

Global __atlas:Image

Function GetAtlas:Image()
	If __atlas = Null
		__atlas = Image.Load("asset::frame.png")
		If __atlas = Null RuntimeError("Unable to load frame.png")
	Endif
	Return __atlas
End Function


Function CombineColors:Int(r:Int,g:Int,b:Int)
		Return (r & $FF) Shl 16 | (g & $FF) Shl 8 | (b & $FF)
End Function


Function SetColor:Color(c:Int)
	Return New Color( ((c Shr 16) & $FF)/255.0,((c Shr 8) & $FF)/255.0, (c & $FF)/255.0)
End Function

Function SetColor:Color(r:Int,g:Int,b:Int)	
	Return New Color(r/255.0,g/255.0,b/255.0)
End Function

