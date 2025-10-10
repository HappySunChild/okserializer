local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(format: types.NumberByteFormat): types.Schema<number>
	local _info = formats.get(format, "f32")
	local write, read, size = _info.write, _info.read, _info.size

	return Schema "number" {
		write = write,
		read = read,
		size = function(): number
			return size
		end,

		validate = function(v: unknown): boolean
			return type(v) == "number"
		end,
	}
end
