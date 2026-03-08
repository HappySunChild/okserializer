local specs = require("../../specs")
local types = require("../../types")

local is_array = require("../../utility/is_array")

local DEFAULT_LEN_SPEC = specs.u8

return function(bit_width: number, len_spec: types.NumberTypeSpec?): types.Schema<{ number }>
	local len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	local len_write, len_read, len_size = len.write, len.read, len.size

	return {
		write = function(b: buffer, offset: number, value: { number })
			len_write(b, offset, #value)

			local bit_offset = (offset + len_size) * 8

			for _, num in value do
				buffer.writebits(b, bit_offset, bit_width, num)
				bit_offset += bit_width
			end
		end,
		read = function(b: buffer, offset: number): { number }
			local count = len_read(b, offset)
			local output = table.create(count, 0)

			local bit_offset = (offset + len_size) * 8

			for i = 1, count do
				output[i] = buffer.readbits(b, bit_offset, bit_width)
				bit_offset += bit_width
			end

			return output
		end,
		size = function(value: { number }): number
			return len_size + math.ceil(#value * bit_width / 8) % (len.max + 1)
		end,
		validate = function(value: unknown): boolean
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
