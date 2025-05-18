local Schema = require "../Schema"
local Types = require "../../Types"

-- I hate how this isn't consistant, but for some reason the `@self` alias isn't currently available in Roblox, so you have to do this.
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
