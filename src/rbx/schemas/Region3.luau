const types = require("../../types")

const Vector3_schema = require("./Vector3")

const function Region3_schema(vec_spec: types.NumberTypeSpec?): types.Schema<Region3>
	const vec = Vector3_schema(vec_spec)
	const vec_write, vec_read, vec_size = vec.write, vec.read, vec.alloc_size(Vector3.zero)

	const schema_size = vec_size * 2

	return {
		write = @native function(b: buffer, offset: number, value: Region3): number
			const reg_cf, reg_size = value.CFrame, value.Size
			const reg_min, reg_max = reg_cf * -reg_size / 2, reg_cf * reg_size / 2

			vec_write(b, offset, reg_min)
			vec_write(b, offset + vec_size, reg_max)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, Region3)
			const _, min = vec_read(b, offset)
			const _, max = vec_read(b, offset + vec_size)
			return schema_size, Region3.new(min, max)
		end,
		alloc_size = @native function(value: Region3): number
			return schema_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "Region3" then
				return false, `expected value of type Region3, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return Region3_schema
