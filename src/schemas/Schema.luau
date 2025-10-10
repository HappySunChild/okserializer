local types = require "../types"

type SchemaImpl<T...> = {
	write: (b: buffer, offset: number, T...) -> (),
	read: (b: buffer, offset: number) -> T...,
	size: (T...) -> number,
	validate: (...unknown) -> boolean,
}
type Self<T...> = types.Schema<T...>

local class = table.freeze {
	serialize = function<T...>(self: Self<T...>, ...: T...): buffer
		local out_buffer = buffer.create(self.size(...))

		self.write(out_buffer, 0, ...)

		return out_buffer
	end,
	deserialize = function<T...>(self: Self<T...>, serialized: buffer): T...
		return self.read(serialized, 0)
	end,
}
local METATABLE = table.freeze { __index = class }

local function Schema(name: string)
	return function<T...>(impl: SchemaImpl<T...>): types.Schema<T...>
		return setmetatable({
			name = name,

			write = impl.write,
			read = impl.read,
			size = impl.size,
			validate = impl.validate,
		}, METATABLE) :: any
	end
end

return Schema
