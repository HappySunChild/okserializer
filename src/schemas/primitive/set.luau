local formats = require "../../formats"
local types = require "../../types"

local Schema = require "../Schema"

return function(set: { any }): types.Schema<any>
	-- note to future self, because i got really confused just now,
	-- this automatically determines the format
	-- sets don't store multiple values, they only store one value from a set of values
	local _info = formats.determine(#set)
	local write, read, size = _info.write, _info.read, _info.size

	local keys = {}

	for key, value in set do
		keys[value] = key
	end

	return Schema "set" {
		write = function(b: buffer, offset: number, value: any)
			local index = keys[value]

			if not index then
				error(`Value '{value}' not found in set!`)
			end

			write(b, offset, index)
		end,
		read = function(b: buffer, offset: number): any
			local index = read(b, offset)

			return set[index]
		end,
		size = function(): number
			return size
		end,

		validate = function(value: any): boolean
			return value ~= nil and keys[value] ~= nil
		end,
	}
end
