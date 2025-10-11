local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(format: types.NumberFormat?): types.Schema<number>
	local _info = formats.get(format, "f32")
	local write, read, size = _info.write, _info.read, _info.size

	return Schema "number" {
		write = write,
		read = read,
		size = @native function(): number
			return size
		end,

		validate = @native function(value: unknown): boolean
			return type(value) == "number"
		end,
	}
end
