local types = require "../../types"

local Schema = require "../Schema"

local TOP_MASK = 0b000001
local BOTTOM_MASK = 0b000010
local LEFT_MASK = 0b000100
local RIGHT_MASK = 0b001000
local FRONT_MASK = 0b010000
local BACK_MASK = 0b100000

return Schema "Faces" {
	write = function(b: buffer, offset: number, value: Faces)
		local top = value.Top and TOP_MASK or 0
		local bottom = value.Bottom and BOTTOM_MASK or 0
		local left = value.Left and LEFT_MASK or 0
		local right = value.Right and RIGHT_MASK or 0
		local front = value.Front and FRONT_MASK or 0
		local back = value.Back and BACK_MASK or 0

		buffer.writeu8(b, offset, bit32.bor(top, bottom, left, right, front, back))
	end,
	read = function(b: buffer, offset: number): Faces
		local combined = buffer.readu8(b, offset)

		local top = bit32.btest(combined, TOP_MASK) and Enum.NormalId.Top or nil
		local bottom = bit32.btest(combined, BOTTOM_MASK) and Enum.NormalId.Bottom or nil
		local left = bit32.btest(combined, LEFT_MASK) and Enum.NormalId.Left or nil
		local right = bit32.btest(combined, RIGHT_MASK) and Enum.NormalId.Right or nil
		local front = bit32.btest(combined, FRONT_MASK) and Enum.NormalId.Front or nil
		local back = bit32.btest(combined, BACK_MASK) and Enum.NormalId.Back or nil

		return Faces.new(
			top :: Enum.NormalId,
			bottom :: Enum.NormalId,
			left :: Enum.NormalId,
			right :: Enum.NormalId,
			front :: Enum.NormalId,
			back :: Enum.NormalId
		)
	end,
	size = function(): number
		return 1
	end,

	validate = function(value: unknown): boolean
		return typeof(value) == "Faces"
	end,
} :: types.Schema<Faces>
