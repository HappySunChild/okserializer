local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(character_set: string, len_format: types.UIntFormat?): types.Schema<string>
	assert(string.len(character_set) < 256, "Maximum character set size is 255 characters.")

	local _len = formats.get(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	local bits_per_character = math.ceil(math.log(string.len(character_set), 2))

	local function toIndex(char: string): number
		return string.find(character_set, char, 1, true) or 0
	end

	local function toChar(index: number): string
		return string.sub(character_set, index, index)
	end

	local function filter(text: string): string
		local filtered = string.gsub(text, ".", function(char: string)
			if toIndex(char) then
				return char
			end

			return ""
		end)

		return filtered
	end

	return Schema {
		write = function(b: buffer, offset: number, value: string)
			local filtered = filter(value)
			local char_count = string.len(filtered)

			len_write(b, offset, char_count)

			local bit_offset = (offset + _len.size) * 8

			for i = 1, char_count do
				local char = string.sub(filtered, i, i)
				local index = toIndex(char) - 1

				buffer.writebits(b, bit_offset, bits_per_character, index)

				bit_offset += bits_per_character
			end
		end,
		read = function(b: buffer, offset: number): string
			local output = ""
			local char_count = len_read(b, offset)

			local bit_offset = (offset + _len.size) * 8

			for _ = 1, char_count do
				local index = buffer.readbits(b, bit_offset, bits_per_character) + 1
				local char = toChar(index)

				output ..= char

				bit_offset += bits_per_character
			end

			return output
		end,
		size = function(value: string): number
			local filtered = filter(value)
			local char_count = string.len(filtered)
			local byte_count = math.ceil(bits_per_character * char_count / 8) % (_len.max + 1)

			return len_size + byte_count
		end,

		validate = function(v: unknown): boolean
			return type(v) == "string"
		end,
	}
end
