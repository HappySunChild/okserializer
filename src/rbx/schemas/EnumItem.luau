local specs = require("../../specs")
local types = require("../../types")

local DEFAULT_VALUE_SPEC = specs.u16

const function EnumItem_schema(enumerator: Enum, value_spec: types.NumberTypeSpec?): types.Schema<EnumItem>
	local value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	local value_write, value_read, value_size = value.write, value.read, value.size

	return {
		write = function(b: buffer, offset: number, value: EnumItem)
			value_write(b, offset, value.Value)
		end,
		read = function(b: buffer, offset: number): EnumItem
			return enumerator:FromValue(value_read(b, offset))
		end,
		size = function(): number
			return value_size
		end,
		validate = function(value: unknown): (boolean, string?)
			if typeof(value) ~= "EnumItem" then
				return false, `expected value of type EnumItem, got {typeof(value)}`
			end

			if value.EnumType ~= enumerator then
				return false,
					`expected EnumItem of {enumerator}, got EnumItem of {value.EnumType} ({value.Name})`
			end

			return true, nil
		end,
	}
end

return EnumItem_schema
