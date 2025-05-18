-- "Schema" class
local package = script.Parent.Parent

local Types = require(package.Types)

type Self<V> = Types.Schema<V>
type SchemaInfo<V> = {
	write: (b: buffer, offset: number, value: V) -> (),
	read: (b: buffer, offset: number) -> V,
	size: (value: V) -> number,
	validate: (value: V) -> boolean,
}

local class = {}
local METATABLE = table.freeze { __index = class }

local function Schema(name: string)
	return function<V>(info: SchemaInfo<V>): Types.Schema<V>
		local newSchema = setmetatable({
			Name = name,
			_write = info.write,
			_read = info.read,
			_size = info.size,
			_validate = info.validate,
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
