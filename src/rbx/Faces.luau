const okserde = require("../types")

const flags_schema = require("../schemas/flags")

const data = flags_schema(6)
const data_write, data_read, data_size = data.write, data.read, data.static_size

const Faces_schema: okserde.StaticSchema<Faces> = {
	write = @native function(b: buffer, offset: number, value: Faces): number
		return data_write(b, offset, {
			value.Top,
			value.Bottom,
			value.Left,
			value.Right,
			value.Front,
			value.Back,
		})
	end,
	read = @native function(b: buffer, offset: number): (number, Faces)
		const bytes_read, data = data_read(b, offset)

		const top = data[1] and Enum.NormalId.Top or nil
		const bottom = data[2] and Enum.NormalId.Bottom or nil
		const left = data[3] and Enum.NormalId.Left or nil
		const right = data[4] and Enum.NormalId.Right or nil
		const front = data[5] and Enum.NormalId.Front or nil
		const back = data[6] and Enum.NormalId.Back or nil

		return bytes_read,
			Faces.new(
				top :: Enum.NormalId,
				bottom :: Enum.NormalId,
				left :: Enum.NormalId,
				right :: Enum.NormalId,
				front :: Enum.NormalId,
				back :: Enum.NormalId
			)
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Faces" then
			return false, `expected value of type Faces, got {typeof(value)}`
		end

		return true, nil
	end,

	static_size = data_size,
}

return Faces_schema
