local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

local isArray = require "../../utility/isArray"

return function<T>(schema: types.Schema<T>, len_format: types.UIntFormat?): types.Schema<{ T }>
	local _len = formats.get(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	return Schema "array" {
		write = function(b: buffer, offset: number, array: { T })
			len_write(b, offset, #array)

			offset += len_size

			for _, value in array do
				schema.write(b, offset, value)
				offset += schema.size(value)
			end
		end,
		read = function(b: buffer, offset: number): { T }
			local count = len_read(b, offset)

			offset += len_size

			local array = table.create(count)

			for i = 1, count do
				array[i] = schema.read(b, offset)
				offset += schema.size(array[i])
			end

			return array
		end,
		size = function(array: { T }): number
			local byte_count = len_size

			for _, value in array do
				byte_count += schema.size(value)
			end

			return byte_count
		end,

		validate = function(array: unknown): boolean
			if not isArray(array) then
				return false
			end

			for _, value in array :: { T } do
				if not schema.validate(value) then
					return false
				end
			end

			return true
		end,
	}
end
