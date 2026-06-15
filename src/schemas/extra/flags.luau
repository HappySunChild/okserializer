const types = require("../../types")

const is_array = require("../../utility/is_array")

const function flags_schema(flag_count: number): types.Schema<{ boolean }>
	assert(flag_count <= 32, "Can't have more than 32 flags per flags schema.")

	return {
		write = function(b: buffer, offset: number, flags_value: { boolean })
			local value = 0

			for i = 1, flag_count do
				const flag = flags_value[i]

				if flag == true then
					value += 2 ^ (i - 1)
				end
			end

			buffer.writebits(b, offset * 8, flag_count, value)
		end,
		read = function(b: buffer, offset: number): { boolean }
			const flags = table.create(flag_count, false) :: { boolean }
			const value = buffer.readbits(b, offset * 8, flag_count)

			for i = 1, flag_count do
				flags[i] = bit32.btest(value, 2 ^ (i - 1))
			end

			return flags
		end,
		size = function(): number
			return math.ceil(flag_count / 8)
		end,
		validate = function(value: unknown): (boolean, string?)
			if not is_array(value) then
				return false, "expected array value"
			end

			for _, element in value :: { unknown } do
				if type(element) ~= "boolean" then
					return false, "expected array to only contain booleans"
				end
			end

			return true, nil
		end,
	}
end

return flags_schema
