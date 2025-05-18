local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local BrickColorLookup = require(script.Lookup)

return Schema "BrickColor" {
	write = function(b: buffer, offset: number, value: BrickColor)
		local index = BrickColorLookup.index(value)

		buffer.writeu8(b, offset, index)
	end,
	read = function(b: buffer, offset: number)
		local index = buffer.readu8(b, offset)

		return BrickColorLookup.color(index)
	end,
	size = function()
		return 1
	end,

	validate = function(value: unknown)
		return typeof(value) == "BrickColor"
	end,
} :: Types.Schema<BrickColor>
