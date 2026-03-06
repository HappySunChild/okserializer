local types = require("../../types")

local determine_format = require("../../utility/determine_format")

return function<T>(set: { T }): types.Schema<T>
	local spec = determine_format(#set)
	local write, read, size = spec.write, spec.read, spec.size

	local keys = {}

	for key, value in set do
		keys[value] = key
	end

	return {
		write = function(b: buffer, offset: number, value: T)
			local index = keys[value]

			if not index then
				error(`Value '{value}' not found in set!`)
			end

			write(b, offset, index)
		end,
		read = function(b: buffer, offset: number): T
			local index = read(b, offset)

			return set[index]
		end,
		size = function(): number
			return size
		end,
		validate = function(value: unknown): boolean
			return value ~= nil and keys[value] ~= nil
		end,
	}
end
