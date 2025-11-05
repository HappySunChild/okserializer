local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(format: types.NumberFormat?): types.Schema<number>
	local _spec = formats.get(format, "f32")
	local write, read, size = _spec.write, _spec.read, _spec.size

	return Schema {
		write = write,
		read = read,
		size = @native function(): number
			return size
		end,

		validate = @native function(value: unknown): boolean
			return type(value) == "number"
		end,
	} :: types.Schema<number>
end
