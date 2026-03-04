local types = require("../../types")

local flags_schema = require("../custom/flags")

local data = flags_schema(6)
local write, read = data.write, data.read

return {
	write = function(b: buffer, offset: number, value: Faces)
		write(b, offset, {
			value.Top,
			value.Bottom,
			value.Left,
			value.Right,
			value.Front,
			value.Back,
		})
	end,
	read = function(b: buffer, offset: number): Faces
		local data = read(b, offset)

		local top = data[1] and Enum.NormalId.Top or nil
		local bottom = data[2] and Enum.NormalId.Bottom or nil
		local left = data[3] and Enum.NormalId.Left or nil
		local right = data[4] and Enum.NormalId.Right or nil
		local front = data[5] and Enum.NormalId.Front or nil
		local back = data[6] and Enum.NormalId.Back or nil

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
