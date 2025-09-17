local types = require "../../types"

local Schema = require "../Schema"

local isArray = require "../../Utility/isArray"

return function(bit_count: number): types.Schema<{ boolean }>
	local byteCount = math.ceil(bit_count / 8)

	return Schema "bitarray" {
		write = function(b: buffer, offset: number, array: { boolean })
			for byteOffset = 0, byteCount - 1 do
				local bundled = 0

				for bitOffset = 0, 7 do
					local index = byteOffset * 8 + bitOffset + 1

					if index > bit_count then
						break
					end

					if array[index] == false then
						continue
					end

					bundled += 2 ^ bitOffset
				end

				buffer.writeu8(b, offset + byteOffset, bundled)
			end
		end,
		read = function(b: buffer, offset: number): { boolean }
			local array = {}

			for byteOffset = 0, byteCount - 1 do
				local bundled = buffer.readu8(b, offset + byteOffset)

				for bitOffset = 0, 7 do
					local index = byteOffset * 8 + bitOffset + 1

					if index > bit_count then
						break
					end

					array[index] = bit32.btest(bundled, 2 ^ bitOffset)
				end
			end

			return array
		end,
		size = function(): number
			return byteCount
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
