local types = require "../../types"

local Schema = require "../Schema"

local Schema_flags = require "../custom/flags"

local _schem = Schema_flags(9)
local write, read = _schem.write, _schem.read

return Schema {
	write = @native function(b: buffer, offset: number, value: Axes)
		write(b, offset, {
			value.X,
			value.Y,
			value.Z,

			value.Top,
			value.Bottom,
			value.Left,
			value.Right,
			value.Front,
			value.Back,
		})
	end,
	read = @native function(b: buffer, offset: number): Axes
		local data = read(b, offset)

		local x = data[1] and Enum.Axis.X or nil
		local y = data[2] and Enum.Axis.Y or nil
		local z = data[3] and Enum.Axis.Z or nil

		local top = data[4] and Enum.NormalId.Top or nil
		local bottom = data[5] and Enum.NormalId.Bottom or nil
		local left = data[6] and Enum.NormalId.Left or nil
		local right = data[7] and Enum.NormalId.Right or nil
		local front = data[8] and Enum.NormalId.Front or nil
		local back = data[9] and Enum.NormalId.Back or nil

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
