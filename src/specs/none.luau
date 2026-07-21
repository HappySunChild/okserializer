-- none ("omit"/"null")
-- Mainly useful for omitting data you may not need to store (i.e. envelope of a NumberSequenceKeypoint)

return {
	write = function(): () end,
	read = function(): number
		return 0
	end,
	size = 0,
	min = 0,
	max = 0,
}
