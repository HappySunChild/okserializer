local types = require("../../types")

local lookup = require("@self/lookup")
local to_index, to_brickcolor = lookup.to_index, lookup.to_brickcolor

const BrickColor_schema: types.Schema<BrickColor> = {
	write = function(b: buffer, offset: number, value: BrickColor): number
		buffer.writeu8(b, offset, to_index(value))
		return 1
	end,
	read = function(b: buffer, offset: number): (number, BrickColor)
		return 1, to_brickcolor(buffer.readu8(b, offset))
	end,
	alloc_size = function(): number
		return 1
	end,
	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "BrickColor" then
			return false, `expected value of type BrickColor, got {typeof(value)}`
		end

		return true, nil
	end,
}

return BrickColor_schema
