const types = require("../types")

const flags_schema = require("../schemas/extra/flags")

const data = flags_schema(9)
const data_write, data_read = data.write, data.read

const Axes_schema: types.Schema<Axes> = {
	write = @native function(b: buffer, offset: number, value: Axes): number
		return data_write(b, offset, {
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
	read = @native function(b: buffer, offset: number): (number, Axes)
		const bytes_read, data = data_read(b, offset)

		const x = data[1] and Enum.Axis.X or nil
		const y = data[2] and Enum.Axis.Y or nil
		const z = data[3] and Enum.Axis.Z or nil

		const top = data[4] and Enum.NormalId.Top or nil
		const bottom = data[5] and Enum.NormalId.Bottom or nil
		const left = data[6] and Enum.NormalId.Left or nil
		const right = data[7] and Enum.NormalId.Right or nil
		const front = data[8] and Enum.NormalId.Front or nil
		const back = data[9] and Enum.NormalId.Back or nil

		return bytes_read,
			Axes.new(
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
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Axes" then
			return false, `expected value of type Axes, got {typeof(value)}`
		end

		return true, nil
	end,
}

return Axes_schema
