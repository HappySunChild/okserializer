local package = script.Parent
local Types = require(package.Types)

local determineFormat = require(package.Utility.determineFormat)
local getFormatInfo = require(package.Utility.getFormatInfo)

local Schema = require(package.Schemas.Schema)

local Primitive = script.Primitives
local Userdata = script.Userdata

-- again, string requires don't really work because @self doesn't seem to be implemented.
-- i've left the string requires commented out so that when *(and if)* it is added, it can easily be swapped in.

local Schemas = {
	null = require(Primitive.null), -- require "@self/Primitives/null",
	boolean = require(Primitive.boolean), -- require "@self/Primitives/boolean",
	string = require(Primitive.string), -- require "@self/Primitives/string",
	csetstring = require(Primitive.csetstring), -- require "@self/Primitives/csetstring",
	buffer = require(Primitive.buffer), -- require "@self/Primitives/buffer",
	number = require(Primitive.number), -- require "@self/Primitives/number",
	vector = require(Primitive.vector), -- require "@self/Primitives/vector",
	array = require(Primitive.array), -- require "@self/Primitives/array",
	bitarray = require(Primitive.bitarray), -- require "@self/Primitives/bitarray",
	struct = require(Primitive.struct), -- require "@self/Primitives/struct",
	set = require(Primitive.set), -- require "@self/Primitives/set",

	CFrame = require(Userdata.CFrame), -- require "@self/Userdata/CFrame",
	Enum = require(Userdata.Enum), -- require "@self/Userdata/Enum",
	Vector2 = require(Userdata.Vector2), -- require "@self/Userdata/Vector2",
	Vector3 = require(Userdata.Vector3), -- require "@self/Userdata/Vector3",
	BrickColor = require(Userdata.BrickColor), -- require "@self/Userdata/BrickColor",
	Color3 = require(Userdata.Color3), -- require "@self/Userdata/Color3",
}

Schemas.union = function(...: Types.Schema<any>): Types.Schema<any>
	local schemas = { ... }

	local info = getFormatInfo(determineFormat(#schemas), "u8")
	local write = info.write
	local read = info.read
	local byteCount = info.size

	local function getSchema<V>(value: V): (number?, Types.Schema<V>?)
		for index, schema in schemas do
			if schema._validate(value) then
				return index, schema
			end
		end

		return nil
	end

	return Schema "union" {
		write = function(b: buffer, offset: number, value: any)
			local index, schema = getSchema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			write(b, offset, index)

			schema._write(b, offset + byteCount, value)
		end,
		read = function(b: buffer, offset: number)
			local index = read(b, offset)
			local schema = schemas[index]

			return schema._read(b, offset + byteCount)
		end,
		size = function(value: any)
			local _, schema = getSchema(value)

			if not schema then
				error(`No available schema for value {value} ({typeof(value)})`)
			end

			local size = schema._size(value)

			return byteCount + size
		end,

		validate = function(value: unknown)
			return getSchema(value) ~= nil
		end,
	}
end

return Schemas
