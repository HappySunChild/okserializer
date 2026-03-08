local types = require("../../types")

local Vector3_schema = require("./Vector3")

return function(vec_spec: types.NumberTypeSpec?): types.Schema<Region3>
	local vec = Vector3_schema(vec_spec)
	local vec_write, vec_read, vec_size = vec.write, vec.read, vec.size(Vector3.zero)

	return {
		write = function(b: buffer, offset: number, value: Region3)
			local reg_cf, reg_size = value.CFrame, value.Size
			local reg_min, reg_max = reg_cf * -reg_size / 2, reg_cf * reg_size / 2

			vec_write(b, offset, reg_min)
			vec_write(b, offset + vec_size, reg_max)
		end,
		read = function(b: buffer, offset: number): Region3
			return Region3.new(vec_read(b, offset), vec_read(b, offset + vec_size))
		end,
		size = function(value: Region3): number
			return vec_size * 2
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "Region3"
		end,
	}
end
