const specs = require("../specs")
const okserde = require("../types")

const is_array = require("../utility/is_array")

const DEFAULT_LEN_SPEC = specs.u8

const function bitarray_schema(
	bit_width: number,
	len_spec: okserde.NumberTypeSpec?
): okserde.Schema<{ number }>
	const len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	const len_write, len_read, len_size = len.write, len.read, len.size

	return {
		write = @native function(b: buffer, offset: number, value: { number }): number
			len_write(b, offset, #value)

			local bit_offset = (offset + len_size) * 8

			for _, num in value do
				buffer.writebits(b, bit_offset, bit_width, num)
				bit_offset += bit_width
			end

			return math.ceil(bit_offset / 8)
		end,
		read = @native function(b: buffer, offset: number): (number, { number })
			const count = len_read(b, offset)
			const output = table.create(count, 0)

			local bit_offset = (offset + len_size) * 8

			for i = 1, count do
				output[i] = buffer.readbits(b, bit_offset, bit_width)
				bit_offset += bit_width
			end

			return math.ceil(bit_offset / 8), output
		end,
		alloc_size = @native function(value: { number }): number
			return len_size + math.ceil(#value * bit_width / 8) % (len.max + 1)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if not is_array(value) then
				return false, "expected array value"
			end

			for _, element in value :: { unknown } do
				if type(element) ~= "number" then
					return false, "expected array to only contain numbers"
				end
			end

			return true, nil
		end,
	}
end

return bitarray_schema
