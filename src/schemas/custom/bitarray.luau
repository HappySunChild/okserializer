local types = require("../../types")

local get_format = require("../../utility/get_format")
local is_array = require("../../utility/is_array")

return function(bit_width: number, len_format: types.UIntFormat?): types.Schema<{ number }>
	local len_spec = get_format(len_format, "u16")
	local len_write, len_read, len_size = len_spec.write, len_spec.read, len_spec.size

	return {
		write = @native function(b: buffer, offset: number, value: { number })
			len_write(b, offset, #value)

			local bit_offset = (offset + len_size) * 8

			for _, num in value do
				buffer.writebits(b, bit_offset, bit_width, num)
				bit_offset += bit_width
			end
		end,
		read = @native function(b: buffer, offset: number): { number }
			local count = len_read(b, offset)
			local output = table.create(count, 0)

			local bit_offset = (offset + len_size) * 8

			for i = 1, count do
				output[i] = buffer.readbits(b, bit_offset, bit_width)
				bit_offset += bit_width
			end

			return output
		end,
		size = @native function(value: { number }): number
			local byte_count = math.ceil(#value * bit_width / 8) % (len_spec.max + 1)

			return len_size + byte_count
		end,
		validate = @native function(value: unknown): boolean
			if not is_array(value) then
				return false
			end

			for _, v in value :: { unknown } do
				if type(v) ~= "number" then
					return false
				end
			end

			return true
		end,
	}
end
