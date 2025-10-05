local types = require "../../types"

local determineFormat = require "../../utility/determineFormat"
local getFormatInfo = require "../../utility/getFormatInfo"

local Schema = require "../Schema"

return function(...: types.Schema<any>): types.Schema<any>
	local schemas = { ... }

	local _id = getFormatInfo(determineFormat(#schemas), "u8")
	local id_write, id_read, id_size = _id.write, _id.read, _id.size

	local function getSchemaForValue<V>(value: V): (number?, types.Schema<V>?)
		for index, schema in schemas do
			if schema._validate(value) then
				return index, schema
			end
		end

		return nil
	end

	return Schema "union" {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = getSchemaForValue(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			id_write(b, offset, index)

			schema._write(b, offset + id_size, value)
		end,
		read = function(b: buffer, offset: number): any
			local index = id_read(b, offset)
			local schema = schemas[index]

			return schema._read(b, offset + id_size)
		end,
		size = function(value: any): number
			local _, schema = getSchemaForValue(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema._size(value)

			return id_size + size
		end,

		validate = function(value: unknown): boolean
			return getSchemaForValue(value) ~= nil
		end,
	}
end
