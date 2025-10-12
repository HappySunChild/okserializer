local types = require "../../types"

local Schemas = require "../Schema"

local X_MASK = 0b100
local Y_MASK = 0b010
local Z_MASK = 0b001

local TOP_MASK = 0b100000_000
local BOTTOM_MASK = 0b010000_000
local LEFT_MASK = 0b001000_000
local RIGHT_MASK = 0b000100_000
local FRONT_MASK = 0b000010_000
local BACK_MASK = 0b000001_000

return Schemas "Axes" {
	write = @native function(b: buffer, offset: number, value: Axes)
		local x = value.X and X_MASK or 0
		local y = value.Y and Y_MASK or 0
		local z = value.Z and Z_MASK or 0

		local top = value.Top and TOP_MASK or 0
		local bottom = value.Bottom and BOTTOM_MASK or 0
		local left = value.Left and LEFT_MASK or 0
		local right = value.Right and RIGHT_MASK or 0
		local front = value.Front and FRONT_MASK or 0
		local back = value.Back and BACK_MASK or 0

		buffer.writeu16(b, offset, bit32.bor(x, y, z, top, bottom, left, right, front, back))
	end,
	read = @native function(b: buffer, offset: number): Axes
		local combined = buffer.readu16(b, offset)

		local x = bit32.btest(combined, X_MASK) and Enum.Axis.X or nil
		local y = bit32.btest(combined, Y_MASK) and Enum.Axis.Y or nil
		local z = bit32.btest(combined, Z_MASK) and Enum.Axis.Z or nil

		local top = bit32.btest(combined, TOP_MASK) and Enum.NormalId.Top or nil
		local bottom = bit32.btest(combined, BOTTOM_MASK) and Enum.NormalId.Bottom or nil
		local left = bit32.btest(combined, LEFT_MASK) and Enum.NormalId.Left or nil
		local right = bit32.btest(combined, RIGHT_MASK) and Enum.NormalId.Right or nil
		local front = bit32.btest(combined, FRONT_MASK) and Enum.NormalId.Front or nil
		local back = bit32.btest(combined, BACK_MASK) and Enum.NormalId.Back or nil

		return Axes.new(
			x :: Enum.Axis,
			y :: Enum.Axis,
			z :: Enum.Axis,
			top :: Enum.NormalId,
			bottom :: Enum.NormalId,
			left :: Enum.NormalId,
			right :: Enum.NormalId,
			front :: Enum.NormalId,
			back :: Enum.NormalId
		)
	end,
	size = @native function(): number
		return 2
	end,

	validate = @native function(value: unknown): boolean
		return typeof(value) == "Axes"
	end,
} :: types.Schema<Axes>
