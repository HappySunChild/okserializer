const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_NUMBER_SPEC = specs.f32

const function number_schema(num_spec: types.NumberTypeSpec?): types.Schema<number>
	const num = if num_spec == nil then DEFAULT_NUMBER_SPEC else num_spec
	const num_write, num_read, num_size, num_min, num_max = num.write, num.read, num.size, num.min, num.max

	return {
		write = num_write,
		read = num_read,
		size = function(): number
			return num_size
		end,
		validate = function(value: unknown): (boolean, string?)
			if type(value) ~= "number" then
				return false, `expected value of type number, got {type(value)}`
			end

			if value < num_min or value > num_max then
				return false, `number ({value}) is outside specified num spec range ({num_min} - {num_max})`
			end

			return true, nil
		end,
	} :: types.Schema<number>
end

return number_schema
