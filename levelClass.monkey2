Import mojo
Import JPMod.GuiMod
Import JPMod.FontMod

Class LevelState
	Field unlocked:Bool
	Field timeLimit:Int
	
	Field timeSpend:Int
	Field coinsObtained:Int
	Field score:Int

	Field frame:FrameMod.Frame
	Field textBox:TexBox
	Field textBoxTxt:String
	
	
	
End Class

Class GameState
	Field x:Int
	Field y:Int
	Field width:Int
	Field height:Int
	Field btnState:Int
	Field btnWidth:Int
	Field btnHeight:Int
	Field spaceWidth:Int
	Field spaceHeight:Int
	Field defaultColor:Int
	Field overColor:Int
	Field colorState:Int

	Field spacedAcross:Int
	Field spacedDown:Int

	Field buttonImg:Image
	Field frameImg:Image
	Field currentLevel:Int

	Field frame:FrameMod.Frame
	Field textBoxTxt:String


	Field status:LevelState[][]
	
	Method New(atlasImg:Image)
		x = 50
		y = 50
		width  = 420
		height = 400
		btnWidth= 34
		btnHeight = 52
		spacedAcross = 41
		spacedDown  = 60
		defaultColor = $dddddd
		overColor    = $ffffff
		buttonImg	 = atlasImg.GrabImage(571,588,btnWidth,btnHeight,2)	
		frameImg	 = atlasImg.GrabImage(465,596,8,8,13)
		status = New LevelState[5][]
		For Local i:Int = 0 Until status.Length()
			status[i] = New LevelState[8]
			For Local j:Int = 0 Until status[i].Length()
				status[i][j] = New LevelState
			Next
		Next
		status[0][0].unlocked = True
		frame = New FrameMod.Frame(50,200,200,100,$a0a0a0)
		
	End Method
	
	Method SetScore:Void(level:Int,scor:Int)
		Local px:Int = level Mod 8
		Local py:Int = level / 8
		If status[py][px].score < scor
			status[py][px].score = scor
		Endif
	End Method

	Method Update:Int()
		colorState = -1
		Local px:Int = MouseX() - (x-8)
		Local py:Int = MouseY() - (y-8)
		Local mx:Int = px Mod spacedAcross
		Local my:Int = py Mod spacedDown
		If mx > 8 And my > 8
			px = px/spacedAcross
			py = py/spacedDown
			If px < 8 And py < 5
				colorState = py Shl 8 + px
				If TouchDown()
					If status[py][px].unlocked = True
						currentLevel = py * 8 + px
						Return currentLevel
					Endif
				Endif
			Endif
		Endif
		Return -1
	End Method
	
	Method unlockLevel:Void(level:Int)
			If level > = 40 Return
			currentLevel = level			
			Local py:Int = currentLevel / 8
			Local px:Int = currentLevel Mod 8
			status[py][px].unlocked = True
	End Method

	Method Render:Int()
		Local renderFrame:Int = False
		For Local i:Int= 0 Until status.Length() 
			For Local j:Int = 0 Until status[i].Length()
				mojo.SetColor (defaultColor Shr 16) & $FF,(defaultColor Shr 8) & $FF, defaultColor & $FF
				If colorState <> -1
					Local px:Int = colorState & $FF
					Local py:Int = (colorState Shr 8) & $FF
					If px = j And py = i
						mojo.SetColor overColor Shr 16 & $FF,overColor Shr 8 & $FF, overColor & $FF
						If status[py][px].unlocked = True
							renderFrame = True
						Endif
					Endif
				Endif 
				DrawImage buttonImg,x+(j*spacedAcross),y+(i*spacedDown),status[i][j].unlocked
			Next
		Next
		mojo.SetColor 255,255,255
		DrawImage frameImg,42,42,9
		DrawImage frameImg,50,42,0,(Float(spacedAcross)/frameImg.Width()*8),1,11
		DrawImage frameImg,42+spacedAcross*8,y-8,12
		DrawImage frameImg,50,42+spacedDown*5,0,(Float(spacedAcross)/frameImg.Width()*8),1,6
		DrawImage frameImg,42,50,0,1,(Float(spacedDown)/frameImg.Height()*5),4
		DrawImage frameImg,42,42+spacedDown*5,5
		DrawImage frameImg,42+spacedAcross*8,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*8,42+spacedDown*5,8
		DrawImage frameImg,42+spacedAcross*1,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*2,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*3,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*4,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*5,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*6,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,42+spacedAcross*7,y,0,1,(Float(spacedDown)/frameImg.Height()*5),2
		DrawImage frameImg,50,42+spacedDown*1,0,(Float(spacedAcross)/frameImg.Width()*8),1,6
		DrawImage frameImg,50,42+spacedDown*2,0,(Float(spacedAcross)/frameImg.Width()*8),1,6
		DrawImage frameImg,50,42+spacedDown*3,0,(Float(spacedAcross)/frameImg.Width()*8),1,6
		DrawImage frameImg,50,42+spacedDown*4,0,(Float(spacedAcross)/frameImg.Width()*8),1,6
		For Local i:Int = 1 To 4
			For Local j:Int = 1 To 7
				DrawImage frameImg,42+j*spacedAcross,42+i*spacedDown,0
			Next
		Next
		For Local i:Int = 1 To 7
			DrawImage frameImg,42+i*spacedAcross,42,10
		Next		
		For Local i:Int = 1 To 4
			DrawImage frameImg,42,42+i*spacedDown,3
		Next		
		For Local i:Int = 1 To 4
			DrawImage frameImg,42+8*spacedAcross,42+i*spacedDown,1
		Next		

		For Local i:Int = 1 To 7
			DrawImage frameImg,42+i*spacedAcross,42+spacedDown*5,7
		Next
		
		If renderFrame = True
			SetAlpha .9
			mojo.SetColor 255,0,255
			frame.Render()
			Local py:Int = colorState/8
			Local px:Int = colorState Mod 8
			SetAlpha 1.0
			mojo.SetColor 255,255,0
			DrawText colorState,10,150
			Scale .5,1
			RenderText "Leader Score",(frame.x)*2,frame.y+5
			RenderText status[py][px].score,(frame.x+150)*2,frame.y+5
			RenderText "Time Limit",frame.x*2,frame.y+30
			RenderText status[py][px].timeLimit,(frame.x+150)*2,frame.y+30
			SetAlpha 1.0
				
		Endif
		Return True
	End Method

End Class