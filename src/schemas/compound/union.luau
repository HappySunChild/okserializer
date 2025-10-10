local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(...: types.Schema<any>): types.Schema<any>
	local schemas = { ... }

	local _id = formats.determine(#schemas)
	local id_write, id_read, id_size = _id.write, _id.read, _id.size

	local function getSchemaForValue<V>(value: V): (number?, types.Schema<V>?)
		for index, schema in schemas do
			if schema.validate(value) then
				return index, schema
			end
		end

		return nil, nil
	end

	return Schema "union" {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = getSchemaForValue(value)

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
			local _, schema = getSchemaForValue(value)

			if schema == nil then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema.size(value)

			return id_size + size
		end,

		validate = function(value: unknown): boolean
			return getSchemaForValue(value) ~= nil
		end,
	}
end
