local Types = require "../../Types"

local Schema = require "../Schema"

return Schema "Color3" {
	write = function(b: buffer, offset: number, value: Color3)
		buffer.writeu8(b, offset, value.R * 255)
		buffer.writeu8(b, offset + 1, value.G * 255)
		buffer.writeu8(b, offset + 2, value.B * 255)
	end,
	read = function(b: buffer, offset: number)
		local red = buffer.readu8(b, offset)
		local green = buffer.readu8(b, offset + 1)
		local blue = buffer.readu8(b, offset + 2)

		return Color3.fromRGB(red, green, blue)
	end,
	size = function()
		return 3
	end,

	validate = function(value: unknown)
		return typeof(value) == "Color3"
	end,
} :: Types.Schema<Color3>
