const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_LEN_SPEC = specs.u16

const is_array = require("../../utility/is_array")

const function array_schema<T>(schema: types.Schema<T>, len_spec: types.NumberTypeSpec?): types.Schema<{ T }>
	const len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	const len_write, len_read, len_size = len.write, len.read, len.size

	const schema_write, schema_read, schema_size, schema_validate =
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
			const count = len_read(b, offset)

			offset += len_size

			const output = table.create(count)

			for i = 1, count do
				output[i] = schema_read(b, offset)
				offset += schema_size(output[i])
			end

			return output
		end,
		size = function(array: { T }): number
			local byte_count = len_size

			for _, value in array do
				byte_count += schema_size(value)
			end

			return byte_count
		end,
		validate = function(array: unknown): (boolean, string?)
			if not is_array(array) then
				return false, "expected array value"
			end

			for index, element in array :: { T } do
				local ok, err = schema_validate(element)

				if not ok then
					return false, `invalid array element at index {index}:\n\t{err}`
				end
			end

			return true, nil
		end,
	}
end

return array_schema
