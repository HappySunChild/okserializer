const specs = require("../../specs")
const types = require("../../types")

const DEFAULT_VALUE_SPEC = specs.u16

const function EnumItem_schema(enumerator: Enum, value_spec: types.NumberTypeSpec?): types.Schema<EnumItem>
	const value = if value_spec == nil then DEFAULT_VALUE_SPEC else value_spec
	const value_write, value_read, value_size = value.write, value.read, value.size

	return {
		write = @native function(b: buffer, offset: number, value: EnumItem): number
			value_write(b, offset, value.Value)
			return value_size
		end,
		read = @native function(b: buffer, offset: number): (number, EnumItem)
			return value_size, enumerator:FromValue(value_read(b, offset))
		end,
		alloc_size = @native function(): number
			return value_size
		end,
		validate = @native function(value: unknown): (boolean, string?)
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
