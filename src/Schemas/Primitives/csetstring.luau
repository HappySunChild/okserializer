local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(cset: string, lenFormat: types.UIntByteFormat?): types.Schema<string>
	assert(string.len(cset) < 256, "Maximum character set size is 255 characters.")

	local len = getFormatInfo(lenFormat, "u16")
	local character_bit_size = math.ceil(math.log(string.len(cset), 2))

	local function to_index(char: string): number
		return string.find(cset, char, 1, true)
	end

	local function to_character(index: number)
		return string.sub(cset, index, index)
	end

	local function filter(text: string)
		local output = ""

		for i = 1, string.len(text) do
			local char = string.sub(text, i, i)

			if to_index(char) then
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

			local bit_offset = (offset + len.size) * 8

			for i = 1, count do
				local char = string.sub(filtered, i, i)
				local index = to_index(char) - 1

				buffer.writebits(b, bit_offset, character_bit_size, index)

				bit_offset += character_bit_size
			end
		end,
		read = function(b: buffer, offset: number): string
			local output = ""
			local count = len.read(b, offset)
			local bit_offset = (offset + len.size) * 8

			for _ = 1, count do
				local index = buffer.readbits(b, bit_offset, character_bit_size) + 1
				local char = to_character(index)

				output ..= char

				bit_offset += character_bit_size
			end

			return output
		end,
		size = function(value: string): number
			local filtered = filter(value)
			local count = string.len(filtered)
			local byte_count = math.ceil(character_bit_size * count / 8)

			return len.size + byte_count
		end,

		validate = function(v: unknown): boolean
			return type(v) == "string"
		end,
	}
end
