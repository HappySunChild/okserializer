const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_POS_ENCODING = encodings.f32
const DEFAULT_ROT_ENCODING = encodings.r16

const function CFrame_schema(
	pos_enc: okserde.NumberEncoding?,
	rot_enc: okserde.NumberEncoding?
): okserde.Schema<CFrame>
	const pos = if pos_enc == nil then DEFAULT_POS_ENCODING else pos_enc
	const pos_write, pos_read, pos_size = pos.write, pos.read, pos.size

	const rot = if rot_enc == nil then DEFAULT_ROT_ENCODING else rot_enc
	const rot_write, rot_read, rot_size = rot.write, rot.read, rot.size

	return {
		write = @native function(b: buffer, offset: number, value: CFrame): number
			const x, y, z = value.X, value.Y, value.Z
			const rx, ry, rz = value:ToOrientation()

			pos_write(b, offset, x)
			pos_write(b, offset + pos_size, y)
			pos_write(b, offset + pos_size * 2, z)

			rot_write(b, offset + pos_size * 3, rx)
			rot_write(b, offset + pos_size * 3 + rot_size, ry)
			rot_write(b, offset + pos_size * 3 + rot_size * 2, rz)

			return pos_size * 3 + rot_size * 3
		end,
		read = @native function(b: buffer, offset: number): (number, CFrame)
			const x = pos_read(b, offset)
			const y = pos_read(b, offset + pos_size)
			const z = pos_read(b, offset + pos_size * 2)

			const rx = rot_read(b, offset + pos_size * 3)
			const ry = rot_read(b, offset + pos_size * 3 + rot_size)
			const rz = rot_read(b, offset + pos_size * 3 + rot_size * 2)

			return pos_size * 3 + rot_size * 3, CFrame.new(x, y, z) * CFrame.fromOrientation(rx, ry, rz)
		end,
		size = @native function(): number
			return pos_size * 3 + rot_size * 3
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "CFrame" then
				return false, `expected value of type CFrame, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return CFrame_schema
