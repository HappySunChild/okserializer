-- None ("omit"/"null")
-- Mainly useful for omitting data you may not need to store (i.e. envelope of a NumberSequenceKeypoint)

return table.freeze {
	write = @native function(): () end,
	read = @native function(): number
		return 0
	end,
	size = 0,
	min = 0,
	max = 0,
}
