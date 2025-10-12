local types = require "../../types"

local sortWithOrder = require "../../utility/sortWithOrder"

local Schema = require "../Schema"

type StructInfo<K, V> = { [K]: types.Schema<V> }

return function<K, V>(schema_dict: StructInfo<K, V>, order: { K }?): types.Schema<{ [K]: V }>
	local keys = {}

	for key in schema_dict do
		table.insert(keys, key)
	end

	sortWithOrder(keys, order)

	return Schema "struct" {
		write = function(b: buffer, offset: number, input_dict: { [K]: V })
			for _, key in keys do
				local schema = schema_dict[key]
				local value = input_dict[key]

				schema.write(b, offset, value)

				offset += schema.size(value)
			end
		end,
		read = function(b: buffer, offset: number): { [K]: V }
			local output_dict = {}

			for _, key in keys do
				local schema = schema_dict[key]
				local value = schema.read(b, offset)

				output_dict[key] = value

				offset += schema.size(value)
			end

			return output_dict
		end,
		size = function(input_dict: { [K]: V }): number
			local byteCount = 0

			for _, key in keys do
				local schema = schema_dict[key]
				local value = input_dict[key]

				byteCount += schema.size(value)
			end

			return byteCount
		end,

		validate = function(value: unknown): boolean
			if type(value) ~= "table" then
				return false
			end

			value = value :: { [K]: V }

			for key, schema in schema_dict do
				if not schema.validate(value[key]) then
					return false
				end
			end

			return true
		end,
	}
end
