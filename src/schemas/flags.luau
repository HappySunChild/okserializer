const okserde = require("../types")

const is_array = require("../utility/is_array")

const function flags_schema(flag_count: number): okserde.StaticSchema<{ boolean }>
	assert(flag_count <= 32 and flag_count > 0, "flag count must be between 1-32, inclusive")

	const static_size = math.ceil(flag_count / 8)

	return {
		write = @native function(b: buffer, offset: number, flags_value: { boolean }): number
			local value = 0

			for i = 1, flag_count do
				const flag = flags_value[i]

				if flag == true then
					value += 2 ^ (i - 1)
				end
			end

			buffer.writebits(b, offset * 8, flag_count, value)

			return static_size
		end,
		read = @native function(b: buffer, offset: number): (number, { boolean })
			const flags = table.create(flag_count, false) :: { boolean }
			const value = buffer.readbits(b, offset * 8, flag_count)

			for i = 1, flag_count do
				flags[i] = bit32.btest(value, 2 ^ (i - 1))
			end

			return static_size, flags
		end,
		validate = @native function(value: unknown): (boolean, string?)
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

		static_size = static_size,
	}
end

return flags_schema
