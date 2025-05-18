local package = script.Parent.Parent.Parent

local Types = require(package.Types)

local Schema = require(package.Schemas.Schema)

local getFormatInfo = require(package.Utility.getFormatInfo)

return function(format: Types.NumberByteFormat)
	local info = getFormatInfo(format, "f32")

	local write = info.write
	local read = info.read
	local size = info.size

	return Schema "number" {
		write = write,
		read = read,
		size = function()
			return size
		end,

	}
end
