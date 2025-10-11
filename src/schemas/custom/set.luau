local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function<T>(set: { T }): types.Schema<T>
	-- note to future self, because i got really confused just now,
	-- sets don't store multiple values, they only store one value from a set of possibilities
	local _info = formats.determine(#set)
	local write, read, size = _info.write, _info.read, _info.size

	local keys = {}

	for key, value in set do
		keys[value] = key
	end

	return Schema "set" {
		write = @native function(b: buffer, offset: number, value: T)
			local index = keys[value]

			if not index then
				error(`Value '{value}' not found in set!`)
			end

			write(b, offset, index)
		end,
		read = @native function(b: buffer, offset: number): T
			local index = read(b, offset)

			return set[index]
		end,
		size = @native function(): number
			return size
		end,

		validate = @native function(value: unknown): boolean
			return value ~= nil and keys[value] ~= nil
		end,
	}
end
