
#Import "<mojo>"

Global LargeText:VaryFont

Class VaryFont
	Field fontImg:Image[]
	
	Const COUNT:Int = 94
	
						
	Global param:Int[][] = New Int[][](New Int[]( 12,355,29,45),New int[]( 41,355,29,30),New Int[]( 70,355,29,47),New Int[](100,355,24,47),New Int[](128,355,29,47),New Int[](157,355,30,47),
						   New Int[](193,355,15,28),New Int[](222,355,19,48),New Int[](247,355,19,48),New Int[](276,355,22,32),New Int[](302,355,28,39),New Int[](337,355,16,49),
						   New Int[](363,355,23,34),New Int[](394,355,16,44),New int[](419,355,25,44),New int[](447,355,28,44),New int[](477,355,26,44),New int[](506,355,25,44),
						   New Int[](536,355,24,44),New int[](563,355,27,44),New int[](593,355,25,44),New int[](622,355,27,44),New int[](651,355,26,44),New int[](679,355,27,44),
						   New int[](708,355,26,44),New int[](744,355,15,44),New int[](773,355,15,51),New int[](796,355,25,38),New int[](825,355,26,38),New int[](855,355,24,38),
						   New int[](885,355,23,44),New int[](910,355,30,47),New int[](939,355,31,44),New int[](970,355,27,44),New int[]( 12,403,27,44),New int[]( 42,403,27,44),
						   New int[]( 72,403,24,44),New int[](100,403,25,44),New int[](128,403,27,44),New int[](158,403,26,44),New int[](189,403,23,44),New int[](216,403,23,44),
						   New Int[](245,403,29,44),New Int[](275,403,25,44),New Int[](302,403,27,44),New Int[](332,403,27,44),New Int[](360,403,27,44),New Int[](391,403,26,44),
						   New Int[](417,403,29,46),New Int[](448,403,28,44),New Int[](477,403,25,44),New Int[](505,403,29,44),New Int[](535,403,26,44),New Int[](562,403,30,44),
						   New Int[](591,403,30,44),New Int[](621,403,29,44),New Int[](650,403,28,44),New Int[](680,403,27,44),New Int[](714,403,20,47),New Int[](739,403,24,44),
						   New Int[](768,403,19,47),New Int[](794,403,29,26),New Int[](822,426,32,48),New Int[](857,403,18,20),New Int[](883,403,26,44),New Int[](912,403,27,44),
						   New Int[](940,403,25,44),New Int[](970,403,26,44),New Int[]( 12,449,27,44),New Int[]( 43,449,24,44),New Int[]( 71,449,26,49),New Int[](100,449,26,44),
						   New Int[](131,449,18,44),New Int[](159,449,20,49),New Int[](187,449,27,44),New Int[](217,449,24,44),New Int[](245,449,28,44),New Int[](274,449,26,44),
						   New Int[](303,449,27,44),New Int[](332,449,26,49),New Int[](361,449,26,49),New Int[](392,449,24,44),New Int[](421,449,24,44),New Int[](450,449,24,44),
						   New Int[](479,449,24,44),New Int[](506,449,26,44),New Int[](534,449,29,44),New Int[](563,449,27,44),New Int[](592,449,27,49),New Int[](622,449,25,44),
						   New Int[](654,449,21,48),New Int[](686,449,13,48),New Int[](711,449,21,48),New Int[](735,449,31,34))


	Method New(image:Image)
		fontImg = New Image[COUNT]
		For Local i:Int = 0 Until COUNT
			fontImg[i] = New Image(image,param[i][0],param[i][1],param[i][2],param[i][3])
		Next
	End Method
	
	Method TextWidth:Int(str:String)
		Local l:Int= 0	
		For Local n:Int = Eachin str
			Local i:Int = GetIndex(n)
			If i > -1
				l += param[i][2]
			Else
				l += 20
			Endif
		Next
		Return l
	End Method
	
	Method TextHeight:Int(str:String)
		Local l:Int = 0
		If str > 0
			l = param[0][3]
		Endif
		Return l
	End Method

	Method GetIndex:Int(n:Int)
			If n >32 And n < 128 Then Return n-33
			Return -1
	End Method	

	Method Draw:Void(canvas:Canvas,str:String,x:Float,y:Float)
		If str.Length = 0 Return
		For Local n:Int = Eachin str
			Local i:Int = GetIndex(n)
			If i > -1
				canvas.DrawImage(fontImg[i],x,y)
				x += param[i][2]
			Else
				x += 20
			Endif
		Next
	End Method

End Class