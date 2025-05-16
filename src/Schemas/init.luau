local package = script.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local BrickColorLookup = require(package.Utility.BrickColorLookup)
local determineFormat = require(package.Utility.determineFormat)
local getFormatInfo = require(package.Utility.getFormatInfo)

type Schema<T> = Types.Schema<T>

local Schemas = {
	-- primitives
	number = function(format: Types.NumberByteFormat?): Schema<number>
		local info = getFormatInfo(format, "f32")

		local write = info.write
		local read = info.read
		local sizeBytes = info.size

		return Schema "number" {
			write = write,
			read = read,
			size = function()
				return sizeBytes
			end,
		}
	end,
	string = function(lengthFormat: Types.UIntByteFormat?): Schema<string>
		local len = getFormatInfo(lengthFormat, "u16")

		return Schema "string" {
			write = function(b: buffer, offset: number, value: string)
				local count = string.len(value)

				len.write(b, offset, count)
				buffer.writestring(b, offset + len.size, value, count)
			end,
			read = function(b: buffer, offset: number)
				local count = len.read(b, offset)

				return buffer.readstring(b, offset + len.size, count)
			end,
			size = function(value: string)
				return len.size + #value
			end,
		}
	end,
	buffer = function(lengthFormat: Types.UIntByteFormat?)
		local len = getFormatInfo(lengthFormat, "u8")

		return Schema "buffer" {
			write = function(b: buffer, offset: number, valueBuf: buffer)
				local count = buffer.len(valueBuf)

				len.write(b, offset, count)

				buffer.writestring(b, offset + len.size, buffer.tostring(valueBuf))
			end,
			read = function(b: buffer, offset: number)
				local count = len.read(b, offset)

				return buffer.fromstring(buffer.readstring(b, offset + len.size, count))
			end,
			size = function(valueBuf: buffer)
				return buffer.len(valueBuf) + len.size
			end,
		} :: Schema<buffer>
	end,

	set = function<V>(set: { V }): Schema<V>
		-- note to future self, because i got really confused just now,
		-- this automatically determines the format
		-- sets don't store multiple values, they only store one value that is inside the set
		local info = getFormatInfo(determineFormat(#set))
		local write = info.write
		local read = info.read
		local byteCount = info.size

		local keys = {}

		for key, value in set do
			keys[value] = key
		end

		return Schema "set" {
			write = function(b: buffer, offset: number, value: V)
				local index = keys[value]

				if not index then
					error(`Value '{value}' not found in set!`)
				end

				write(b, offset, index)
			end,
			read = function(b: buffer, offset: number)
				local index = read(b, offset)

				return set[index]
			end,
			size = function()
				return byteCount
			end,
		}
	end,
	array = function<V>(schema: Schema<V>, lengthFormat: Types.UIntByteFormat?): Schema<{ V }>
		local len = getFormatInfo(lengthFormat, "u16")

		return Schema "array" {
			write = function(b: buffer, offset: number, array: { V })
				len.write(b, offset, #array)

				offset += len.size

				for _, value in array do
					schema._write(b, offset, value)
					offset += schema._size(value)
				end
			end,
			read = function(b: buffer, offset: number)
				local length = len.read(b, offset)
				offset += len.size

				local array = {}

				for i = 1, length do
					array[i] = schema._read(b, offset)
					offset += schema._size(array[i])
				end

				return array
			end,
			size = function(array: { V })
				local byteCount = len.size

				for _, value in array do
					byteCount += schema._size(value)
				end

				return byteCount
			end,
		}
	end,
	dict = function<V>(schemaDict: V): Schema<V>
		local keys = {}

		for key in schemaDict do
			table.insert(keys, key)
		end

		-- ensure consistant order, this will break when adding/remove
		-- keys though, so maybe try to avoid doing that?
		table.sort(keys)

		return Schema "struct" {
			write = function(b: buffer, offset: number, dict: V)
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
	end,

	-- custom
	bitarray = function(bitCount: number): Schema<{ boolean }>
		local byteCount = math.ceil(bitCount / 8)

		return Schema "bitarray" {
			write = function(b: buffer, offset: number, array: { boolean })
				for byteOffset = 0, byteCount - 1 do
					local bundled = 0

					for bitOffset = 0, 7 do
						local index = byteOffset * 8 + bitOffset + 1

						if index > bitCount then
							break
						end

						if not array[index] then
							continue
						end

						bundled += 2 ^ bitOffset
					end

					buffer.writeu8(b, offset + byteOffset, bundled)
				end
			end,
			read = function(b: buffer, offset: number)
				local array = {}

				for byteOffset = 0, byteCount - 1 do
					local bundled = buffer.readu8(b, offset + byteOffset)

					for bitOffset = 0, 7 do
						local index = byteOffset * 8 + bitOffset + 1

						if index > bitCount then
							break
						end

						array[index] = bit32.btest(bundled, 2 ^ bitOffset)
					end
				end

				return array
			end,
			size = function()
				return byteCount
			end,
		}
	end,

	-- userdata
	Vector2 = function(format: Types.NumberByteFormat?): Schema<Vector2>
		local info = getFormatInfo(format, "f32")
		local write = info.write
		local read = info.read
		local byteCount = info.size

		return Schema "Vector2" {
			write = function(b: buffer, offset: number, value: Vector2)
				write(b, offset, value.X)
				write(b, offset + byteCount, value.Y)
			end,
			read = function(b: buffer, offset: number)
				local x = read(b, offset)
				local y = read(b, offset + byteCount)

				return Vector2.new(x, y)
			end,
			size = function()
				return byteCount * 2
			end,
		}
	end,
	Vector3 = function(format: Types.NumberByteFormat?): Schema<Vector3>
		local info = getFormatInfo(format, "f32")
		local write = info.write
		local read = info.read
		local byteCount = info.size

		return Schema "Vector3" {
			write = function(b: buffer, offset: number, value: Vector3)
				write(b, offset, value.X)
				write(b, offset + byteCount, value.Y)
				write(b, offset + byteCount * 2, value.Z)
			end,
			read = function(b: buffer, offset: number)
				local x = read(b, offset)
				local y = read(b, offset + byteCount)
				local z = read(b, offset + byteCount * 2)

				return Vector3.new(x, y, z)
			end,
			size = function()
				return byteCount * 3
			end,
		}
	end,
	CFrame = function(format: Types.NumberByteFormat?, rotationFormat: Types.NumberByteFormat?): Schema<CFrame>
		local pos = getFormatInfo(format, "f32")
		local rot = getFormatInfo(rotationFormat, "r16")

		return Schema "CFrame" {
			write = function(b: buffer, offset: number, value: CFrame)
				local x, y, z = value.X, value.Y, value.Z
				local rx, ry, rz = value:ToOrientation()

				-- TODO: find a way to reduce this maybe???
				-- might have to learn quaternions nooooooo....
				-- i'm too used to euler,,. its 3 am WHY AM I STILL AWAKE
				pos.write(b, offset, x)
				pos.write(b, offset + pos.size, y)
				pos.write(b, offset + pos.size * 2, z)

				rot.write(b, offset + pos.size * 3, rx)
				rot.write(b, offset + pos.size * 3 + rot.size, ry)
				rot.write(b, offset + pos.size * 3 + rot.size * 2, rz)
			end,
			read = function(b: buffer, offset: number)
				local x = pos.read(b, offset)
				local y = pos.read(b, offset + pos.size)
				local z = pos.read(b, offset + pos.size * 2)

				local rx = rot.read(b, offset + pos.size * 3)
				local ry = rot.read(b, offset + pos.size * 3 + rot.size)
				local rz = rot.read(b, offset + pos.size * 3 + rot.size * 2)

				return CFrame.new(x, y, z) * CFrame.fromOrientation(rx, ry, rz)
			end,
			size = function()
				return pos.size * 3 + rot.size * 3
			end,
		}
	end,

	Enum = function(enum: Enum, format: Types.UIntByteFormat?): Schema<EnumItem>
		local info = getFormatInfo(format, "u16")
		local write = info.write
		local read = info.read
		local sizeBytes = info.size

		return Schema "Enum" {
			write = function(b: buffer, offset: number, value: EnumItem)
				write(b, offset, value.Value)
			end,
			read = function(b: buffer, offset: number)
				return enum:FromValue(read(b, offset))
			end,
			size = function()
				return sizeBytes
			end,
		}
	end,

	BrickColor = Schema "BrickColor" {
		write = function(b: buffer, offset: number, value: BrickColor)
			local index = BrickColorLookup.index(value)

			buffer.writeu8(b, offset, index)
		end,
		read = function(b: buffer, offset: number)
			local index = buffer.readu8(b, offset)

			return BrickColorLookup.color(index)
		end,
		size = function()
			return 1
		end,
	} :: Schema<BrickColor>,
	Color3 = Schema "Color3" {
		write = function(b: buffer, offset: number, value: Color3)
			buffer.writeu8(b, offset, value.R * 255)
			buffer.writeu8(b, offset + 1, value.G * 255)
			buffer.writeu8(b, offset + 2, value.B * 255)
		end,
		read = function(b: buffer, offset: number)
			local red = buffer.readu8(b, offset)
			local green = buffer.readu8(b, offset + 1)
			local blue = buffer.readu8(b, offset + 2)

			return Color3.fromRGB(red, green, blue)
		end,
		size = function()
			return 3
		end,
	} :: Schema<Color3>,
}

Schemas.struct = Schemas.dict
Schemas.table = Schemas.dict

do -- Faces
	local schema = Schemas.bitarray(6)

	Schemas.Faces = Schema "Faces" {
		write = function(b: buffer, offset: number, value: Faces)
			local bitArray = { value.Top, value.Bottom, value.Left, value.Right, value.Front, value.Back }
			schema._write(b, offset, bitArray)
		end,
		read = function(b: buffer, offset: number)
			local bitArray = schema._read(b, offset)

			return Faces.new(
				bitArray[1] and Enum.NormalId.Top,
				bitArray[2] and Enum.NormalId.Bottom,
				bitArray[3] and Enum.NormalId.Left,
				bitArray[4] and Enum.NormalId.Right,
				bitArray[5] and Enum.NormalId.Front,
				bitArray[6] and Enum.NormalId.Back
			)
		end,
		size = function()
			return 1
		end,
	} :: Schema<Faces>
end

-- was thinking of adding a `any` or `union` schema type, but I really don't feel like
-- making that, and also I think using non-static types in serialization is a bad idea
-- as it leads to you writing more boilerplate to deal with different types, not to mention
-- it also wastes an extra byte just to store type information.
-- also adding or removing more schema types would break any previously serialized `any` or `union` schemas.

-- the `set` schema type is probably the closest i'm gonna get to doing this

return Schemas
