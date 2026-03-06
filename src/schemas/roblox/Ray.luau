local types = require("../../types")

local Vector3_schema = require("./Vector3")

return function(format: types.NumberFormat?): types.Schema<Ray>
	local vec_schema = Vector3_schema(format)
	local write, read, size = vec_schema.write, vec_schema.read, vec_schema.size(Vector3.zero)

	return {
		write = function(b: buffer, offset: number, value: Ray)
			write(b, offset, value.Origin)
			write(b, offset + size, value.Direction)
		end,
		read = function(b: buffer, offset: number): Ray
			return Ray.new(read(b, offset), read(b, offset + size))
		end,
		size = function(): number
			return size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "Ray"
		end,
	}
end
