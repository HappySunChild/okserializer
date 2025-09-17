local types = require "./types"

local determineFormat = require "./Utility/determineFormat"
local getFormatInfo = require "./Utility/getFormatInfo"

local Schema = require "@self/Schema"

local Schemas = {
	null = require "@self/Primitives/null",
	boolean = require "@self/Primitives/boolean",
	string = require "@self/Primitives/string",
	csetstring = require "@self/Primitives/csetstring",
	buffer = require "@self/Primitives/buffer",
	number = require "@self/Primitives/number",
	vector = require "@self/Primitives/vector",
	array = require "@self/Primitives/array",
	bitarray = require "@self/Primitives/bitarray",
	struct = require "@self/Primitives/struct",
	set = require "@self/Primitives/set",

	CFrame = require "@self/Userdata/CFrame",
	Enum = require "@self/Userdata/Enum",
	Vector2 = require "@self/Userdata/Vector2",
	Vector3 = require "@self/Userdata/Vector3",
	BrickColor = require "@self/Userdata/BrickColor",
	Color3 = require "@self/Userdata/Color3",
}

Schemas.union = function(...: types.Schema<any>): types.Schema<any>
	local schemas = { ... }

	local info = getFormatInfo(determineFormat(#schemas), "u8")
	local write = info.write
	local read = info.read
	local byteCount = info.size

	local function get_schema<V>(value: V): (number?, types.Schema<V>?)
		for index, schema in schemas do
			if schema._validate(value) then
				return index, schema
			end
		end

		return nil
	end

	return Schema "union" {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = get_schema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			write(b, offset, index)

			schema._write(b, offset + byteCount, value)
		end,
		read = function(b: buffer, offset: number): any
			local index = read(b, offset)
			local schema = schemas[index]

			return schema._read(b, offset + byteCount)
		end,
		size = function(value: any): number
			local _, schema = get_schema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema._size(value)

			return byteCount + size
		end,

		validate = function(value: unknown): boolean
			return get_schema(value) ~= nil
		end,
	}
end

return Schemas
