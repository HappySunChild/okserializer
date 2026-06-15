local types = require("../../types")

local lookup = require("@self/lookup")
local to_index, to_brickcolor = lookup.to_index, lookup.to_brickcolor

const BrickColor_schema = {
	write = function(b: buffer, offset: number, value: BrickColor)
		buffer.writeu8(b, offset, to_index(value))
	end,
	read = function(b: buffer, offset: number): BrickColor
		return to_brickcolor(buffer.readu8(b, offset))
	end,
	size = function(): number
		return 1
	end,
	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "BrickColor" then
			return false, `expected value of type BrickColor, got {typeof(value)}`
		end

		return true, nil
	end,
} :: types.Schema<BrickColor>

return BrickColor_schema
