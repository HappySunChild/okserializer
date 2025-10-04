local types = require "../../types"

local determineFormat = require "../../utility/determineFormat"
local getFormatInfo = require "../../utility/getFormatInfo"

local Schema = require "../Schema"

return function(...: types.Schema<any>): types.Schema<any>
	local schemas = { ... }

	local _info = getFormatInfo(determineFormat(#schemas), "u8")
	local write, read, size = _info.write, _info.read, _info.size

	local function get_schema<V>(value: V): (number?, types.Schema<V>?)
		for index, schema in schemas do
			if schema._validate(value) then
				return index, schema
			end
		end

		return nil
	end

	return Schema "union" {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = get_schema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			write(b, offset, index)

			schema._write(b, offset + size, value)
		end,
		read = function(b: buffer, offset: number): any
			local index = read(b, offset)
			local schema = schemas[index]

			return schema._read(b, offset + size)
		end,
		size = function(value: any): number
			local _, schema = get_schema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema._size(value)

			return size + size
		end,

		validate = function(value: unknown): boolean
			return get_schema(value) ~= nil
		end,
	}
end
