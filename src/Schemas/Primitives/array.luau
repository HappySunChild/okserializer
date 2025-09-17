local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"
local isArray = require "../../Utility/isArray"

return function<T>(schema: types.Schema<T>, lenFormat: types.UIntByteFormat?): types.Schema<{ T }>
	local len = getFormatInfo(lenFormat, "u16")

	return Schema "array" {
		write = function(b: buffer, offset: number, array: { T })
			len.write(b, offset, #array)

			offset += len.size

			for _, value in array do
				schema._write(b, offset, value)
				offset += schema._size(value)
			end
		end,
		read = function(b: buffer, offset: number): { T }
			local length = len.read(b, offset)
			offset += len.size

			local array = {}

			for i = 1, length do
				array[i] = schema._read(b, offset)
				offset += schema._size(array[i])
			end

			return array
		end,
		size = function(array: { T }): number
			local byteCount = len.size

			for _, value in array do
				byteCount += schema._size(value)
			end

			return byteCount
		end,

		validate = function(array: unknown): boolean
			if not isArray(array) then
				return false
			end

			for _, value in array do
				if not schema._validate(value) then
					return false
				end
			end

			return true
		end,
	}
end
