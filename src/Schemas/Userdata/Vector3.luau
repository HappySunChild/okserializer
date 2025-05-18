local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local getFormatInfo = require(package.Utility.getFormatInfo)

return function(format: Types.NumberByteFormat)
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
end
