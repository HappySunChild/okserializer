local types = require "../../types"

local sortWithOrder = require "../../utility/sortWithOrder"

local Schema = require "../Schema"

type BitStructInfo<K> = { [K]: number }

-- Originally going to be called "bitpacked", but that's not very descriptive (like bitstruct is any better)
-- Stores unsigned integers with varying bit-widths in a compact manner.

-- Bit-width refers to the number of bits used to store a number.
-- For example 10 would have a bit width of 4, since in base 2, 10 is representated as 1010 which takes 4 bits.

return function<K>(width_dict: BitStructInfo<K>, order: { K }?): types.Schema<{ [K]: number }>
	local keys = {}
	local total_bit_count = 0

	for key, width in width_dict do
		total_bit_count += width

		table.insert(keys, key :: K)
	end

	sortWithOrder(keys, order)

	local byte_count = math.ceil(total_bit_count / 8)

	return Schema "bitstruct" {
		write = function(b: buffer, offset: number, input_dict: { [K]: number })
			local bit_offset = offset * 8

			for _, key in keys do
				local bit_width = width_dict[key]
				local value = input_dict[key] or 0 -- false/nil is encoded as 0

				buffer.writebits(b, bit_offset, bit_width, value)

				bit_offset += bit_width
			end
		end,
		read = function(b: buffer, offset: number): { [K]: number }
			local output_dict = {}
			local bit_offset = offset * 8

			for _, key in keys do
				local bit_width = width_dict[key]

				output_dict[key] = buffer.readbits(b, bit_offset, bit_width)

				bit_offset += bit_width
			end

			return output_dict
		end,
		size = function(): number
			return byte_count
		end,

		validate = function(value: unknown): boolean
			if type(value) ~= "table" then
				return false
			end

			return true
		end,
	}
end
