local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local isArray = require(package.Utility.isArray)

return function(bitCount: number): Types.Schema<{ boolean }>
	local byteCount = math.ceil(bitCount / 8)

	return Schema "bitarray" {
		write = function(b: buffer, offset: number, array: { boolean })
			for byteOffset = 0, byteCount - 1 do
				local bundled = 0

				for bitOffset = 0, 7 do
					local index = byteOffset * 8 + bitOffset + 1

					if index > bitCount then
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
		read = function(b: buffer, offset: number)
			local array = {}

			for byteOffset = 0, byteCount - 1 do
				local bundled = buffer.readu8(b, offset + byteOffset)

				for bitOffset = 0, 7 do
					local index = byteOffset * 8 + bitOffset + 1

					if index > bitCount then
						break
					end

					array[index] = bit32.btest(bundled, 2 ^ bitOffset)
				end
			end

			return array
		end,
		size = function()
			return byteCount
		end,

	}
end
