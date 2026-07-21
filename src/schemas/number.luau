const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_NUMBER_ENCODING = encodings.f32

const function number_schema(num_enc: okserde.NumberEncoding?): okserde.Schema<number>
	const num = if num_enc == nil then DEFAULT_NUMBER_ENCODING else num_enc
	const num_write, num_read, num_size, num_min, num_max = num.write, num.read, num.size, num.min, num.max

	return {
		write = @native function(b: buffer, offset: number, value: number): number
			num_write(b, offset, value)
			return num_size
		end,
		read = @native function(b: buffer, offset: number): (number, number)
			return num_size, num_read(b, offset)
		end,
		size = function(): number
			return num_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "number" then
				return false, `expected value of type number, got {type(value)}`
			end

			if value < num_min or value > num_max then
				return false, `number ({value}) is outside specified num spec range ({num_min} - {num_max})`
			end

			return true, nil
		end,
	} :: okserde.Schema<number>
end

return number_schema
