local types = require "../../types"

local Schema = require "../Schema"

local isArray = require "../../utility/isArray"

return function(flag_count: number): types.Schema<{ boolean }>
	local byte_count = math.ceil(flag_count / 8)

	return Schema "flags" {
		write = function(b: buffer, offset: number, value: { boolean })
			local bit_offset = offset * 8

			for i = 1, flag_count do
				buffer.writebits(b, bit_offset, 1, value[i] and 1 or 0)

				bit_offset += 1
			end
		end,
		read = function(b: buffer, offset: number): { boolean }
			local flags = {}
			local bit_offset = offset * 8

			for i = 1, flag_count do
				flags[i] = buffer.readbits(b, bit_offset, 1) == 1

				bit_offset += 1
			end

			return flags
		end,
		size = function(): number
			return byte_count
		end,

		validate = function(value: unknown): boolean
			if not isArray(value) then
				return false
			end

			for _, v in value :: { unknown } do
				if type(v) ~= "boolean" then
					return false
				end
			end

			return true
		end,
	}
end
