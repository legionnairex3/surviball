
Class KernPair
	Field first:String
	Field second:String
	Field amount:Int
	
	
	Method New(first:Int, second:Int, amount:Int)
		Self.first = String(first)
		Self.second = String(second)
		Self.amount = amount
	End
	
	Method toString:String()
		Return "first="+first+" second="+second+" amount="+amount
'		Return "first="+first+" second="+second+" amount="+amount
	End Method
End Class






