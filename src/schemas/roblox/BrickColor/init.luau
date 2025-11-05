local Schema = require "../Schema"
local types = require "../../types"

local BrickColorLookup = require "@self/Lookup"

return Schema {
	write = function(b: buffer, offset: number, value: BrickColor)
		local index = BrickColorLookup.indexOf(value)

		buffer.writeu8(b, offset, index)
	end,
	read = function(b: buffer, offset: number): BrickColor
		local index = buffer.readu8(b, offset)

		return BrickColorLookup.colorFor(index)
	end,
	size = function(): number
		return 1
	end,

	validate = function(value: unknown): boolean
		return typeof(value) == "BrickColor"
	end,
} :: types.Schema<BrickColor>
