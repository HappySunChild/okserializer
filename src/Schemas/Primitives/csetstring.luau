local Types = require "../../Types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(cset: string, lenFormat: Types.UIntByteFormat?)
	assert(string.len(cset) < 256, "Maximum character set size is 255 characters.")

	local len = getFormatInfo(lenFormat, "u16")
	local charBitSize = math.ceil(math.log(string.len(cset), 2))

	local function toIndex(char: string)
		return string.find(cset, char, 1, true)
	end

	local function toChar(index: number)
		return string.sub(cset, index, index)
	end

	local function filter(text: string)
		local output = ""

		for i = 1, string.len(text) do
			local char = string.sub(text, i, i)

			if toIndex(char) then
				output ..= char
			end
		end

		return output
	end

	return Schema "csetstring" {
		write = function(b: buffer, offset: number, value: string)
			local filtered = filter(value)
			local count = string.len(filtered)

			len.write(b, offset, count)

			local bitOffset = (offset + len.size) * 8

			for i = 1, count do
				local char = string.sub(filtered, i, i)
				local index = toIndex(char) - 1

				buffer.writebits(b, bitOffset, charBitSize, index)

				bitOffset += charBitSize
			end
		end,
		read = function(b: buffer, offset: number)
			local output = ""
			local count = len.read(b, offset)
			local bitOffset = (offset + len.size) * 8

			for _ = 1, count do
				local index = buffer.readbits(b, bitOffset, charBitSize) + 1
				local char = toChar(index)

				output ..= char

				bitOffset += charBitSize
			end

			return output
		end,
		size = function(value: string)
			local filtered = filter(value)
			local count = string.len(filtered)
			local byteCount = math.ceil(charBitSize * count / 8)

			return len.size + byteCount
		end,

		validate = function(v: unknown)
			return type(v) == "string"
		end,
	}
end
