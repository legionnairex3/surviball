
#Import "<mojo>"

'Global Mouse:cMouse

Class cMouse
	Field x:Float
	Field y:Float
	Field down:Int
	Field hit:Int
	
	Method Update:Void()
		x = Touch.FingerX(0)
		y = Touch.FingerY(0)
		down = Touch.FingerPressed(0)
		hit	= Touch.FingerDown(0)
	End Method
	
End Class
