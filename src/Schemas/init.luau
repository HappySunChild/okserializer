local package = script.Parent

local Types = require(package.Types)

local determineFormat = require(package.Utility.determineFormat)
local getFormatInfo = require(package.Utility.getFormatInfo)

local Schema = require(script.Schema)

local Schemas = {
	string = require(script.Primitives.string),
	csetstring = require(script.Primitives.csetstring),
	buffer = require(script.Primitives.buffer),
	number = require(script.Primitives.number),

	array = require(script.Primitives.array),
	bitarray = require(script.Primitives.bitarray),

	struct = require(script.Primitives.struct),
	set = require(script.Primitives.set),

	CFrame = require(script.Userdata.CFrame),
	Enum = require(script.Userdata.Enum),
	Vector2 = require(script.Userdata.Vector2),
	Vector3 = require(script.Userdata.Vector3),

	BrickColor = require(script.Userdata.BrickColor),
	Color3 = require(script.Userdata.Color3),
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
