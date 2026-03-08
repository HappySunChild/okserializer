local types = require("../../types")

local is_array = require("../../utility/is_array")

local function flags(flag_count: number): types.Schema<{ boolean }>
	assert(flag_count <= 32, "Can't have more than 32 flags per flags schema.")

	return {
		write = function(b: buffer, offset: number, flags_value: { boolean })
			local value = 0

			for i = 1, flag_count do
				local flag = flags_value[i]

				if flag == true then
					value += 2 ^ (i - 1)
				end
			end

			buffer.writebits(b, offset * 8, flag_count, value)
		end,
		read = function(b: buffer, offset: number): { boolean }
			local flags = table.create(flag_count, false) :: { boolean }
			local value = buffer.readbits(b, offset * 8, flag_count)

			for i = 1, flag_count do
				flags[i] = bit32.btest(value, 2 ^ (i - 1))
			end

			return flags
		end,
		size = function(): number
			return math.ceil(flag_count / 8)
		end,
		validate = function(value: unknown): boolean
			if not is_array(value) then
				return false
			end

			for _, v in value :: { unknown } do
				if type(v) ~= "boolean" then
					return false
				end
			end

			return true
		end,
	}
end

return flags
