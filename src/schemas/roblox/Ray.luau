local types = require("../../types")

local Vector3_schema = require("./Vector3")

return function(vec_spec: types.NumberTypeSpec?): types.Schema<Ray>
	local vec = Vector3_schema(vec_spec)
	local vec_write, vec_read, vec_size = vec.write, vec.read, vec.size(Vector3.zero)

	return {
		write = function(b: buffer, offset: number, value: Ray)
			vec_write(b, offset, value.Origin)
			vec_write(b, offset + vec_size, value.Direction)
		end,
		read = function(b: buffer, offset: number): Ray
			return Ray.new(vec_read(b, offset), vec_read(b, offset + vec_size))
		end,
		size = function(): number
			return vec_size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "Ray"
		end,
	}
end
