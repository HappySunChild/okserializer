-- "Schema" class

local package = script.Parent.Parent

local Types = require(package.Types)

type Self<V> = Types.Schema<V>

local class = {}
local METATABLE = table.freeze { __index = class }

local function Schema(name: string)
	return function<V>(methods: {
		write: (b: buffer, offset: number, value: V) -> (),
		read: (b: buffer, offset: number) -> V,
		size: (value: V) -> number,
	}): Types.Schema<V>
		local newSchema = setmetatable({
			Name = name,
			_write = methods.write,
			_read = methods.read,
			_size = methods.size,
		}, METATABLE)

		return newSchema
	end
end

function class.Serialize<V>(self: Self<V>, value: V)
	local size = self._size(value)
	local outBuf = buffer.create(size)

	self._write(outBuf, 0, value)

	return buffer.tostring(outBuf), outBuf
end

function class.Deserialize<V>(self: Self<V>, serialized: string)
	local buf = buffer.fromstring(serialized)

	return self._read(buf, 0)
end

table.freeze(class)

return Schema
