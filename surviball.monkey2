#Import "<mojo>"
#Import "<std>"
#Import "Gmenu"

using mojo..
Using std..

#Import "data/tiles2.png"
#Import "data/hit03.ogg"
#Import "data/hit04.ogg"
#Import "data/hit05.ogg"
#Import "data/hit06.ogg"
#Import "data/shoot.ogg"
#Import "data/bank01.ogg"
#Import "data/bank02.ogg"
#Import "data/rackup.ogg"
#Import "data/applause.ogg"
#Import "data/pocket1.ogg"
#Import "data/fail2.wav"
#Import "data/fail.ogg"
#Import "data/completion.ogg"
#Import "data/beep.ogg"
#Import "data/beep2.ogg"
#Import "data/coin2.ogg"
#Import "data/a1.ogg"
#Import "data/b1.ogg"
#Import "data/c1.ogg"
#Import "data/d1.ogg"
#Import "data/e1.ogg"
#Import "data/f1.ogg"
#Import "data/g1.ogg"
#Import "data/i1.ogg"
#Import "data/pop.wav"

#Import "data/casual.txt"
#Import "data/casual.png"

Global game:Game
Global level:Level
Global across:Float
Global down:Float

' Last iteration's tick value
Global gLastTick:Int
' Level start tick
Global levelStartTick:Int

' Collectibles
Global CollectibleList:List<Collectible> = New List<Collectible>
Global trapDoorList:List<TrapDoor> = New List<TrapDoor>
Global voltList:List<Volt> = New List<Volt>
Global flameList:List<FireStream> = New List<FireStream>
Global turretList:List<Turret> = New List<Turret>
Global bulletList:List<Particle> = New List<Particle>
Global bulletStore:PartStore

Global camera:Camera

Global gTiles:Image[]
Global starsImg:Image[]
Global sparkHImg:Image[]
Global sparkVImg:Image[]
Global ballImg:Image[]
Global squishHImg:Image[]
Global squishVImg:Image[]
Global spikeImg:Image[]
Global ballMainImg:Image
Global ball:Ball
Global music:Sound[]
Global score:Score
Global flameImg:Image
Global turretImg:Image[]
Global bulletImg:Image[]

Global chimeSnd:Sound
Global failSnd:Sound
Global electricSnd:Sound
Global coinSnd:Sound
Global popSnd:Sound
Global electricChannel:Channel = New Channel
Global soundChannel:Channel[]
Global channelIndex:Int
Global musicChannel:Channel

'*********************************************************
'					Constants
'*********************************************************

' Screen pitch
Const CAMERAWIDTH:Int = 500
' Screen height
Const CAMERAHEIGHT:Int = 400
' Tile size (width And height)
Const TILESIZE:Int = 32

' How many seconds does the player have To solve the level
Const TIMELIMIT:Int = 10

' Physics iterations per second
Const PHYSICSFPS:Int =  100

' TILE references

'empty tile
Const  LEVEL_DROP:Int 			= 0
'goals
Const  LEVEL_END:Int 			= 1
Const  LEVEL_START:Int 			= 2
'floor walls
Const  LEVEL_WALL:Int 			= 3
'floor type
Const  LEVEL_SMOOTH:Int 		= 7
Const  LEVEL_ROUGH:Int 			= 8
Const  LEVEL_GROUND:Int 		= 9
'moving floor
Const  LEVEL_UP:Int 			= 10
Const  LEVEL_RIGHT:Int 			= 14
Const  LEVEL_DOWN:Int 			= 18
Const  LEVEL_LEFT:Int 			= 22
'diagonal floors
Const  LEVEL_DIAG_LT:int		= 30
Const  LEVEL_DIAG_RT:Int		= 31
Const  LEVEL_DIAG_RB:Int		= 32
Const  LEVEL_DIAG_LB:Int		= 33
'floor curve out
Const  LEVEL_left_top:Int 		= 34
Const  LEVEL_right_top:Int 		= 35
Const  LEVEL_left_bottom:Int 	= 36
Const  LEVEL_right_bottom:Int 	= 37
'floor curve in
Const  LEVEL_RIGHT_top:Int 		= 38
Const  LEVEL_LEFT_top:Int 		= 39
Const  LEVEL_RIGHT_bottom:Int 	= 40
Const  LEVEL_LEFT_bottom:Int 	= 41

Const LEVEL_TURRET:Int 			= 42
' tesla tower
Const  LEVEL_TESLA:Int 			= 43

Const LEVEL_FRAMESOLO:Int		= 44
Const LEVEL_FRAMEENDT:Int		= 45
Const LEVEL_FRAMEENDL:Int		= 46
Const LEVEL_FRAMEENDB:Int		= 47
Const LEVEL_FRAMEENDR:Int		= 48

Const LEVEL_FRAMELTC:Int		= 49
Const LEVEL_FRAMERTC:Int		= 50
Const LEVEL_FRAMEBLC:Int		= 51
Const LEVEL_FRAMEBRC:Int		= 52

Const LEVEL_FRAMEBT:Int			= 53
Const LEVEL_FRAMELR:Int			= 54

Const LEVEL_CONTACTC:Int		= 55
Const LEVEL_CONTACTL:Int		= 56
Const LEVEL_CONTACTT:Int		= 57
Const LEVEL_CONTACTR:Int		= 58
Const LEVEL_CONTACTB:Int		= 59
'corner walls
Const  LEVEL_RIGHT_BOTTOM:Int 	= 70 
Const  LEVEL_LEFT_BOTTOM:Int 	= 71
Const  LEVEL_RIGHT_TOP:Int 		= 72
Const  LEVEL_LEFT_TOP:Int 		= 73

Const  LEVEL_TRAP_DOOR:Int 		= 26
Const  LEVEL_FLAMEL:Int			= 28
Const  LEVEL_FLAMER:Int			= 29
Const  LEVEL_COLLECTIBLE:Int 	= 80
Const  LEVEL_SPARKH:Int 		= 81
Const  LEVEL_SPARKV:Int 		= 82
Const  LEVEL_HSMASHER:Int		= 60
Const  LEVEL_VSMASHER:Int		= 64
Const  LEVEL_SPIKE:Int			= 88
Const  LEVEL_COLLECTIBLE2:Int	= 90

' Tile collision directions
Const  COLLIDE_N:Int  			= $01
Const  COLLIDE_NW:Int 			= $02
Const  COLLIDE_W:Int  			= $04
Const  COLLIDE_SW:Int 			= $08
Const  COLLIDE_S:Int  			= $10
Const  COLLIDE_SE:Int 			= $20
Const  COLLIDE_E:Int  			= $40
Const  COLLIDE_NE:Int 			= $80

' Game states
Const  STATE_NONE:Int			=  0
Const  STATE_LEVELSTART	:Int	=  1
Const  STATE_ENTRY:Int 			=  2
Const  STATE_READY:Int 			=  3
Const  STATE_INGAME:Int 		=  4
Const  STATE_FALLOFF:Int 		=  5
Const  STATE_EXPLODE:Int 		=  6
Const  STATE_ENDLEVEL:Int 		=  7
Const  STATE_INMENU:Int			=  8
Const  STATE_ENDGAME:Int		= 10
Const  STATE_GAMESTART:int		= 11
Const  STATE_GAMELOST:Int		= 12


Class TPoint
	Field x:Float
	Field y:Float
End Class

Class Surviball Extends Window
	Field font:AngelFont

	Method New( title:String="Simple mojo app",width:Int=CAMERAWIDTH,height:Int=CAMERAHEIGHT,flags:WindowFlags=Null )
		
		Super.New( title,width,height,flags )
		
		game = New Game()
		
		'SetMusicVolume(1.0)
	End Method
		
	Method OnRender(canvas:Canvas) Override
		game.update()

		App.RequestRender()
		game.Render(canvas)
	End Method
	
End Class

Class Game
	Field nextState:Int
	Field state:Int
	Field startTick:Int
	Field foScale:Float
	Field eScale:Float
	Field fox:Float
	Field foy:Float
	Field tick:Float
	Field explosion:Explosion
	Field vortex:Vortex
	Field menu:Menu
	Field frame:Frame
	Field secondsLeft:Float
	
	Global image:Image
	
	
	Method Reset:Void()
		level.Load()
		ball.reset()	
		ball.posx = ball.startx
		ball.posy = ball.starty
		camera.reset()
		gLastTick = Millisecs() 
		levelStartTick = Millisecs()

	End Method

	Method New()
		vortex = New Vortex
		level = New Level()
		camera = New Camera()
		CollectibleList.Clear()
		level.init()
		nextState = STATE_INMENU
		image = Image.Load("asset::tiles2.png")
		gTiles = LoadFrames(image,0,0,32,32,100)
		starsImg = LoadFrames(image,0,128,32,32,8)
		If starsImg = Null Print "invalid image"
		sparkVImg = LoadFrames(image,448,120,32,8,4)
		sparkHImg = LoadFrames(image,608,96,8,32,4)
		squishHImg = LoadFrames(image,0,96,32,32,4)
		squishVImg = LoadFrames(image,128,96,32,32,4)
		spikeImg = LoadFrames(image,256,128,32,32,4)
		ballImg = LoadFrames(image,448,116,4,4,36)
		flameImg = New Image(image,480,128,16,16)
		flameImg.Handle = New Vec2f(.5,.5)
		ballMainImg = New Image(image,570,562,24,24)
		ballMainImg.Handle = New Vec2f(.5,.5)
		turretImg = LoadFrames(image,0,608,32,32,3)
		turretImg[0].Handle = New Vec2f(.25,.5)
		turretImg[1].Handle = New Vec2f(.25,.5)
		turretImg[2].Handle = New Vec2f(.25,.5)
		bulletImg = LoadFrames(image,0,600,8,8,1)
		bulletImg[0].Handle = New Vec2f(.25,.5)
		bulletStore = New PartStore(bulletImg)
		explosion = New Explosion
		music = New Sound[20]
		music[0] = Sound.Load("asset::a1.ogg")
		music[1] = music[0]
		music[2] = Sound.Load("asset::b1.ogg")
		music[3] = music[2]
		music[4] = music[2]
		music[5] = Sound.Load("asset::c1.ogg")
		music[6] = music[5]
		music[7] = music[5]
		music[8] = Sound.Load("asset::d1.ogg")
		music[9] = music[8]
		music[10] = music[8]
		music[11] = music[8]
		music[12] = music[8]
		music[13] = Sound.Load("asset::e1.ogg")
		music[14] = Sound.Load("asset::f1.ogg")
		music[15] = music[13]
		music[16] = music[13]
		music[17] = Sound.Load("asset::g1.ogg")
		music[18] = music[17]
		music[19] = Sound.Load("asset::i1.ogg")
		musicChannel = New Channel
		failSnd = Sound.Load("asset::fail.ogg")
		popSnd = Sound.Load("asset::pop.ogg")
		If failSnd = Null RuntimeError("unable to load failSnd")
		chimeSnd = Sound.Load("asset::chime.ogg")
		electricSnd = Sound.Load("asset::electric2.ogg")
		coinSnd = Sound.Load("asset::coin2.ogg")
		electricChannel = New Channel
		soundChannel = New Channel[16]
		For Local i:Int = 0 Until 16
			soundChannel[i] = New Channel
		next
		score = New Score
		ball  = New Ball
		ball.init()
		menu = New Menu(image,100,200)
		Collectible.image = gTiles
		SetAFont("casual")
		frame = New Frame(75,50,350,300,$ccccdf)
	End Method
	
	Method changestate:Void()
	
		' Things that need To be done when leaving a state
	    If state = STATE_ENDLEVEL 
	        level.currentLevel +=1
			If level.currentLevel > 10
				nextState = STATE_ENDGAME
			Endif
	    End If
		If nextState = STATE_ENDLEVEL
			For Local b:Particle = Eachin bulletList
				b.link.Remove()
				bulletStore.replace(b)
			Next
		Endif
	
	    ' Switch state
	    state = nextState
	
	    ' Things that need To be done when entering a state
	    Select (state)
		    Case STATE_LEVELSTART
		        Reset()
				musicChannel.Play(music[level.currentLevel],True)
		    Case STATE_INGAME
		        gLastTick = Millisecs() 
		        levelStartTick = Millisecs() 
	    End Select
	    startTick = Millisecs()
	End Method

	Method update:Void()
		Mouse.Update()
		If game.nextState <> game.state
			game.changestate()
		Endif
		' get the time in milliseconds
		tick = Millisecs()
		vortex.Update()
		Select state
			Case STATE_INMENU
				If menu.Update() = False
					game.nextState = STATE_GAMESTART
					score.totalPoints = 0
					score.gamePoints = 0 
				Endif
			Case STATE_GAMESTART
				If Mouse.ButtonPressed(MouseButton.Left) Or Keyboard.KeyPressed(Key.Space) Or Keyboard.KeyPressed(Key.Enter)
					level.currentLevel = 0
					game.nextState = STATE_LEVELSTART
					score.lives = 10
				Endif
			Case STATE_ENDGAME
				If Mouse.ButtonPressed(MouseButton.Left) Or Keyboard.KeyPressed(Key.Space) Or Keyboard.KeyPressed(Key.Enter)
					game.nextState = STATE_INMENU
					musicChannel.Stop()
				Endif
			Case STATE_GAMELOST
				If Mouse.ButtonPressed(MouseButton.Left) Or Keyboard.KeyPressed(Key.Space) Or Keyboard.KeyPressed(Key.Enter)
					game.nextState = STATE_INMENU
					musicChannel.Stop()
				Endif
				
			Case STATE_LEVELSTART
				If Mouse.ButtonPressed(MouseButton.Left) Or Keyboard.KeyPressed(Key.Space) Or Keyboard.KeyPressed(Key.Enter)
					game.nextState = STATE_ENTRY
				Endif
			Case STATE_INGAME
				secondsLeft = level.levelTime - (gLastTick - levelStartTick) / 1000
				If (secondsLeft < 0) 
					secondsLeft = 0
					explosion.init(ball.posx,ball.posy)
					game.nextState = STATE_EXPLODE
					soundChannel[channelIndex].Play(popSnd)
					channelIndex = (channelIndex + 1) Mod 16
					score.lives -= 1
				Endif
				ball.ProcessInput(Int(Keyboard.KeyDown(Key.Right))-Int(Keyboard.KeyDown(Key.Left)),
								  Int(Keyboard.KeyDown(Key.Down))-Int(Keyboard.KeyDown(Key.Up)))
				While (gLastTick < tick)					
					nextState = ball.Update(nextState)
					Collectible.collision()
					gLastTick += 1500 / PHYSICSFPS
				Wend
				If nextState = STATE_ENDLEVEL
					score.secondsSpend = (gLastTick - levelStartTick) / 1000.0
					score.secondsRemaining = level.levelTime - score.secondsSpend
					If score.secondsRemaining < 0 score.secondsRemaining = 0
					score.bonus = Int(String(score.secondsRemaining * 100).Right(5))
					score.coinPoints = Collectible.Taken * 50
					score.totalPoints = score.coinPoints + score.bonus
					score.gamePoints += score.totalPoints
				Endif
			Case STATE_FALLOFF
				foScale = (tick - startTick) / 1000.0
				If (foScale > 1) 
					foScale = 1
					If score.lives = 0
						nextState = STATE_GAMELOST
					Else
						nextState = STATE_LEVELSTART
						musicChannel.Play(music[level.currentLevel],True)
					Endif
				Endif
				foScale = 1.0 - foScale
				foScale = foScale * foScale
				
				fox = Int(CAMERAWIDTH - CAMERAWIDTH * ((CAMERAWIDTH / 2) - camera.x) / (level.levelWidth * TILESIZE))
				foy = Int(CAMERAHEIGHT - CAMERAHEIGHT * ((CAMERAHEIGHT / 2) - camera.y) / (level.levelHeight * TILESIZE))
			Case STATE_EXPLODE
				If explosion.list.Empty = False
					If explosion.update() = False
						If score.lives = 0
							nextState = STATE_GAMELOST
						Else
							nextState = STATE_LEVELSTART
							musicChannel.Play(music[level.currentLevel],True)
						Endif
					Endif
				Endif
			Case STATE_ENTRY
				eScale = (tick - startTick) / 1000.0
				If (eScale > 1) 
					eScale = 1
					nextState = STATE_READY
				Endif
				eScale = 1.0 - eScale
			Case STATE_ENDLEVEL
				If Mouse.ButtonPressed(MouseButton.Left) Or Keyboard.KeyPressed(Key.Enter) Or Keyboard.KeyPressed(Key.Space)
				 	musicChannel.Stop()
					game.nextState = STATE_LEVELSTART
				Endif
		End Select
		If state<> STATE_INMENU And state <> STATE_LEVELSTART
		
			For Local f:FireStream = Eachin flameList
				f.Update()
			Next
			For Local t:Turret = Eachin turretList
				t.Update()
			Next
			
			For Local b:Particle = Eachin bulletList
				If b.Update() = False
					b.link.Remove()
					bulletStore.replace(b)
				Endif
			Next
			For Local t:TrapDoor = Eachin trapDoorList
				If t.dropped() = False
					t.update()
					If t.dropped() = True
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 16
						game.nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Next
			If state <> STATE_EXPLODE
				For Local v:Volt = Eachin voltList
					If v.collided() = True
						explosion.init(ball.posx,ball.posy)
						game.nextState = STATE_EXPLODE
						soundChannel[channelIndex].Play(popSnd)
						channelIndex = (channelIndex + 1) Mod 16
						score.lives -= 1
					Endif
				Next
			Endif
			If state <> STATE_EXPLODE And state<> STATE_FALLOFF
				For Local f:FireStream = Eachin flameList
					If f.Collided() = True
						explosion.init(ball.posx,ball.posy)
						game.nextState = STATE_EXPLODE
						soundChannel[channelIndex].Play(popSnd)
						channelIndex = (channelIndex + 1) Mod 16
						score.lives -= 1
					Endif	
				Next
			Endif
			If state <> STATE_EXPLODE
				For Local b:Particle = Eachin bulletList
					If b.Collided() = True
						explosion.init(ball.posx,ball.posy)
						game.nextState = STATE_EXPLODE
						soundChannel[channelIndex].Play(popSnd)
						channelIndex = (channelIndex + 1) Mod 16
						score.lives -= 1
						Exit
					Endif
				Next
				If game.nextState = STATE_EXPLODE
					For Local b:Particle = Eachin bulletList
						b.link.Remove()
						bulletStore.replace(b)
					Next
				Endif
			Endif
			For Local v:Volt = Eachin voltList
				v.Update()
			Next

		Endif
		

	End Method
	
	
	Method collide:Void()
	
	End Method

	Method Render:Void(canvas:Canvas)
		vortex.Render(canvas)
		canvas.Color = new Color( 1,1,1)' 255,255,255)
		If (state = STATE_FALLOFF)
			ball.Render(canvas,(fox * (1 - foScale) + camera.x) * foScale,(foy * (1 - foScale) + camera.y * foScale),(ball.RADIUS * foScale),0, 0)
		Endif

		If state<> STATE_INMENU And state <> STATE_LEVELSTART And state <> STATE_GAMESTART And state <> STATE_ENDGAME
			level.Render(canvas)
			For Local t:TrapDoor = Eachin trapDoorList
				t.Render(canvas)
			Next
	
			For Local c:Collectible  = Eachin CollectibleList
				c.Render(canvas)
			Next
			
			For Local v:Volt = Eachin voltList
				v.Render(canvas)
			Next
			For Local f:FireStream = Eachin flameList
				f.Render(canvas)
			Next
			
			For Local t:Turret = Eachin turretList
				t.Render(canvas)
			Next
			
		Endif
		

		' draw status strin
		Select state
			Case STATE_INMENU
				menu.Render(canvas)
				canvas.Scale( 0.7,0.7)
				canvas.Color = new Color(1,1,0) ' 255,255,0)
				RenderText(canvas,"Music by Kevin MacLeod - incompetech.com",10,440)
			Default
				Select state
					Case STATE_GAMESTART
						frame.Render(canvas)
						canvas.Color = new Color(.4,.4,.4) '100,100,100)
						RenderText(canvas," INSTRUCTIONS",140,50)
						canvas.Color = new Color( .2,.2,1) '50,50,255)
						canvas.PushMatrix()
						canvas.Scale( .5,.5)
						RenderText(canvas,"Use arrows to move ball in the direction desired.",160,200)
						RenderText(canvas,"Reach destination before time expires to pass",160,250)
						RenderText(canvas,"Level.",160,300)
						RenderText(canvas,"Avoid obstacles and falling over.",160,350)
						RenderText(canvas,"          GoodLuck!",250,500)
						canvas.Color = new Color(1,0,0) ' 255,0,0)
						RenderText(canvas,"  Press SPACE or ENTER to start.",250,600)
						canvas.PopMatrix()
					Case STATE_INGAME
						ball.Render(canvas,camera.x, camera.y,ball.RADIUS,ball.gRoll*3, ATan2(ball.rolly, ball.rollx))
						For Local b:Particle = Eachin bulletList
							b.Render(canvas)
						Next
						ball.gRoll = 0
						canvas.Scale( .7,.7)
						canvas.Color = new Color(1,1,0)' 255,255,0)
						RenderText(canvas,"Coins: "+Collectible.Taken,5,10)
						RenderText(canvas,"Score: "+(score.gamePoints),350,10)
						RenderText(canvas,"Time Left: " + secondsLeft,5,40)
						RenderText(canvas,"Lives : "+ score.lives,5,70)
					Case STATE_ENDGAME
						frame.Render(canvas)
						RenderText(canvas,"GAME WON",170,80)
						canvas.Color = new Color(0,0,1) ' 0,0,255)
						RenderText(canvas,score.totalPoints,200,160)
						canvas.PushMatrix()
						canvas.Scale( .8,.8)
						canvas.Color = new Color(.7,0,0) ' 180,0,0)
						RenderText(canvas,"FINAL SCORE!",220,300) 
						canvas.PopMatrix()
						canvas.PushMatrix()
						canvas.Scale( .5,.5)
						canvas.Color = new Color(.8,.0,.8) '200,0,200)
						RenderText(canvas,"Press SPACE Or ENTER To Continue",260,600)
					Case STATE_ENTRY
						canvas.PushMatrix()
						canvas.Scale( .7,.7)
						canvas.Color = new Color(1,1,0) ' 255,255,0)
						RenderText(canvas,"SCORE: "+(score.gamePoints),450,10)
						canvas.PopMatrix()
						ball.Render(canvas,camera.x, camera.y,ball.RADIUS,ball.gRoll*3, ATan2(ball.rolly, ball.rollx))
						ball.gRoll = 0
						Local pscale:Float = eScale * eScale
						ball.Render(canvas,camera.x,camera.y,ball.RADIUS + pscale * 200,0.4 * eScale, eScale * Pi)
						canvas.Color = new Color( 1,1,0)'255,255,0) 
						RenderText(canvas,"Get ready!",200,140) 
					Case STATE_READY
						canvas.PushMatrix()
						canvas.Scale( .7,.7)
						canvas.Color = new Color( 1,1,0) '255,255,0)
						RenderText(canvas,"SCORE: "+score.gamePoints,450,10)
						canvas.PopMatrix()
						ball.Render(canvas,camera.x, camera.y,ball.RADIUS,ball.gRoll*3, ATan2(ball.rolly, ball.rollx))
						ball.gRoll = 0
						canvas.Color = new Color(0,1,0) '0,255,0)
						RenderText(canvas,"Go!",230,160) 
						If (tick - startTick > 500) nextState = STATE_INGAME
					Case STATE_FALLOFF
						canvas.Color = new Color(1,0,0) ' 255,0,0)
						RenderText(canvas,"Fall off!",200,140)
					Case STATE_EXPLODE
						explosion.Render(canvas)
					Case STATE_LEVELSTART
						frame.Render(canvas)
						canvas.Color = new Color(.4,.4,.4) ' 100,100,100)
						RenderText(canvas,"Level Name",100,80)
						RenderText(canvas,"Time Limit",100,160)
						canvas.PushMatrix()
						canvas.Scale( .8,.8)
						canvas.Color = new Color(.8,0,0) ' 200,0,0)
						RenderText(canvas,level.levelName,150,150)
						RenderText(canvas,level.levelTime+" Seconds",150,260)
						canvas.Color = new Color(.4,.2,.3) ' 100,50,80)
						RenderText(canvas,"Lives: " + score.lives,120,320)
						canvas.Color = new Color(.2,.2,.8) ' 50,50,200)
						RenderText(canvas,"Pres Space or Return To Start.",100,400)
						canvas.PopMatrix()
					Case STATE_GAMELOST
						frame.Render(canvas)
						canvas.Color = new Color(.7,0,0) ' 180,0,0)
						RenderText(canvas,"GAME LOST", 170,80)
						canvas.Color = new Color(0,0,1) ' 0,0,255)
						RenderText(canvas,score.totalPoints,200,160)
						canvas.PushMatrix()
						canvas.Scale( .8,.8)
						canvas.Color = new Color(.7,0,0) ' 180,0,0)
						RenderText(canvas,"FINAL SCORE!",220,300) 
						canvas.PopMatrix()
						canvas.PushMatrix()
						canvas.Scale( .5,.50)
						canvas.Color = new Color(.8,0,.8) ' 200,0,200)
						RenderText(canvas,"Press SPACE Or ENTER To Continue",260,600)
					Case STATE_ENDLEVEL
						canvas.PushMatrix()
						canvas.Scale( .7,.7)
						canvas.Color = new Color(1,1,0) ' 255,255,0)
						RenderText(canvas,"SCORE: "+(score.gamePoints),450,10)
						canvas.PopMatrix()
						canvas.Alpha = .9
						frame.Render(canvas)
						canvas.Alpha = 1.0
						Local eventpos:Int = tick - startTick
						Local temp:String
						canvas.PushMatrix()
						canvas.Scale( .8,.8)
						canvas.Color = new Color(1,1,0)' 255,255,0)
						RenderText(canvas,"Level Finished!",220,80)
						canvas.Color = new Color(0,0,1) ' 0,0,255)
						canvas.Scale( .7,.8)
						If (eventpos > 500)
							RenderText(canvas,"Time Spent: "+String(score.secondsSpend).Left(5)+" Seconds",190,180)
							If (eventpos > 1000)
								RenderText(canvas,"Time Left: " + String(score.secondsRemaining).Left(5) + " X 100",190,240)
								RenderText(canvas," = " +  score.bonus+" Bonus",520,240)
								If (eventpos > 1500)
									RenderText(canvas,"Coins: "+ Collectible.Taken +" X 50",190, 300)
									RenderText(canvas," = "+ score.coinPoints+" Points",520, 300)
									If (eventpos > 2000)
										RenderText(canvas,"______________________",190,330)
										canvas.Color = New Color(0,1,0) ' 0,255,0)
										RenderText(canvas,"Level Total ",190,380)
										RenderText(canvas," = " + score.totalPoints + " Points",520,380)
									
									Endif
								Endif
							Endif
						Endif
						canvas.Scale( 1.0,1.0)
						canvas.PopMatrix()
						canvas.Scale( .8,.8)
						canvas.Color = new Color(.6,.2,.2) ' 150,50,50)
						RenderText(canvas,"Hit space/Enter for next level!",90,360) 
						canvas.Scale( 1.0,1.0)
				End Select
		End Select
	End Method

End Class

Function Main()

	New AppInstance
	
	New Surviball
	
	App.Run()
	
End

'*********************************************************
		'vertex copy
'*********************************************************

Function memcpy:List<Vertex>(destList:List<Vertex>, sourceList:List<Vertex>)
		For Local source:Vertex = Eachin sourceList 
			Local dest:Vertex = New Vertex()
			dest.x = source.x
			dest.y = source.y
			dest.z = source.z
			destList.AddLast(dest)
		Next
		Return destList
End Function 

Class Vortex
	Field cyl:Point[][]
	     
	Field slicex:Int[][]
	Field slicey:Int[][]
	Field mnv:Float
	Field mn:Int 
	Field gadd:Float
	Field rings:Int

	Method New()
		rings = 26
		cyl = New Point[ 17][]
		slicex = New Int[17][]
		slicey = New Int[17][]
		For Local i:Int = 0 Until 17
			cyl[i] = New Point[rings]
			slicex[i] = New Int[rings]
			slicey[i] = New Int[rings]
		Next
		Local d1:Float[] = New Float[17], d2:Float[] = New FLoat[17]
		For Local i:Int = 0 Until 17
			d1[i] = Cos((TwoPi/16.0)*i)
			d2[i] = Sin((TwoPi/16.0)*i)
		Next
		
	    For Local i:Int =0 To 16
			 cyl[i][0] = New Point
			 cyl[i][0].x = d1[i] * 2500
			 cyl[i][0].y = d2[i] * 2500
		Next
		Local ps:Float = rings
		For Local M:Int = 0 Until rings
	        For Local L:Int=0 To 16
				If cyl[L][M] = Null cyl[L][M] = New Point
				cyl[L][M].z = ps 
				If M>0 Then	
					cyl[L][M].x = cyl[L][0].x
					cyl[L][M].y = cyl[L][0].y
				Endif
	        Next
	        ps = ps - 1
		Next
	End Method
	
	Method Update:Void()
		gadd=gadd + 0.15
		Local YO:Float,XO:Float
		Local hw:Int = CAMERAWIDTH/2
		Local hh:Int = CAMERAHEIGHT/2
		For Local k:Int=0 To rings-1
			XO=CAMERAWIDTH *(Cos((((k+gadd)-mnv)*90*Pi/180.0)/9))
			YO=CAMERAHEIGHT*(Sin((((k+gadd)-mnv)*90*Pi/180.0)/8))
			For Local j:Int=0 To 16
				slicex[j][k] = (cyl[j][k].x+XO) / (cyl[j][k].z+mnv) + hw
				slicey[j][k] = (cyl[j][k].y+YO) / (cyl[j][k].z+mnv) + hh            
			Next
		Next
		mnv=mnv - 0.20
		If mnv<0.0 Then mnv=mnv+4.0
	End Method
	
	Method Render:Void(canvas:Canvas)
		Local MD:Int = 0
		For Local k:Int= 1 To (rings -2)
			For Local j:Int= 0 To 15 Step 2
				If MD=0 Then
					'blue
					DrawQuad(canvas,slicex[j  ][k], slicey[j  ][k], slicex[j  ][k+1], slicey[j  ][k+1], slicex[j+1][k+1], slicey[j+1][k+1], slicex[j+1][k  ], slicey[j+1][k  ], k*4.0, k, k*12.0)
'					DrawQuad(canvas,slicex[j+1][k], slicey[j+1][k], slicex[j+1][k+1], slicey[j+1][k+1], slicex[j+2][k+1], slicey[j+2][k+1], slicex[j+2][k  ], slicey[j+2][k  ], k*8.0, k, k     )
				Else
					'red
'					DrawQuad(canvas,slicex[j  ][k], slicey[j  ][k], slicex[j+1][  k], slicey[j+1][k  ], slicex[j+1][k+1], slicey[j+1][k+1], slicex[j  ][k+1], slicey[j  ][k+1], k,k,k*8.0)					
					DrawQuad(canvas,slicex[j+1][k], slicey[j+1][k], slicex[j+2][  k], slicey[j+2][k  ], slicex[j+2][k+1], slicey[j+2][k+1], slicex[j+1][k+1], slicey[j+1][k+1], k*12.0,k,k)
				End If
			Next
			MD=1-MD
		Next
	
	End Method
	
	Method DrawQuad:Void(canvas:Canvas,x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int,x4:Int,y4:Int, r:Int, g:Int, b:Int)
	    Local p:Float[] = New FLoat[8]
		p[0] = x1
		p[1] = y1
		p[2] = x2
		p[3] = y2
		p[4] = x3
		p[5] = y3
		p[6] = x4
		p[7] = y4
		canvas.Color = new Color( r/255.0,g/255.0,b/255.0)
		canvas.DrawPoly(p)
	End Method
	
End Class
'*********************************************************
'			Vertext Structure
'			for ball dots
'*********************************************************

Class Vertex
	
	Field x:Float
	Field y:Float
	Field z:Float
	
	Method New()
	End Method
	
	Method New(x:Float,y:Float,z:Float)
		Self.x = x
		Self.y = y
		Self.z = z
		Local length:Float = Sqrt(Self.x * Self.x +Self.y * Self.y + Self.z * Self.z)
		'makes it aprox. 1 unit from center of ball
		If (length <> 0)
			Self.x /= length
			Self.y /= length
			Self.z /= length
		Endif
	End Method
	
End Class

Class Point
	Field x:Float
	Field y:Float
	Field z:Float
End Class
'******************************************************
'
'			graphics functions
'
'******************************************************

Function DrawCircle(canvas:Canvas,x:Int, y:Int, r:Int, c:Int)
	canvas.Color = new Color( ((c Shr 16) & $FF)/255.0, ((c Shr 8) & $FF)/255.0, (c & $FF)/255.0)	
	canvas.DrawOval(x-r,y-r,r*2,r*2)
End Function

'**********************************************************
'		particle object
'**********************************************************
Class Particle
	Field x:Float
	Field y:Float
	Field dx:Float
	Field dy:Float
	Field angle:Float
	Field speed:Float
	Field image:Image[]
	Field index:Int
	Field alpha:Float
	Field link:List<Particle>.Node
	
	Method New(x:Float,y:Float,angle:Float,speed:Float,image:Image[]=Null,index:Int = 0)
		Self.x = x
		Self.y = y
		Self.angle = angle
		Self.dx = Cos(angle*Pi/180.0)*speed
		Self.dy = Sin(angle*Pi/180.0)*speed
		Self.image = image
		Self.index = index
	End Method
	
	Method init(x:Float,y:Float,ang:Float,speed:Float,indx:int=-1)
		Self.x = x
		Self.y = y
		If indx > -1
			Self.index = indx
		Endif
		Self.dx = Cos(ang*Pi/180.0)*speed
		Self.dy = Sin(ang*Pi/180.0)*speed
		Self.alpha = 0.50
		Self.angle = ang
	End Method
	
	Method init2(x:Float,y:Float,ang:Float,speed:Float,indx:int=-1)
		Self.x = x
		Self.y = y
		If indx > -1
			Self.index = indx
		Endif
		Self.dx = Cos(ang*Pi/180.0)*speed
		Self.dy = Sin(ang*Pi/180.0)*speed
		Self.alpha = 1.0
		Self.angle = ang
	End Method

	Method update:Int()
		x += dx
		y += dy
		alpha -= .05
		If alpha <= 0
			Return False
		Endif
		Return True
	End Method
	
	Method Update:Int()
		x += dx
		y += dy
		alpha -= .005
		If alpha <= 0.1
			alpha = 1.0
			Return False
		Endif
		Return True
	End Method
	
	Method Collided:Int()
		Local vx:Float = ball.posx - x
		Local vy:Float = ball.posy - y
		If (vx*vx+vy*vy) < (ball.RADIUS*ball.RADIUS)
			Return True
		Endif
		Return False
	End Method
	
	Method Render(canvas:Canvas)
		If image = Null
			canvas.Alpha = alpha
			canvas.Color = new Color(0,0,1) ' 0,0,255)
			canvas.DrawLine(camera.x+x-3,camera.y+y,camera.x+x+3,camera.y+y)
			canvas.Color = new Color(1,1,0) ' 255,255,0)
			canvas.DrawLine(camera.x+x,camera.y+y-3,camera.x+x,camera.y+y+3)
			canvas.Alpha = 1.0
		Else
			canvas.Alpha = alpha
			canvas.DrawImage(image[index],camera.x+x-16,camera.y+y-16)
		Endif
	End Method
	
	Method Render1(canvas:Canvas)
		If image = Null
			canvas.Color = new Color(0,0,1) ' 0,0,255)
			canvas.DrawLine(camera.x+x-3,camera.y+y,camera.x+x+3,camera.y+y)
			canvas.Color = new Color(1,1,0) ' 255,255,0)
			canvas.DrawLine(camera.x+x,camera.y+y-3,camera.x+x,camera.y+y+3)
		Else
			canvas.DrawImage( image[index],x-16,y-16)
		Endif
	End Method
	
End Class


'**********************************************************
'		Particle Store
'**********************************************************

Class PartStore
	Field list:List<Particle>
	Field image:Image[]
	Field x:Float
	Field y:Float
	Field speed:Float
	Field angle:Float
	
	Method New(image:Image[])
		Self.list = New List<Particle>
		Self.image = image
		Self.x = 0
		Self.y = 0
		Self.speed = 0
		Self.angle = 0
		Self.fill(100)
	End Method
	
	Method fill:Void(total:Int)
		For Local i:Int = 0 Until total
			list.AddLast(New Particle(x,y,angle,speed,image))
		Next
	End Method
	
	Method get:Particle()
		If Not list.Empty
			Return list.RemoveLast()
		Endif
		Return New Particle(x,y,angle,speed,image)
	End Method
	
	Method replace:Void(particle:Particle)
		list.AddLast(particle)
	End Method
	
End Class



Class Explosion
		Field x:Float
		Field y:Float
		Field list:List<Particle>
		Field count:Int
		Field angle:Int
		Field stp:Int
		Field maxParticles:Int
		Field store:PartStore
		Field delay:Int

		Method New()
			list = New List<Particle>
			count= 0
			maxParticles = 38
			stp = 15 ' rotation in degrees
			store = New PartStore(ballImg)
			delay = 20 ' millisecos
		End Method
		
		Method init(x:Int,y:Int)
			Self.x = x
			Self.y = y
			Local i:Int = 0
			For Local px:Int = 0 Until 6
				For Local py:Int = 0 Until 6
					angle = Rnd(TwoPi)
					Local p:Particle = store.get()
					p.init(x+px*4,y+py*4,angle,Rnd(2,4),i)
					p.alpha = 1.0
					p.link = list.AddLast(p)
					i += 1
				Next
			Next
		End Method
		
		Method update:Int()
			For Local p:Particle = Eachin list
				If p.update() = False
					 p.link.Remove()
					 store.replace(p)
				Endif
			Next
			If list.Empty
				Return False
			Endif
			Return True
		End Method
		
		Method Render:Void(canvas:Canvas)
			For Local p:Particle = Eachin list
				p.Render(canvas)
			Next
			canvas.Alpha = 1.0
		End Method

End Class

Class TrapDoor
	Field x:Float
	Field y:Float
	Field image:Image[]
	Field firstFrame:Int
	Field lastFrame:Int
	Field index:Int
	Field delayTime:Int
	Field delay:Int
	Field active:Int
	Field open:Int
	
	Method New(x:Float,y:Float,image:Image[],first:Int,last:Int,index:Int,delay:Int=80)
		Self.x = x 
		Self.y = y
		Self.image = image
		Self.firstFrame = first
		Self.lastFrame = last
		Self.index = index
		Self.delay = delay
		Self.active = False
		Self.open = False
	End Method
	
	Method update:Void()
		If open = False
			If active = True
				If index < lastFrame
					If Millisecs() > delayTime
						index += 1 
						If index = lastFrame
							open = True
							active = False
						Else
							delayTime = delay+Millisecs()
						Endif
					Endif
				Endif
			Endif
		Endif
	End Method

	Method dropped:Int()
		If (Sqrt((x+16 - ball.posx) * (x+16 - ball.posx) +(y+16 - ball.posy) * (y+16 - ball.posy)) < ball.RADIUS+4)
			If open = True
				Return True
			Else
				If active = False
					active = True
					delayTime = delay+Millisecs()
				Endif
			Endif
		Endif
		Return False
	End Method
	
	Method Render(canvas:Canvas)
		canvas.DrawImage(image[index],x+camera.x,y+camera.y)
	End Method
	
End Class

'**********************************************************

'			ball object: physics and graphics

'**********************************************************

Class Ball
	' Player's position
	Field posx:Float
	Field posy:Float
	
	' Player's motion vector
	Field movx:Float
	Field movy:Float
	
	' Player's start position
	Field startx:Float
	Field starty:Float
	
	' Player's roll vector
	Field rollx:Float
	Field rolly:Float
	
	' Player's ball's roll value
	Field gRoll:Float

	Field ballMoving:Int
	Field count:Int
	
	
	' Player's key status
	Field mapWidth:Int
	Field mapHeight:Int
	
	' Original vertices
	Field gVtxList:List<Vertex>

	' Transformed vertices
	Field gRVtxList:List<Vertex>
	
	' Player's score
	' Particles
	Field partStore:PartStore
	Field particleList:List<Particle>
	
	' Player's thrust value
	Const THRUST:Float = 0.2
	' Color of player's ball
	Const BALLCOLOR:Int = $003fbf
	' Color of player's ball's foreground dots
	Const BALLHICOLOR:Int = $ffffff
	' Color of player's ball's background dots
	Const BALLLOCOLOR:Int = $7f7fff
	' Number of vertices in the ball
	Const BALLVTXCOUNT:Int = 6
	' Radius of the player's ball
	Const RADIUS:Int = 12
	
	' Sliding tile thrust power
	Const SLIDEPOWER:Float = 0.04
	' Slowdown due To friction, etc.
	Const SLOWDOWN:Float = 0.99
	' Slowdown due To rough tile
	Const SLOWDOWNROUGH:Float = 0.95
	' Slowdown due To collision
	Const COLLISIONSLOWDOWN:Float = 0.9

	
	Method init()
	End Method

	Method reset()
		movx = 0
		movy = 0
		rollx = 0
		rolly = 0
		gRoll = 0
		
	End Method

	Method New()
		gVtxList = New List<Vertex>
		gRVtxList = New List<Vertex>
		For Local i:Int = 0 Until BALLVTXCOUNT
			Local gVtx:Vertex = New Vertex(Rnd(32768) - 16384.0,Rnd(32768) - 16384.0,Rnd(32768) - 16384.0)
			gVtxList.AddLast(gVtx)
		Next
		memcpy(gRVtxList, gVtxList)
		mapWidth = level.levelWidth * TILESIZE
		mapHeight = level.levelHeight * TILESIZE
		particleList = New List<Particle>
		partStore = New PartStore(starsImg)
	End Method

	Method rotate_z(angle:Float)
	
		Local ca:Float = Cos(angle)
		Local sa:Float = Sin(angle)
		Local i:Int
		For Local gRVtx:Vertex = Eachin gRVtxList
			Local x:Float = gRVtx.x * ca - gRVtx.y * sa
			Local y:Float = gRVtx.x * sa + gRVtx.y * ca
			gRVtx.x = x
			gRVtx.y = y
		Next
	
	End Method 
	
	Method rotate_y(angle:Float)
	
		Local ca:Float = Cos(angle)
		Local sa:Float = Sin(angle)
		For Local gRVtx:Vertex = Eachin gRVtxList
			Local z:Float = gRVtx.z * ca - gRVtx.x * sa
			Local x:Float = gRVtx.z * sa + gRVtx.x * ca
			gRVtx.z = z
			gRVtx.x = x
		Next
	
	End Method
	
	Method rotate_x(angle:Float)
	
		Local ca:Float = Cos(angle)
		Local sa:Float = Sin(angle)
		Local i:Int
		For Local gRVtx:Vertex = Eachin gRVtxList
			Local y:Float = gRVtx.y * ca - gRVtx.z * sa
			Local z:Float = gRVtx.y * sa + gRVtx.z * ca
			gRVtx.y = y
			gRVtx.z = z
		Next
		
	End Method
	
	Method ProcessInput:Void(lr:Int,ud:Int)
			rollx += lr*THRUST
			rolly += ud*THRUST
	End Method
	
	Method AutoLeft:Void()
		'stepped on arrow left
		movx -= SLIDEPOWER
		rollx -= SLIDEPOWER	
	End Method

	Method AutoRight:Void()
		'stepped on arrow rigt
		movx += SLIDEPOWER
		rollx += SLIDEPOWER	
	End Method
	
	Method AutoUp:Void()
		'stepped on arrow up
		movy -= SLIDEPOWER
		rolly -= SLIDEPOWER
	End Method
	
	Method AutoDown:Void()
		'stepped on arrow down
		movy += SLIDEPOWER
		rolly += SLIDEPOWER	
	End Method
	
	Method MoveSmooth:Void()
		'stepped on smoot tile
		movx  = (movx * 63 + rollx) / 64
		movy  = (movy * 63 + rolly) / 64
		rollx = (movx + rollx * 63) / 64
		rolly = (movy + rolly * 63) / 64
	End Method
	
	Method MoveRough:Void()
		'stepped on roug tile
		movx *= SLOWDOWNROUGH
		movy *= SLOWDOWNROUGH
		movx = (movx + rollx) / 2
		movy = (movy + rolly) / 2
		rollx = (movx + rollx) / 2
		rolly = (movy + rolly) / 2      	
	End Method
	
	Method MoveNormal:Void()
		'stepped on normal tile
		movx *= SLOWDOWN
		movy *= SLOWDOWN
		movx = (movx * 7 + rollx) / 8
		movy = (movy * 7 + rolly) / 8
		rollx = (movx + rollx * 7) / 8
		rolly = (movy + rolly * 7) / 8
	End Method
	
	Method Update:Int(nextState:Int)
		Local currenttile:Int = level.GetCurrentTile(posx,posy)
		Local tileType:Int = level.level[currenttile]
		Select (tileType)                   
			Case LEVEL_DROP
				' player fell off
				If nextState <> STATE_FALLOFF
					soundChannel[channelIndex].Play(failSnd)
					channelIndex = (channelIndex+1) Mod 15
					nextState = STATE_FALLOFF
					score.lives -= 1
				Endif
			Case LEVEL_LEFT_top 'l
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len < 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_LEFT_bottom 'n
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE + TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len < 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_RIGHT_top 'r
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE + TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len < 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_RIGHT_bottom 'p					
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE + TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE + TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len < 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_left_top
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE + TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE + TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len > 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			
			Case LEVEL_right_top
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE + TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len > 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			
			Case LEVEL_left_bottom
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE + TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len > 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			
			Case LEVEL_right_bottom
				If nextState <> STATE_FALLOFF
					Local tx:Int = posx - posx Mod TILESIZE
					Local ty:Int = posy - posy Mod TILESIZE
					Local vx:Float = tx-posx
					Local vy:Float = ty-posy
					Local len:Float = Sqrt(vx*vx+vy*vy)
					If len > 31.0
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_DIAG_LT
				If nextState <> STATE_FALLOFF
					Local ty:Int = TILESIZE - (posy Mod TILESIZE)
					Local tx:Int = posx Mod TILESIZE 
					If tx < ty
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF					
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_DIAG_RT
				If nextState <> STATE_FALLOFF
					Local ty:Int = posy Mod TILESIZE
					Local tx:Int = posx Mod TILESIZE 
					If tx > ty
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF					
						score.lives -= 1
					Endif
				Endif
			Case LEVEL_DIAG_LB
				If nextState <> STATE_FALLOFF
					Local ty:Int = posy Mod TILESIZE
					Local tx:Int = posx Mod TILESIZE
					If tx < ty
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF
						score.lives -= 1
					Endif
				Endif			
			Case LEVEL_DIAG_RB
				If nextState <> STATE_FALLOFF
					Local ty:Int = TILESIZE - (posy Mod TILESIZE)
					Local tx:Int = posx Mod TILESIZE
					If tx > ty
						soundChannel[channelIndex].Play(failSnd)
						channelIndex = (channelIndex+1) Mod 15
						nextState = STATE_FALLOFF					
						score.lives -= 1
					Endif					
				Endif			
			Case LEVEL_END
				'completed level
				Local secondsleft:Int = level.levelTime - (gLastTick - levelStartTick) / 1000
				soundChannel[channelIndex].Play(chimeSnd)
				channelIndex = (channelIndex+1) Mod 15
				nextState = STATE_ENDLEVEL
			Case LEVEL_LEFT
				AutoLeft()
			Case LEVEL_RIGHT
				AutoRight()
			Case LEVEL_UP
				AutoUp()
			Case LEVEL_DOWN
				AutoDown()
		End Select
				
		Select (tileType)
			Case LEVEL_SMOOTH
				MoveSmooth()
			Case LEVEL_ROUGH
				MoveRough()
			Default
				MoveNormal()
		End Select
		
		posx += movx
		posy += movy
		camera.move((CAMERAWIDTH / 2) - (posx + movx * 25),(CAMERAHEIGHT / 2) - (posy + movy * 25))
		gRoll += Sqrt(rollx * rollx + rolly * rolly)
		'find current tile
		currenttile = level.GetCurrentTile(posx,posy)
		Local xposintile:Float = posx Mod TILESIZE
		Local yposintile:Float = posy Mod TILESIZE
		Local collision:Int, normalx:Float, normaly:Float
		Local colFlags:Int= level.coins[currenttile]
		' Check collision with tile edges
		If (colFlags & COLLIDE_E And xposintile > (TILESIZE - RADIUS))
			normalx -= xposintile - (TILESIZE - RADIUS)
			collision = 1
		Endif
		If (colFlags & COLLIDE_W And xposintile < RADIUS)
			normalx += (RADIUS) - xposintile
			collision = 1
		Endif
		If (colFlags & COLLIDE_S And yposintile > (TILESIZE - RADIUS))
			normaly -= yposintile - (TILESIZE - RADIUS)
			collision = 1
		Endif
		If (colFlags & COLLIDE_N And yposintile < RADIUS)
			normaly += (RADIUS) - yposintile
			collision = 1
		Endif
		If (collision)
			posx += normalx
			posy += normaly
			' re-calculate the positions so that we don't collide with
			' corners unneccessarily after colliding with the walls.
			xposintile = posx Mod TILESIZE
			yposintile = posy Mod TILESIZE
		Endif
		Local nx:Int = xposintile-TILESIZE
		Local ny:Int = yposintile-TILESIZE
		Local px:Int = xposintile*xposintile
		Local py:Int = yposintile*yposintile
		Local r2:Int = RADIUS*RADIUS
		' Check collision with tile corners
		If (colFlags & COLLIDE_NE And ((nx*nx) + (py*py)) < (RADIUS * RADIUS))
		
			Local dist:Float = Sqrt((nx*nx) + py*py)
			If (dist > 0)
				normalx += (RADIUS - xposintile) / dist
				normalx += (RADIUS - yposintile) / dist
				collision = 1
			Endif
		Endif
		If (colFlags & COLLIDE_NW And (px + py) < r2)
			Local dist:Float = Sqrt(px + py)
			If (dist > 0)
				normalx += (RADIUS - xposintile) / dist
				normaly += (RADIUS - yposintile) / dist
				collision = 1
			Endif
		Endif
		If (colFlags & COLLIDE_SE And ((nx*nx) + (ny*ny)) < r2)
			Local dist:Float = Sqrt((nx*nx) +  (ny*ny))
			If (dist > 0)
				normalx += (RADIUS - xposintile) / dist
				normaly += (RADIUS - yposintile) / dist
				collision = 1
			Endif
		Endif
		If (colFlags & COLLIDE_SW And ((px*px) + (ny*ny)) < r2)
			Local dist:Float = Sqrt(px*px + ny*ny)
			If (dist > 0)
				normalx += (RADIUS - xposintile) / dist
				normaly += (RADIUS - yposintile) / dist
				collision = 1
			Endif
		Endif
		
		If (collision)
			posx += normalx
			posy += normaly
			' Normalize (i.e. make unit length) the collision normal
			Local lengt:Float = Sqrt(normalx*normalx + normaly*normaly)
			normalx /= lengt
			normaly /= lengt
			
			' Calculate dot product between the wall collision And motion vector
			Local dot:Float = movx * normalx + movy * normaly * 1.25
			Local nx:Float = dot * normalx
			Local ny:Float = dot * normaly
			' Adjust the motion vector based on the collision
			movx -= nx
			movy -= ny
			
			' Adjust the roll vector based on the collision
			rollx -= nx
			rolly -= ny
		Endif
		' Collision with the level borders
		If (posx > level.levelWidth * TILESIZE Or posx < 0 Or posy > level.levelHeight * TILESIZE Or posy < 0)
			If nextState <> STATE_FALLOFF
				soundChannel[channelIndex].Play(failSnd)
				channelIndex = (channelIndex+1) Mod 15
				nextState = STATE_FALLOFF
				score.lives -= 1
			Endif
		Endif
		Return nextState
	End Method
	
	Method Render(canvas:Canvas,x:Int, y:Int, r:Int,roty:Float, rotz:Float)
	    x = x+posx
		y = y+posy

		Local i:Int,dotradius:Int
		If game.state <> STATE_EXPLODE
			
			dotradius = (r / (RADIUS / 2))
			DrawCircle(canvas,x, y, r, BALLCOLOR)
			rotate_z(-rotz*Pi/180.0)
			rotate_y(roty*Pi/180.0)
			rotate_z(rotz*Pi/180.0)
			
			canvas.Color = new Color(1,1,1) ' 255,255,255)
			For Local p:Particle = Eachin particleList
				p.Render(canvas)
			Next
			
			canvas.Alpha = 1.0
	
			For Local v:Vertex = Eachin gRVtxList
				If (v.z < 0)
					DrawCircle(canvas,Int(v.x * (r - dotradius) + x),Int(v.y * (r - dotradius) + y), dotradius, BALLLOCOLOR)
				Endif
			Next
			For Local v:Vertex = Eachin gRVtxList
				If (v.z >= 0)
					DrawCircle(canvas,v.x * (r - dotradius) + x,v.y * (r - dotradius) + y,dotradius, BALLHICOLOR)
				Endif
			Next
		Endif
		For Local p:Particle = Eachin particleList
			If p.update() = False
				p.link.Remove()
				partStore.replace(p)
			Endif
		Next

		If game.state = STATE_INGAME
			If Abs(movx)>.6 Or Abs(movy)>.6
				For Local v:Vertex = Eachin gRVtxList
					Local p:Particle = partStore.get()
					p.init(v.x*(r-dotradius)+posx,v.y*(r-dotradius)+posy,0,0,0)
					p.link = particleList.AddLast(p)
				Next 
			Endif
		Endif
	End Method

End Class

Class Level

	Field level:Int[]  
	Field coins:Int[]
	Field mazes:String[][]
	Field maze:String[]
	Field indx:Int
	
	Field levelName:String
	Field levelTime:Int
	
	Field levelWidth:Int
	Field levelHeight:Int
	
	Field currentLevel:Int
	
	Method New()
		  mazes = New String[11][]
		  mazes[0]=New String[]("599999999999999999999996",
								"A__________oooooooo__zZA",
								"A_S__o_____oooooooo__yYA",
								"A______o_________oooo__A",
								"A__zZ__o____##_____oo__A",
								"A__yY__o__#p..n____oo__A",
								"A_____o___#....#____oo_A",
								"A_____o___#....#____oo_A",
								"A_____o___#....#____oo_A",
								"A_____o____r..l_____oo_A",
								"A______o____##______oo_A",
								"A__zZ____o_____zZ___oo_A",
								"A__yY______o___yY__ooE_A",
								"A____________o_o_o_____A",
								"799999999999999999999998",
								"@10@Intro@")
					
		  mazes[1]=New String[]("5999599999999996",
								"A___A___ooo__zZA",
								"A_S_A__E__oo_yYA",
								"Aoo_A______oo__A",
								"Aoo_A_______oo_A",
								"Aoo_C9999996_ooA",
								"A_ooA......A__oA",
								"A_ooA......A__oA",
								"A_ooA......A__oA",
								"A_o_79999998_o_A",
								"AzZ_o______oozZA",
								"AyY__oooooo__yYA",
								"7999999999999998",
								"@9@Enter The Maze@")
					
		  mazes[2]=New String[]("59999999999999999999999999996",
								"A_____oooooo_______ooooo___.A",
								"A_S_________ooooooooooooo__.A",
								"A____________oooo________oooA",
								"C99999999999999999999994__ooA",
								"A.___________ooooo________ooA",
								"A.___ooooo_________ooooooo__A",
								"A_o__29999999999999999999999V",
								"A_oo_________ooooooooo_____.A",
								"A.___ooooo_______________oo.A",
								"C99999999999999999999994_oo_A",
								"A.______oooo_____________oo_A",
								"A_E___o______oooo_______oo_.A",
								"A.________________ooooo____.A",
								"59999999999999999999999999998",
								"@18@Snake Path@")
					
		  mazes[3]=New String[]("Avvvvvvvvvvvvvvvvvvvvvv",
								"A______ooooo__________<",
								"A__S_________oooo_____<",
								"A__________________o__<",
								"79999999999999994__o__<",
								"..>.E.___o<......>o___<",
								"..>oo_____<......>__oo<",
								"..>_oo____29999994_oo_<",
								"..>_oo____#...#___oo_<.",
								"..>_oo_2999994>__oo_<..",
								"..>__o_<......>__oo__<..",
								".>__oo_<........>oo_<..",
								">__o___<.........>_oo<.",
								">_o____29999999994__oo<",
								">_o_____oooooooo___oo_<",
								">__ooo__________ooo___<",
								">^^^^^^^^^^^^^^^^^^^^^^",
								"@15@Help Please@")
					
		 mazes[4] =New String[]("5999999999999999994",
								"A___oooooooooo_____",
								"A_S_o__________o___",
								"c_______________o__",
								"..............n_o__",
								"..............l_o__",
								"a__b.........a_o___",
								"_E__........._oo___",
								"_oo_.........c__o__",
								"_oo_..........n_oo_",
								"__o_r.........l__oo",
								"__ooooooooo________o",
								"________oooooooooo_",
								"^^^^^^^^^^^^^^^^^^^",
								"@10@First Steps@")
					
		 mazes[5] =New String[]("......^^^^^^^^........",
								"......_ooooooo^.......",
								".....<o_p...n_o>......",
								".....<o_.....o_>......",
								"....<__o.....o_>......",
								"....<__o....._o>......",
								"....<_oz....l_o>......",
								"...<_oz...a__S__>.....",
								"...<oz....________....",
								"..<o_r....c2999994....",
								".<================y...",
								"<_oooooooooooooooo_y..",
								"<=================_oy.",
								"..................Z_oy",
								"...................Zo_",
								"....................o_",
								"....................o_",
								"...................Yo_",
								"aEE__o__o____o_____<o_",
								"cvvvvvvvvvvvvvvvvvvvvd",
								"@16@SSSSSSS@")

		 mazes[6] =New string[]("a____oooo____________T___________b",
								"_Soo_______ooooooooo_t________===>",
								"vvvvvvvvvvvvvvvvvvvvvT________===>",
								"..............................===>",
								"a__oooooooo__T________________===>",
								"<<o__________t==================>>",
								"<<o__________T_______________===>>",
								"<__o>.............................",
								"<__o>___________oooo___________T_b",
								"_o__________oo__________ooooo__t==",
								"c_oooooooo_____________________T==",
								"................................==",
								"a^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^___",
								"=EE===========================____",
								"cvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvd",
								"@30@In Shock@")
					
		 mazes[7] =New string[]("Sb..aooooooooo<<====____oooo_b",
								"__..o_________<<====ooo_____o_",
								"__..o_......................o_",
								"==..o_......................o_",
								"==..o_..o_____<<===_____o_..o_",
								"==..==..o_____<<===_______.._o",
								"==..==..o=..............__.._o",
								"==..==..o=....W.........__.._o",
								"vv..vv..Z=........oooo..__..o_",
								"vv..vv...=.....T..oEEo..__..o_",
								"o_.._o...====XXtoooooo..^^..^^",
								"o_.._o...c===XXtoooooo..^^..^^",
								"o_.._o.........T........==..==",
								"==.._o..................==..==",
								"==..o______===>>______T___..==",
								"==..Z______===>>______t_oz..==",
								"Z=....................T.....oz",
								".Zy........................Yz.",
								"..Zoooooo=====>>oooooooooooz..",
								"...Z_ooo_=====>>ooooooooo_z...",
								"@45@twirling@")
					
		  mazes[8]=New String[](".....................................",
								".a====_==================1oooooo___b.",
								".__S=_____===============3oooo1_o___.",
								".c====_==================_ooooA__o=_.",
								".....................g===_____3__o__.",
								".................................o__.",
								".a__oooo___y....................Yo_z.",
								".o_______ooooooooo__g=yYyYyYoy=Yo_z..",
								".==........Z_______o_zZzZzZzZ_o__z...",
								".==.g.................................",
								".=====oooooooooo.........oooooooooob.",
								".c====___________ooooooo________g___.",
								".................................TeT.",
								"._____Gy.....g....G.......Y__oooo___.",
								"._EE____==================_oooooo___.",
								".______Y................g.Z_________.",
								"......g......g....g..................",
								"@40@Dont Get Burned@")

		 mazes[9] =New String[]("......................................",
								".Sy.....YOOOOy....OOOOOOOOOOOOOOOOOO..",
								".=Zy...Yz....Zy...O............G..YO..",
								".=.Zy.Yz..W...Zy..O...OOOOOOOOOOOOz...",
								".=..ZOz.......OOO.O...OOOOOO....Yz....",
								".=...OOOOOOOOOOOOOO...OOOOOO...Yz.....",
								".O........O...OOO.....OOOOOOOOOz......",
								".O........O....=......OOOOOO.Yz.......",
								".O........O....=............Yz........",
								".O.......YO....=...........Yz.........",
								".O......Yz.....=..........YOOOOO......",
								".O.....Yz......O.........Yz.W..O.......",
								".O....Yz.......O........Yz.....O......",
								".O...Yz........O.......Yz......O..E...",
								".O.G.O.........O......Yz......OO..O...",
								"._..._.........O.....Yz.......O.G.O...",
								"._____.........O_____z.......OOOOO...",
								"@40@Ready Aim Fire@")
		mazes[10] =New String[]("a_b.......a^^^^^^^^^^^^^^^^^^^b...a^^^^^^^^^b.......ab....a^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^b..a^b",
								"_S_......._____________________...___________.......__...._____________________________________..___",
								"___rg...gl_________G___________...__p.....n__.......__...._____________________________________..___",
								"____________p...............n__...__.......__.......__....__p..........................Yz...n__..___",
								"c__________d.....a_b........l__r.lXX.......__.......__....__..a________________y......Yz.....__..___",
								"......G.........._____________________b....__r..W...__....__..c______________p.Zy....Yz......__..___",
								".................c____________________d....________T__....__r.............___...Zy..Yz.......__rl___",
								"a__________b.....................n__p......c_______t__....___________________....ZyYz........______z",
								"____________...........W..........XX........g......T__....___________________.....Zz.........c____z.",
								"___p....n___.....................l___b............l___....__........___p.n___.......................",
								"___......___r...l_____________________...==========___....__...________...___..........a___________b",
								"___......_____________________________...TeT5999999994r..l__...________...c______b.W..._____________",
								"c_d......_____________________________...___A_____________==..._______d........___.....___pn___..<X>",
								".........29999999999999999999999999994r.l___A_____________==...___.............___.....___..___..<_>",
								"____________________________________________A__p.............W.___............l___r...l___..___..<_>",
								"____________________________________________A__....a______________........a_______________..___..<_>",
								"<_>29999999999999999999999999999999999999994T__....______________d........c______________d..___..<_>",
								"<_>.._______________________________________t==....c______.................................l___..<_>",
								"<_>.l_______________________________________T==........_________b..a____________T______________..<_>",
								"<______>...............................................__________.._____________t______________..<_>",
								"<______>...____________________________________b.......c________dg._____________T_____________d..<_>",
								"________________________________________________..................l___p..........................<_>",
								"____pn299999999999999999999999999999999994__====............a_________r..........................<_>",
								"____..____o________________________________o====________b.W._________________A_____....a_______b.<X>",
								"____.._______________o______________________====_________TTTT____g___________A_____....___p..n___===",
								"____..___p.................n____pn____p..________________tttt________...G____A____________....___===",
								"____..___....a___________b..____..____...________________TTTT________....____A____________....___===",
								"____..___r..l_____________..____..____..._____....................___....____7999995999994l..r______",
								"____..___________________d..____..____..._____________________b...___....__________A________________",
								"____..c________d............____..____...c_____________________...___....__________A________________",
								"____........................____..____.....................1XX1...___.W.........___A______._________",
								"____r.....................______..____r...................lAXXA...._______......TeT3______.___..____",
								"__________________b....a_______d.._________________________3XX3...._______......===_______.___..____",
								"___________________....Z___Y.......___________________________d........TXT....g.===______d.___..____",
								"___________p.n_____.....Z___Y....._____________________p..............a_____________p......___..____",
								"__________d...c___d......Z_____Y..____________________d....a________________________d......c_d..c__d",
								"_____.....................Z___________....................._______________G.......G.................",
								"______________________________________________________b...._______________________________TvvvEE___b",
								"_______________________________________________________...._______________________________tvvvEE____",
								"c_____________________________________________________d....c_________________________g____T=========",
								"@120@The Mother@")
					
	End Method
		
	Method init()
	  level = Null
	  coins = Null
	  levelName = ""
	  currentLevel = 0
	End Method
	
	Method NextLevel(lvl:Int)
		currentLevel += 1
	End Method

	Method Load()
		Local name:String
		Local i:Int = 0
		If currentLevel > 11 Then
			currentLevel = 0
		Endif
		maze = mazes[currentLevel]
		
		levelWidth = maze[0].Length
	  
		levelHeight = maze.Length-1
		level = New Int[levelWidth * (levelHeight+1)]
		coins = New Int[levelWidth * (levelHeight+1)]
		For Local y:Int = 0 Until levelHeight
			For Local x:Int = 0 Until levelWidth
				Local v:String = String.FromChar(maze[y][x])
				If (v[0] <>32)
					Local p:Int = y*levelWidth+x
					Select v
						Case "." 	level[p] = LEVEL_DROP
						Case "_" 	level[p] = LEVEL_GROUND
						Case "S"	level[p] = LEVEL_START
						Case "E"	level[p] = LEVEL_END
						Case "X"	level[p] = LEVEL_TRAP_DOOR
						Case "o"	level[p] = LEVEL_COLLECTIBLE
						Case "O"	level[p] = LEVEL_COLLECTIBLE2
						Case ">"	level[p] = LEVEL_RIGHT
						Case "L"	level[p] = LEVEL_LEFT_TOP
						Case "R"	level[p] = LEVEL_RIGHT_TOP
						Case "N"	level[p] = LEVEL_LEFT_BOTTOM
						Case "P"	level[p] = LEVEL_RIGHT_BOTTOM
						Case "l"	level[p] = LEVEL_LEFT_top
						Case "n"	level[p] = LEVEL_LEFT_bottom
						Case "r"	level[p] = LEVEL_RIGHT_top
						Case "p"	level[p] = LEVEL_RIGHT_bottom						
						Case "<"	level[p] = LEVEL_LEFT
						Case "v"	level[p] = LEVEL_DOWN
						Case "^"	level[p] = LEVEL_UP
						Case "a"	level[p] = LEVEL_left_top
						Case "b"	level[p] = LEVEL_right_top
						Case "c"	level[p] = LEVEL_left_bottom
						Case "d" 	level[p] = LEVEL_right_bottom
						Case "#"	level[p] = LEVEL_WALL
						Case "!"	level[p] = LEVEL_ROUGH
						Case "="	level[p] = LEVEL_SMOOTH
						Case "T"	level[p] = LEVEL_TESLA
						Case "t"	level[p] = LEVEL_SPARKH
						Case "e" 	level[p] = LEVEL_SPARKV
						Case "u" 	level[p] = LEVEL_HSMASHER
						Case "w" 	level[p] = LEVEL_VSMASHER
						Case "k" 	level[p] = LEVEL_SPIKE
						Case "Y"	level[p] = LEVEL_DIAG_LT
						Case "y"	level[p] = LEVEL_DIAG_RT
						Case "Z"	level[p] = LEVEL_DIAG_LB
						Case "z"	level[p] = LEVEL_DIAG_RB
						Case "0"	level[p] = LEVEL_FRAMESOLO
						Case "1"	level[p] = LEVEL_FRAMEENDT
						Case "2"	level[p] = LEVEL_FRAMEENDL
						Case "3"	level[p] = LEVEL_FRAMEENDB
						Case "4"	level[p] = LEVEL_FRAMEENDR
						Case "5"	level[p] = LEVEL_FRAMELTC
						Case "6"	level[p] = LEVEL_FRAMERTC
						Case "7"	level[p] = LEVEL_FRAMEBLC
						Case "8"	level[p] = LEVEL_FRAMEBRC
						Case "9"	level[p] = LEVEL_FRAMEBT
						Case "A"	level[p] = LEVEL_FRAMELR
						Case "B"	level[p] = LEVEL_CONTACTC
						Case "C"	level[p] = LEVEL_CONTACTL
						Case "D"	level[p] = LEVEL_CONTACTT
						Case "V"	level[p] = LEVEL_CONTACTR
						Case "F"	level[p] = LEVEL_CONTACTB
						Case "g"	level[p] = LEVEL_FLAMEL
						Case "G"	level[p] = LEVEL_FLAMER
						Case "W"	level[p] = LEVEL_TURRET
					End Select
				Endif
			Next
		Next
		levelName = ""

		Local ch:String
		i = 0
		ch = String.FromChar(Int(maze[levelHeight][i]))
		If ch ="@"			
			i += 1
			While (i< maze[levelHeight].Length)
				ch =String.FromChar( maze[levelHeight][i])
				If ch ="@"
					Exit
				Endif
				name += ch
				i += 1
			Wend
			levelTime = Int(name)
			name = ""
			i += 1
			While (i<maze[levelHeight].Length)
				ch =String.FromChar( maze[levelHeight][i])
				If ch ="@" Exit
				name+=ch
				i += 1
			Wend
		Endif
		Local lengt:Int = (name.Length)
		levelName = name
		For i = 0 Until levelWidth * levelHeight
			If level[i] = LEVEL_START
				ball.startx = Float((i Mod levelWidth) * TILESIZE + TILESIZE / 2)
				ball.starty = Float((i / levelWidth) * TILESIZE + TILESIZE / 2)
			Endif
			If level[i] = LEVEL_WALL Or (level[i] >= LEVEL_TESLA And level[i] <= LEVEL_CONTACTB) Or (level[i] = LEVEL_FLAMEL) Or (level[i] = LEVEL_FLAMER) Or (level[i] = LEVEL_TURRET)
				Local ypos:Int = i / levelWidth
				Local xpos:Int = i Mod levelWidth
				If (ypos > 0)
					If (xpos > 0) 
						 coins[i - levelWidth - 1] |= COLLIDE_SE
					End If
					coins[i - levelWidth] |= COLLIDE_S
					If (xpos < levelWidth - 1)
						coins[i - levelWidth + 1] |= COLLIDE_SW
					End If
				Endif
				If (xpos > 0)
					coins[i - 1] |= COLLIDE_E
				Endif
				If (xpos < levelWidth - 1)
					coins[i + 1] |= COLLIDE_W
				End If
				If (ypos < levelHeight - 1)
					If xpos > 0
						coins[i + levelWidth - 1] |= COLLIDE_NE
					End If
					coins[i + levelWidth] |= COLLIDE_N
					If (xpos < levelWidth - 1)
						coins[i + levelWidth + 1] |= COLLIDE_NW
					End If
				Endif
			Endif
		Next
		Local ns:String
		Collectible.gCollectibleCount = 0
		Collectible.Taken = 0
		CollectibleList.Clear()
		trapDoorList.Clear()
		voltList.Clear()
		flameList.Clear()
		turretList.Clear()
		For  i = 0 Until levelWidth * levelHeight
			Select level[i]
				Case LEVEL_COLLECTIBLE
					CollectibleList.AddLast( New Collectible(((i Mod levelWidth) * TILESIZE + TILESIZE / 2),
										   ((i / levelWidth) * TILESIZE + TILESIZE / 2)))
					Collectible.gCollectibleCount +=1
					level[i] = LEVEL_GROUND
				Case LEVEL_COLLECTIBLE2
					CollectibleList.AddLast( New Collectible(((i Mod levelWidth) * TILESIZE + TILESIZE / 2),
										   ((i / levelWidth) * TILESIZE + TILESIZE / 2)))
					Collectible.gCollectibleCount +=1
					level[i] = LEVEL_SMOOTH
				Case LEVEL_TRAP_DOOR
					trapDoorList.AddLast(New TrapDoor(((i Mod levelWidth) * TILESIZE),((i / levelWidth) * TILESIZE),gTiles,26,29,26))
				Case LEVEL_SPARKV
					voltList.AddLast(New Volt(((i Mod levelWidth)*TILESIZE),((i/levelWidth)*TILESIZE)+8,sparkVImg,0,3,50,3000,4))
					level[i] = LEVEL_GROUND
				Case LEVEL_SPARKH
					voltList.AddLast(New Volt((i Mod levelWidth)*TILESIZE+8,(i/levelWidth)*TILESIZE,sparkHImg,0,3,50,3000,4))			
					level[i] = LEVEL_GROUND
				Case LEVEL_FLAMEL
					flameList.AddLast(New FireStream(flameImg,(i Mod levelWidth)*TILESIZE+16,(i/levelWidth)*TILESIZE+16,3))
					level[i] = LEVEL_FRAMESOLO
				Case LEVEL_FLAMER
					flameList.AddLast(New FireStream(flameImg,(i Mod levelWidth)*TILESIZE+16,(i/levelWidth)*TILESIZE+16,-3))
					level[i] = LEVEL_FRAMESOLO
				Case LEVEL_TURRET
					turretList.AddLast(New Turret((i Mod levelWidth)*TILESIZE + 16,(i/levelWidth)*TILESIZE + 16,0,turretImg))
					level[i] = LEVEL_FRAMESOLO
			End Select
		Next

	End Method

	Method GetCurrentTile:Int(px:Int,py:Int)
		Return (py / TILESIZE) * levelWidth + px / TILESIZE
	End Method


	Method Render(canvas:Canvas)
		Local x:Int
		Local y:Int
		Local p:Int = 0
		Local i:Int, j:Int,h:Int,k:Int
		indx = (indx+ 1) Mod 20
		For i = 0 Until levelHeight
			y = i*TILESIZE + camera.y
			If y < -TILESIZE Continue
			If y > CAMERAHEIGHT Exit
			k = i * levelWidth
			For j = 0 Until levelWidth
				x = Int(j * TILESIZE + camera.x)
				If x < -TILESIZE Continue 
				If x > CAMERAWIDTH Exit 
				h = level[k+j]
				If (h <> 0)
					Local tile:Int = 0
					Select h
						Case LEVEL_TRAP_DOOR
							Continue
						Case LEVEL_UP,LEVEL_RIGHT,LEVEL_DOWN,LEVEL_LEFT,LEVEL_WALL,LEVEL_VSMASHER,LEVEL_HSMASHER,LEVEL_SPIKE
							tile = h + indx/5
						Default
							tile = h
					End Select
					canvas.DrawImage(gTiles[tile],x,y)
'					canvas.DrawText(tile,x,y)
				Endif				
			Next
		Next
	End Method

End Class

Class Camera
	' Camera position
	Field x:Float
	Field y:Float
	
	Method New()
	End Method

	Method move(targetx:Float,targety:Float)
		x = (targetx + x * 19) / 20
		y = (targety + y * 19) / 20
	End Method
	
	Method reset()
		x = (CAMERAWIDTH / 2) - ball.posx
		y = (CAMERAHEIGHT / 2) - ball.posy	
	End Method

End Class

Class Collectible
	Field mX:Float
	Field mY:Float
	Field mColor:Int
	Field mRadius:Int
	Field mTaken:Int

	Const COLLECTIBLERADIUS:Int = 8
	Const COLLECTIBLECOLOR:Int = $ffff00
	Global gCollectibleCount:Int
	Global Taken:Int
	Global image:Image[]


	Method New(x:Float,y:Float)
		mX = x
		mY = y
		mColor = COLLECTIBLECOLOR
		mRadius = COLLECTIBLERADIUS
		mTaken = 0
	End Method
		
	Function collision()
		Local i:Int
		For Local v:Collectible = Eachin CollectibleList
			If v.mTaken = 0
				v.collided()
			Endif		
		Next
	End Function
	
	Method collided()
		If (Sqrt((mX - ball.posx) * (mX - ball.posx) +(mY - ball.posy) * (mY - ball.posy)) <ball.RADIUS + mRadius)
			Taken += 1
			mTaken = 1
			soundChannel[channelIndex].Play(coinSnd)
			channelIndex = (channelIndex+1) Mod 15			
		Endif
	End Method
	
	Method Render(canvas:Canvas)
		If mTaken = 0
			canvas.DrawImage(image[92],camera.x+mX-16,camera.y+mY-16)
		Endif
	End Method

End Class

Class Volt
	Field x:Float
	Field y:Float
	Field image:Image[]
	Field firstFrame:Int
	Field lastFrame:Int
	Field index:Int 
	Field delayTime:Int
	Field delay:Int
	Field active:Int
	Field pauseTime:Int
	Field pauseDelay:Int
	Field paused:Int
	Field maxCycles:Int
	Field cycle:Int
	
	Method New(x:Float, y:Float,image:Image[],first:Int,last:Int,delay:Int,pauseDelay:Int,cycles:Int)
		Self.x = x
		Self.y = y
		Self.image = image
		Self.firstFrame = first
		Self.lastFrame = last
		Self.index = first
		Self.delay = delay
		Self.delayTime = Millisecs()+delay
		Self.pauseDelay = pauseDelay
		Self.paused = False
		Self.maxCycles = cycles
	End Method
	
	Method Update:Void()
		If paused = False
			If index < lastFrame
				If Millisecs() >= delayTime
					index += 1
					delayTime = Millisecs()+delay
				Endif
			Else
				If cycle < maxCycles
					index = 0
					cycle += 1
				Else
					paused = True
					pauseTime = Millisecs()+pauseDelay
				Endif	
			Endif
		Else
			If Millisecs() > pauseTime
				paused = False
				cycle = 0
				index = firstFrame
				delayTime = Millisecs()+delay
				If Not electricChannel.Playing
					electricChannel.Play(electricSnd)
				Endif
			Endif
		Endif
	End Method
	
	Method collided:Int()
		If ball.posx > x-8 And ball.posx < (x+24) And ball.posy > (y-8) And ball.posy < (y+24)
			Return Not paused
		Endif
		Return False
	End Method
	
	Method Render(canvas:Canvas)
		If paused = False canvas.DrawImage(image[index],x+camera.x,y+camera.y)
	End Method
	
End Class 


Class PVect
	Field x:Float
	Field y:Float
End Class

Class Fire
	Field off:PVect
	Field pos:PVect
	Field angle:Float
	Field image:Image
	Field stp:Float
	
	Method New(off:PVect,x:Float,y:Float,angle:Float,image:Image)
		Self.off = off
		Self.pos = New PVect
		Self.pos.x = x
		Self.pos.y = y
		Self.angle = angle
		Self.image = image
		Self.stp = 10
	End Method
	
	Method Update:Void()
		angle += stp
		
	End Method
	
	Method Collided:Int()
		Local vx:Float = (pos.x+off.x) - ball.posx
		Local vy:Float = (pos.y+off.y) - ball.posy
		If (vx*vx+vy*vy) < (18*18)
			Return True
		Endif
		Return False
	End Method
	
	Method Rotate:Void(ang:Float)
		Local tx:Float = pos.x*Cos(ang*Pi/180.0) - pos.y*Sin(ang*Pi/180.0) 
		pos.y = pos.y*Cos(ang*Pi/180.0) + pos.x*Sin(ang*Pi/180.0)  
		pos.x = tx
	End Method
	
	Method Render:Void(canvas:Canvas)
		canvas.DrawImage( image,camera.x+off.x+pos.x,camera.y+off.y+pos.y,-angle,1,1)
		canvas.DrawImage( image,camera.x+off.x+pos.x,camera.y+off.y+pos.y, angle,1,1)
	End Method
	
End Class


Class FireStream
	Field pos:PVect
	Field fire:Fire[]
	Field stp:Float
	Field fireImg:Image
	Field angle:Float
	
	Method New(fireImg:Image,x:Float,y:Float,stp:Float)
		Self.pos = New PVect
		Self.pos.x = x
		Self.pos.y = y
		Self.angle = 0
		Self.fire = New Fire[](New Fire(pos,0,0,angle,fireImg),
			    			 New Fire(pos,16,0,angle,fireImg),
							 New Fire(pos,32,0,angle,fireImg),
							 New Fire(pos,48,0,angle,fireImg),
							 New Fire(pos,64,0,angle,fireImg),
							 New Fire(pos,80,0,angle,fireImg))
		Self.stp = stp
		Self.fireImg = fireImg
'		SetBlend AlphaBlend
	End Method
	
	Method Collided:Int()
		Local vx:Float = pos.x - ball.posx
		Local vy:Float = pos.y - ball.posy
		If (vx*vx+vy*vy) < (116 * 116)
			For Local f:Fire = Eachin fire
				If f.Collided() = True
					Return True
				Endif
			Next
		Endif
		Return False
	End Method

	Method Update:Void()
		angle += stp
		For Local f:Fire = Eachin fire
			f.Rotate(stp)
			f.Update()
		Next
	End Method
	
	Method Render(canvas:Canvas)
		For Local f:Fire = Eachin fire
			f.Render(canvas)
		Next
	End Method
End Class

Class Turret
	Field pos:PVect
	Field angle:Float
	Field image:Image[]
	Field frame:Float
	Field animating:Int
	
	Method New(x:Float,y:Float,angle:Float,image:Image[])
		Self.pos = New PVect
		Self.pos.x = x
		Self.pos.y = y
		Self.angle = angle
		Self.image = image
		Self.frame = 0
	End Method
	
	Method Update:Void()
		Local angleSpeed:Float = 1*Pi/180.0
		Local turnSpeed:Float
		angle = (angle + TwoPi) Mod TwoPi
		Local vx:Float = (pos.x-ball.posx)
		Local vy:Float = (pos.y-ball.posy)
		RuntimeError("fix this line")
		Local dw:Float = CAMERAWIDTH
		If (vx*vx+vy*vy) > dw*dw Return
		Local TargetAngle:Float = (-ATan2(pos.y-ball.posy,pos.x - ball.posx)+Pi) Mod TwoPi		
		Local difference:Float = Abs(TargetAngle-angle)
		
		'turn toward target

		If TargetAngle < angle				
			If difference > Pi 
				turnSpeed = angleSpeed 
			Else 
				turnSpeed =-angleSpeed
			Endif
		Elseif TargetAngle > angle
			If difference > Pi 
				turnSpeed = -angleSpeed 
			Else 
				turnSpeed = angleSpeed
			Endif
		Endif
		
		'If found stop turning
		
		If difference < 2.0*Pi/180.0 turnSpeed = 0.0			

		angle += turnSpeed
		If animating = False
			If turnSpeed = 0
				If Int(Rnd(1,60)) = 20
					animating = True
					frame = .5
				Endif
			Endif
		Else
			frame = (frame + .5) Mod 3
			If frame = 0
				Local bullet:Particle = bulletStore.get()
				Local vx:Float = Cos(angle)*24
				Local vy:Float = -Sin(angle)*24
				bullet.init(pos.x+vx,pos.y+vy,-angle,6)
				bullet.link = bulletList.AddLast(bullet)
				animating = False
			Endif
		Endif
	End Method

	Method Render:Void(canvas:Canvas)
		canvas.DrawImage(image[frame],camera.x+pos.x,camera.y+pos.y,angle,1,1)
	End Method
	
End Class


Class Score
	Field Total:Int
	Field secondsSpend:Float
	Field secondsRemaining:Float
	Field bonus:Float
	Field coinPoints:Int
	Field totalPoints:Int
	Field gamePoints:Int
	Field lives:Int
End Class