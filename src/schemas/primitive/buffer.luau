local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(len_format: types.UIntByteFormat): types.Schema<buffer>
	local _len = getFormatInfo(len_format, "u16")
	local len_write, len_read, len_size = _len.write, _len.read, _len.size

	return Schema "buffer" {
		write = function(b: buffer, offset: number, value: buffer)
			local count = buffer.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, buffer.tostring(value))
		end,
		read = function(b: buffer, offset: number): buffer
			local count = len_read(b, offset)

			return buffer.fromstring(buffer.readstring(b, offset + len_size, count))
		end,
		size = function(value: buffer): number
			return len_size + buffer.len(value)
		end,

		validate = function(value: unknown): boolean
			return type(value) == "buffer"
		end,
	}
end
