local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_LEN_SPEC = specs.u16

return function(len_spec: types.NumberTypeSpec?): types.Schema<string>
	local len = if len_spec == nil then DEFAULT_LEN_SPEC else len_spec
	local len_write, len_read, len_size = len.write, len.read, len.size

	return {
		write = function(b: buffer, offset: number, value: string)
			local count = string.len(value)

			len_write(b, offset, count)
			buffer.writestring(b, offset + len_size, value, count)
		end,
		read = function(b: buffer, offset: number): string
			local count = len_read(b, offset)

			return buffer.readstring(b, offset + len_size, count)
		end,
		size = function(value: string): number
			return len_size + string.len(value) % (len.max + 1)
		end,
		validate = function(value: unknown): boolean
			return type(value) == "string"
		end,
	}
end
