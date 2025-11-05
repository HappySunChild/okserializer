local types = require "../../types"

local Schema = require "../Schema"

return Schema {
	write = function(b: buffer, offset: number, value: Color3)
		buffer.writeu8(b, offset, value.R * 255)
		buffer.writeu8(b, offset + 1, value.G * 255)
		buffer.writeu8(b, offset + 2, value.B * 255)
	end,
	read = function(b: buffer, offset: number): Color3
		return Color3.fromRGB(
			buffer.readu8(b, offset),
			buffer.readu8(b, offset + 1),
			buffer.readu8(b, offset + 2)
		)
	end,
	size = function(): number
		return 3
	end,

	validate = function(value: unknown): boolean
		return typeof(value) == "Color3"
	end,
} :: types.Schema<Color3>
