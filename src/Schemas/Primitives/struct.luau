local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

return function(schemaDict: { [string]: Types.Schema<unknown> }, order: { string }?)
	local keys = {}

	for key in schemaDict do
		table.insert(keys, key)
	end

	if type(order) == "table" then
		table.sort(keys, function(a: string, b: string)
			local aIndex = table.find(order, a) or 0
			local bIndex = table.find(order, b) or 0

			if aIndex == bIndex then
				return a > b
			end

			return aIndex < bIndex
		end)
	else
		-- ensure consistant order, this will break when adding/remove
		-- keys though, so maybe try to avoid doing that?
		table.sort(keys)
	end

	return Schema "struct" {
		write = function(b: buffer, offset: number, dict: { [string]: unknown })
			for _, key in keys do
				local schema = schemaDict[key]
				local value = dict[key]

				schema._write(b, offset, value)

				offset += schema._size(value)
			end
		end,
		read = function(b: buffer, offset: number)
			local result = {}

			for _, key in keys do
				local schema = schemaDict[key]
				local value = schema._read(b, offset)

				result[key] = value

				offset += schema._size(value)
			end

			return result
		end,
		size = function(dict: V)
			local byteCount = 0

			for _, key in keys do
				local schema = schemaDict[key]
				local value = dict[key]

				byteCount += schema._size(value)
			end

			return byteCount
		end,

	}
end
