-- "Schema" class
local types = require "../types"

type SchemaInfo<T> = {
	write: (b: buffer, offset: number, value: T) -> (),
	read: (b: buffer, offset: number) -> T,
	size: (value: T) -> number,
	validate: (value: T) -> boolean,
}
type Self<T> = types.Schema<T> & {
	_write: (b: buffer, offset: number, value: T) -> (),
	_read: (b: buffer, offset: number) -> T,
	_size: (value: T) -> number,
	_validate: (value: T) -> boolean,
}

local class = table.freeze {
	serialize = function<T>(self: Self<T>, value: T): (string, buffer)
		local out_buf = buffer.create(self._size(value))

		self._write(out_buf, 0, value)

		return buffer.tostring(out_buf), out_buf
	end,
	deserialize = function<T>(self: Self<T>, serialized: string): T
		local buf = buffer.fromstring(serialized)

		return self._read(buf, 0)
	end,
	validate = function<T>(self: Self<T>, value: T): boolean
		return self._validate(value)
	end,
}
local METATABLE = table.freeze { __index = class }

local function Schema(name: string)
	return function<T>(info: SchemaInfo<T>): types.Schema<T>
		local newSchema = setmetatable({
			name = name,

			_write = info.write,
			_read = info.read,
			_size = info.size,
			_validate = info.validate,
		}, METATABLE)

		return newSchema
	end
end

return Schema
