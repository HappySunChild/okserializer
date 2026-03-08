local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_LEN_SPEC = specs.u16

local is_array = require("../../utility/is_array")

return function<T>(schema: types.Schema<T>, len_spec: types.NumberTypeSpec?): types.Schema<{ T }>
	local len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	local len_write, len_read, len_size = len.write, len.read, len.size

	local schema_write, schema_read, schema_size, schema_validate =
		schema.write, schema.read, schema.size, schema.validate

	return {
		write = function(b: buffer, offset: number, array: { T })
			len_write(b, offset, #array)

			offset += len_size

			for _, value in array do
				schema_write(b, offset, value)
				offset += schema_size(value)
			end
		end,
		read = function(b: buffer, offset: number): { T }
			local count = len_read(b, offset)

			offset += len_size

			local array = table.create(count)

			for i = 1, count do
				array[i] = schema_read(b, offset)
				offset += schema_size(array[i])
			end

			return array
		end,
		size = function(array: { T }): number
			local byte_count = len_size

			for _, value in array do
				byte_count += schema_size(value)
			end

			return byte_count
		end,
		validate = function(array: unknown): boolean
			if not is_array(array) then
				return false
			end

			for _, value in array :: { T } do
				if not schema_validate(value) then
					return false
				end
			end

			return true
		end,
	}
end
