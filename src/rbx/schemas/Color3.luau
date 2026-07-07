local types = require("../../types")

const Color3_schema: types.Schema<Color3> = {
	write = @native function(b: buffer, offset: number, value: Color3): number
		buffer.writeu8(b, offset, value.R * 255)
		buffer.writeu8(b, offset + 1, value.G * 255)
		buffer.writeu8(b, offset + 2, value.B * 255)
		return 3
	end,
	read = @native function(b: buffer, offset: number): (number, Color3)
		return 3,
			Color3.fromRGB(
				buffer.readu8(b, offset),
				buffer.readu8(b, offset + 1),
				buffer.readu8(b, offset + 2)
			)
	end,
	alloc_size = @native function(): number
		return 3
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Color3" then
			return false, `expected value of type Color3, got {typeof(value)}`
		end

		return true, nil
	end,
}

return Color3_schema
