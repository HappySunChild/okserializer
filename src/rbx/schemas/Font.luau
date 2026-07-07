const types = require("../../types")

const Font_schema: types.Schema<Font> = {
	write = @native function(b: buffer, offset: number, value: Font): number
		const family = value.Family
		const family_len = string.len(family)

		buffer.writeu8(b, offset, value.Style.Value)
		buffer.writeu8(b, offset + 1, value.Weight.Value // 100)
		buffer.writeu8(b, offset + 2, family_len)
		buffer.writestring(b, offset + 3, family, family_len)

		return 3 + family_len
	end,
	read = @native function(b: buffer, offset: number): (number, Font)
		const style = Enum.FontStyle:FromValue(buffer.readu8(b, offset))
		const weight = Enum.FontWeight:FromValue(buffer.readu8(b, offset + 1) * 100)

		const family_len = buffer.readu8(b, offset + 2)
		const family = buffer.readstring(b, offset + 3, family_len)

		return 3 + family_len, Font.new(family, weight, style)
	end,
	alloc_size = @native function(value: Font): number
		const family_len = string.len(value.Family) % 256

		return 3 + family_len
	end,

	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Font" then
			return false, `expected value of type Font, got {typeof(value)}`
		end

		return true, nil
	end,
}

return Font_schema
