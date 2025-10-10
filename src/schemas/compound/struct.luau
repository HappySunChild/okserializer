local types = require "../../types"

local Schema = require "../Schema"

return function(
	schema_dict: { [any]: types.Schema<unknown> },
	order: { any }?
): types.Schema<any>
	local keys = {}

	for key in schema_dict do
		table.insert(keys, key)
	end

	if type(order) == "table" then
		table.sort(keys, function(a: any, b: any)
			local a_index = table.find(order, a) or 0
			local b_index = table.find(order, b) or 0

			return a_index < b_index
		end)
	else
		-- ensure consistant order, this will break when adding/remove
		-- keys though, so maybe try to avoid doing that?
		table.sort(keys)
	end

	return Schema "struct" {
		write = function(b: buffer, offset: number, dict: any)
			for _, key in keys do
				local schema = schema_dict[key]
				local value = dict[key]

				schema.write(b, offset, value)

				offset += schema.size(value)
			end
		end,
		read = function(b: buffer, offset: number): any
			local result = {}

			for _, key in keys do
				local schema = schema_dict[key]
				local value = schema.read(b, offset)

				result[key] = value

				offset += schema.size(value)
			end

			return result
		end,
		size = function(dict: any): number
			local byteCount = 0

			for _, key in keys do
				local schema = schema_dict[key]
				local value = dict[key]

				byteCount += schema.size(value)
			end

			return byteCount
		end,

		validate = function(value: unknown): boolean
			if type(value) ~= "table" then
				return false
			end

			value = value :: { [any]: any }

			for key, schema in schema_dict do
				if not schema.validate(value[key]) then
					return false
				end
			end

			return true
		end,
	}
end
