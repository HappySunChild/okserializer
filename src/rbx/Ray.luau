const okserde = require("../types")

const Vector3_schema = require("./Vector3")

const function Ray_schema(vec_enc: okserde.NumberEncoding?): okserde.StaticSchema<Ray>
	const vec = Vector3_schema(vec_enc)
	const vec_write, vec_read, vec_size = vec.write, vec.read, vec.static_size

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
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Ray" then
				return false, `expected value of type Ray, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = schema_size,
	}
end

return Ray_schema
