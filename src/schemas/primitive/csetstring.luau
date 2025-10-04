local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(character_set: string, len_format: types.UIntByteFormat?): types.Schema<string>
	assert(string.len(character_set) < 256, "Maximum character set size is 255 characters.")

	local _len = getFormatInfo(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	local character_bit_size = math.ceil(math.log(string.len(character_set), 2))

	local function toIndex(char: string): number
		return string.find(character_set, char, 1, true)
	end

	local function toChar(index: number)
		return string.sub(character_set, index, index)
	end

	local function filter(text: string)
		local output = ""

		output = string.gsub(text, ".", function(char: string)
			if toIndex(char) then
				return char
			end

			return ""
		end)

		return output
	end

	return Schema "csetstring" {
		write = function(b: buffer, offset: number, value: string)
			local filtered = filter(value)
			local count = string.len(filtered)

			len_write(b, offset, count)

			local bit_offset = (offset + _len.size) * 8

			for i = 1, count do
				local char = string.sub(filtered, i, i)
				local index = toIndex(char) - 1

				buffer.writebits(b, bit_offset, character_bit_size, index)

				bit_offset += character_bit_size
			end
		end,
		read = function(b: buffer, offset: number): string
			local output = ""
			local count = len_read(b, offset)
			local bit_offset = (offset + _len.size) * 8

			for _ = 1, count do
				local index = buffer.readbits(b, bit_offset, character_bit_size) + 1
				local char = toChar(index)

				output ..= char

				bit_offset += character_bit_size
			end

			return output
		end,
		size = function(value: string): number
			local filtered = filter(value)
			local count = string.len(filtered)
			local byte_count = math.ceil(character_bit_size * count / 8)

			return len_size + byte_count
		end,

		validate = function(v: unknown): boolean
			return type(v) == "string"
		end,
	}
end
