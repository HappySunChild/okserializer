local types = require "../types"

type SchemaImpl<T...> = {
	write: (b: buffer, offset: number, T...) -> (),
	read: (b: buffer, offset: number) -> T...,
	size: (T...) -> number,
	validate: (...unknown) -> boolean,
}
type Self<T...> = types.Schema<T...>

local CLASS = table.freeze {
	serialize = function<T...>(self: Self<T...>, ...: T...): buffer
		local out_buffer = buffer.create(self.size(...))

		self.write(out_buffer, 0, ...)

		return out_buffer
	end,
	deserialize = function<T...>(self: Self<T...>, serialized: buffer): T...
		return self.read(serialized, 0)
	end,
}
local METATABLE = table.freeze { __index = CLASS }

local function Schema(name: string)
	return function<T...>(impl: SchemaImpl<T...>): types.Schema<T...>
		local new_schema: types.Schema<T...> = setmetatable({
			name = name,

			write = impl.write,
			read = impl.read,
			size = impl.size,
			validate = impl.validate,
		}, METATABLE) :: any

		return table.freeze(new_schema)
	end
end

return Schema
