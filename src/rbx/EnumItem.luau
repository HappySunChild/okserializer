const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_VALUE_ENCODING = encodings.u16

const function EnumItem_schema(
	enumerator: Enum,
	value_enc: okserde.NumberEncoding?
): okserde.StaticSchema<EnumItem>
	const value = if value_enc == nil then DEFAULT_VALUE_ENCODING else value_enc
	const value_write, value_read, value_size = value.write, value.read, value.size

	return {
		write = @native function(b: buffer, offset: number, value: EnumItem): number
			value_write(b, offset, value.Value)
			return value_size
		end,
		read = @native function(b: buffer, offset: number): (number, EnumItem)
			return value_size, enumerator:FromValue(value_read(b, offset))
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

		static_size = value_size,
	}
end

return EnumItem_schema
