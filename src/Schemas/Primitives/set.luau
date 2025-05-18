local Types = require "../../Types"

local Schema = require "../Schema"

local determineFormat = require "../../Utility/determineFormat"
local getFormatInfo = require "../../Utility/getFormatInfo"

return function(set: { unknown }): Types.Schema<unknown>
	-- note to future self, because i got really confused just now,
	-- this automatically determines the format
	-- sets don't store multiple values, they only store one value from a set of values
	local info = getFormatInfo(determineFormat(#set))
	local write = info.write
	local read = info.read
	local byteCount = info.size

	local keys = {}

	for key, value in set do
		keys[value] = key
	end

	return Schema "set" {
		write = function(b: buffer, offset: number, value: V)
			local index = keys[value]

			if not index then
				error(`Value '{value}' not found in set!`)
			end

			write(b, offset, index)
		end,
		read = function(b: buffer, offset: number)
			local index = read(b, offset)

			return set[index]
		end,
		size = function()
			return byteCount
		end,

		validate = function(value: unknown)
			return value ~= nil and keys[value] ~= nil
		end,
	}
end
