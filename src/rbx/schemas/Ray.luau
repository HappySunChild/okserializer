const types = require("../../types")

const Vector3_schema = require("./Vector3")

const function Ray_schema(vec_spec: types.NumberTypeSpec?): types.Schema<Ray>
	const vec = Vector3_schema(vec_spec)
	const vec_write, vec_read, vec_size = vec.write, vec.read, vec.alloc_size(Vector3.zero)

	const schema_size = vec_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: Ray): number
			vec_write(b, offset, value.Origin)
			vec_write(b, offset + vec_size, value.Direction)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, Ray)
			const _, origin = vec_read(b, offset)
			const _, direction = vec_read(b, offset + vec_size)
			return schema_size, Ray.new(origin, direction)
		end,
		alloc_size = @native function(): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Ray" then
				return false, `expected value of type Ray, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return Ray_schema
