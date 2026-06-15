const types = require("../../types")

const sort_with_order = require("../../utility/sort_with_order")

-- Originally going to be called "bitpacked", but that's not very descriptive (like bitstruct is any better)
-- Stores unsigned integers with varying bit-widths in a compact manner.

-- Bit-width refers to the number of bits used to store a number.
-- For example 10 would have a bit width of 4, since in base 2, 10 is representated as 1010 which takes 4 bits.

const function bitstruct_schema<T>(width_dict: { [keyof<T>]: number }, order: { keyof<T> }?): types.Schema<T>
	const keys = {}
	local total_bit_count = 0

	for key, width in width_dict do
		total_bit_count += width
		table.insert(keys, key :: keyof<T>)
	end

	sort_with_order(keys, order)

	const byte_count = math.ceil(total_bit_count / 8)

	return {
		write = function(b: buffer, offset: number, input_dict: T)
			local bit_offset = offset * 8

			for _, key in keys do
				const bit_width = width_dict[key]
				const value = input_dict[key] or 0 -- false/nil is encoded as 0

				buffer.writebits(b, bit_offset, bit_width, value)

				bit_offset += bit_width
			end
		end,
		read = function(b: buffer, offset: number): T
			const output_dict = {}
			local bit_offset = offset * 8

			for _, key in keys do
				const bit_width = width_dict[key]

				output_dict[key] = buffer.readbits(b, bit_offset, bit_width)

				bit_offset += bit_width
			end

			return output_dict
		end,
		size = function(): number
			return byte_count
		end,
		validate = function(value: unknown): (boolean, string?)
			if type(value) ~= "table" then
				return false, `expected value of type table, got {type(value)}`
			end

			return true, nil
		end,
	}
end

return bitstruct_schema
