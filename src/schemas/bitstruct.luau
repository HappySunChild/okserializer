-- originally going to be called "bitpacked", but that's not very descriptive (like bitstruct is any better)
-- stores unsigned integers with varying bit-widths in a compact manner.

-- bit-width refers to the number of bits used to store a number.
-- for example 10 would have a bit width of 4, since in base 2, 10 is representated as 1010 which takes 4 bits.

const okserde = require("../types")

const sort_with_order = require("../utility/sort_with_order")

const function bitstruct_schema<T>(shape: { [keyof<T>]: number }, order: { keyof<T> }?): okserde.Schema<T>
	const keys = {}
	local total_bit_count = 0

	for key, width in shape do
		total_bit_count += width
		table.insert(keys, key :: any)
	end

	sort_with_order(keys :: { any }, order)

	const byte_count = math.ceil(total_bit_count / 8)

	return {
		write = @native function(b: buffer, offset: number, in_struct: T | any): number
			local bit_offset = offset * 8

			for _, key in keys do
				const bit_width = shape[key]
				const value = in_struct[key] or 0 -- false/nil is encoded as 0

				buffer.writebits(b, bit_offset, bit_width, value)

				bit_offset += bit_width
			end

			return byte_count
		end,
		read = @native function(b: buffer, offset: number): (number, T)
			const out_struct = {}
			local bit_offset = offset * 8

			for _, key in keys do
				const bit_width = shape[key]

				out_struct[key] = buffer.readbits(b, bit_offset, bit_width)
				bit_offset += bit_width
			end

			return byte_count, out_struct
		end,
		size = @native function(): number
			return byte_count
		end,
		validate = @native function(in_struct: any): (boolean, string?)
			if type(in_struct) ~= "table" then
				return false, `expected value of type table, got {type(in_struct)}`
			end

			for key in shape do
				const value_type = type(in_struct[key])

				if value_type ~= "number" then
					return false,
						`invalid value for key {key}; expected value of type number, got {value_type}`
				end
			end

			return true, nil
		end,
	}
end

return bitstruct_schema
