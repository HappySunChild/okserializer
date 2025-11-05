local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(format: types.NumberFormat?): types.Schema<vector>
	local _spec = formats.get(format, "f32")
	local write, read, size = _spec.write, _spec.read, _spec.size

	return Schema {
		write = @native function(b: buffer, offset: number, value: vector)
			write(b, offset, value.x)
			write(b, offset + size, value.y)
			write(b, offset + size * 2, value.z)
		end,
		read = @native function(b: buffer, offset: number): vector
			local x = read(b, offset)
			local y = read(b, offset + size)
			local z = read(b, offset + size * 2)

			return vector.create(x, y, z)
		end,
		size = @native function(): number
			return size * 3
		end,

		validate = @native function(value: unknown): boolean
			return type(value) == "vector"
		end,
	}
end
