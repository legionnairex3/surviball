Import mojo

Class SwipeController
	Field px:Int
	Field py:Int
	Field posx:Float
	Field posy:Float
	Field state:Int
	Field oldState
	Field dx:Int
	Field dy:Int
	Field pos:Int[800]
	Field length:Int
	
	Const ACTIVE:Int = 1
	
	Method New()
	End Method
	
	
	
	Method SwipeUpdate:Void()
		px = TouchX()
		py = TouchY()
		state = TouchDown()
		
		If oldState = False
			If state = True
				length:Int = 0
				pos[length]   = px
				pos[length+1] = py
			Endif
		Elseif state = True
			If length < 798
				posx = px
				posy = py
				If pos[length] <> px Or pos[length+1] <> py
					length += 2
					pos[length] = px
					pos[length+1] = py
				Endif
			Endif
		Else
			length = -1
		Endif
		oldState = state
	End Method

	Method Render()
		If length >= 0
			If length = 0
				DrawCircle pos[length],pos[length+1],1.5
			Else
				For Local i:Int = 2 To length Step 2
					DrawLine_PL(pos[i-2],pos[i-1],pos[i],pos[i+1])
				Next
			Endif
		Endif
	End Method
	
End Class


Function DrawLine_PL:Void(XPos#,YPos#,XPos2#,YPos2#,Thickness#=3,roundedEnds:Int=True)
	Local vx:Float = Xpos2 - Xpos
	Local vy:Float = Ypos2 - Ypos
	Local angle:Float=ATan2(vy,vx)
	Local c:Float = Cos(angle)
	Local s:Float = Sin(angle)
	Local LineLength:Float = c*vx+s*vy
	Local cl:Float = LineLength*c
	Local sl:Float = LineLength*s
	Local r:Float = Thickness/2.0
	Local sr:Float = s*r
	Local cr:Float = c*r
	'Left Top Coords
	Coords[0]=XPos+sr
	Coords[1]=YPos-cr
	'Right Top Coords
	Coords[2]=cl+XPos+sr
	Coords[3]=sl+YPos-cr
	'Right Down Coords
	Coords[4]=cl-sr+XPos
	Coords[5]=sl+cr+YPos
	'Left Down Coords
	Coords[6]=XPos-sr
	Coords[7]=YPos+cr
	DrawPoly(Coords)	
	If roundedEnds = True	
		DrawCircle(XPos,YPos,r)
		DrawCircle(XPos2,YPos2,r)
	Endif
End Function
