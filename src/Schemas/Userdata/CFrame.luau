local types = require "../../types"

local Schema = require "../Schema"

local getFormatInfo = require "../../Utility/getFormatInfo"

return function(pos_format: types.NumberByteFormat, rot_format: types.NumberByteFormat): types.Schema<CFrame>
	local pos = getFormatInfo(pos_format, "f32")
	local rot = getFormatInfo(rot_format, "r16")

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
		read = function(b: buffer, offset: number): CFrame
			local x = pos.read(b, offset)
			local y = pos.read(b, offset + pos.size)
			local z = pos.read(b, offset + pos.size * 2)

			local rx = rot.read(b, offset + pos.size * 3)
			local ry = rot.read(b, offset + pos.size * 3 + rot.size)
			local rz = rot.read(b, offset + pos.size * 3 + rot.size * 2)

			return CFrame.new(x, y, z) * CFrame.fromOrientation(rx, ry, rz)
		end,
		size = function(): number
			return pos.size * 3 + rot.size * 3
		end,

		validate = function(value: unknown): boolean
			return typeof(value) == "CFrame"
		end,
	}
end
