local types = require "../types"

type SchemaImpl<T...> = {
	write: (b: buffer, offset: number, T...) -> (),
	read: (b: buffer, offset: number) -> T...,
	size: (T...) -> number,
	validate: (T...) -> boolean,
}
type Self<T...> = types.Schema<T...>

local class = table.freeze {
	serialize = function<T...>(self: Self<T...>, ...: T...): buffer
		local out_buffer = buffer.create(self._size(...))

		self._write(out_buffer, 0, ...)

		return out_buffer
	end,
	deserialize = function<T...>(self: Self<T...>, serialized: buffer): T...
		return self._read(serialized, 0)
	end,
	validate = function<T...>(self: Self<T...>, ...: T...): boolean
		return self._validate(...)
	end,
}
local METATABLE = table.freeze { __index = class }

local function Schema(name: string)
	return function<T...>(impl: SchemaImpl<T...>): types.Schema<T...>
		return setmetatable({
			name = name,

			_write = impl.write,
			_read = impl.read,
			_size = impl.size,
			_validate = impl.validate,
		}, METATABLE) :: any
	end
end

return Schema
