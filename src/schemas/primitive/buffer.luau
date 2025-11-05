local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(len_format: types.UIntFormat): types.Schema<buffer>
	local _len = formats.get(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	return Schema {
		write = @native function(b: buffer, offset: number, value: buffer)
			local count = buffer.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, buffer.tostring(value))
		end,
		read = @native function(b: buffer, offset: number): buffer
			local count = len_read(b, offset)
			local output_buffer = buffer.create(count)

			buffer.copy(output_buffer, 0, b, offset, count)

			return output_buffer
		end,
		size = @native function(value: buffer): number
			return len_size + buffer.len(value) % (_len.max + 1)
		end,

		validate = @native function(value: unknown): boolean
			return type(value) == "buffer"
		end,
	}
end
