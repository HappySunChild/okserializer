local types = require "../../types"

local Schema = require "../Schema"

local isArray = require "../../Utility/isArray"

return function(bit_count: number): types.Schema<{ boolean }>
	local byte_count = math.ceil(bit_count / 8)

	return Schema "bitarray" {
		write = function(b: buffer, offset: number, array: { boolean })
			for byte_offset = 0, byte_count - 1 do
				local bundled = 0

				for bit_offset = 0, 7 do
					local index = byte_offset * 8 + bit_offset + 1

					if index > bit_count then
						break
					end

					if array[index] == false then
						continue
					end

					bundled += 2 ^ bit_offset
				end

				buffer.writeu8(b, offset + byte_offset, bundled)
			end
		end,
		read = function(b: buffer, offset: number): { boolean }
			local array = {}

			for byte_offset = 0, byte_count - 1 do
				local bundled = buffer.readu8(b, offset + byte_offset)

				for bit_offset = 0, 7 do
					local index = byte_offset * 8 + bit_offset + 1

					if index > bit_count then
						break
					end

					array[index] = bit32.btest(bundled, 2 ^ bit_offset)
				end
			end

			return array
		end,
		size = function(): number
			return byte_count
		end,

		validate = function(array: unknown): boolean
			if not isArray(array) then
				return false
			end

			for _, v in array do
				if type(v) ~= "boolean" then
					return false
				end
			end

			return true
		end,
	}
end
