local formats = require("../../formats")
local types = require("../../types")

local DEFAULT_LEN_FORMAT = formats.u16

return function(len_format: types.UIntFormat?): types.Schema<buffer>
	local len_spec = if len_format == nil then DEFAULT_LEN_FORMAT else formats[len_format]
	local len_write, len_read, len_size = len_spec.write, len_spec.read, len_spec.size

	return {
		write = function(b: buffer, offset: number, value: buffer)
			len_write(b, offset, buffer.len(value))
			buffer.writestring(b, offset + len_size, buffer.tostring(value))
		end,
		read = function(b: buffer, offset: number): buffer
			local count = len_read(b, offset)
			local new_buffer = buffer.create(count)

			buffer.copy(new_buffer, 0, b, offset, count)

			return new_buffer
		end,
		size = function(value: buffer): number
			return len_size + buffer.len(value) % (len_spec.max + 1)
		end,
		validate = function(value: unknown): boolean
			return type(value) == "buffer"
		end,
	}
end
