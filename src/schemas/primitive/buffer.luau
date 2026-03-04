local types = require("../../types")

local get_format = require("../../utility/get_format")

return function(len_format: types.UIntFormat): types.Schema<buffer>
	local len_spec = get_format(len_format, "u16")
	local len_write, len_read, len_size = len_spec.write, len_spec.read, len_spec.size

	return {
		write = @native function(b: buffer, offset: number, value: buffer)
			len_write(b, offset, buffer.len(value))
			buffer.writestring(b, offset + len_size, buffer.tostring(value))
		end,
		read = @native function(b: buffer, offset: number): buffer
			local count = len_read(b, offset)
			local new_buffer = buffer.create(count)

			buffer.copy(new_buffer, 0, b, offset, count)

			return new_buffer
		end,
		size = @native function(value: buffer): number
			return len_size + buffer.len(value) % (len_spec.max + 1)
		end,
		validate = @native function(value: unknown): boolean
			return type(value) == "buffer"
		end,
	}
end
