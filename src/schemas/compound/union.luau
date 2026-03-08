local types = require("../../types")

local determine_spec = require("../../utility/determine_spec")

return function(...: types.Schema<any>): types.Schema<any>
	local schemas = { ... }

	local id_spec = determine_spec(#schemas)
	local id_write, id_read, id_size = id_spec.write, id_spec.read, id_spec.size

	local function to_schema<V>(value: V): (number?, types.Schema<V>?)
		for index, schema in schemas do
			if schema.validate(value) then
				return index, schema
			end
		end

		return nil, nil
	end

	return {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = to_schema(value)

			if index == nil or schema == nil then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			id_write(b, offset, index)

			schema.write(b, offset + id_size, value)
		end,
		read = function(b: buffer, offset: number): any
			local index = id_read(b, offset)
			local schema = schemas[index]

			return schema.read(b, offset + id_size)
		end,
		size = function(value: any): number
			local _, schema = to_schema(value)

			if schema == nil then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema.size(value)

			return id_size + size
		end,
		validate = function(value: unknown): boolean
			return to_schema(value) ~= nil
		end,
	}
end
