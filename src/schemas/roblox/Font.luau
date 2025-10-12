local types = require "../../types"

local Schema = require "../Schema"

return Schema "Font" {
	write = @native function(b: buffer, offset: number, value: Font)
		local family = value.Family
		local family_len = string.len(family)

		buffer.writeu8(b, offset, value.Style.Value)
		buffer.writeu8(b, offset + 1, value.Weight.Value // 100)
		buffer.writeu8(b, offset + 2, family_len)
		buffer.writestring(b, offset + 3, family, family_len)
	end,
	read = @native function(b: buffer, offset: number): Font
		local style = Enum.FontStyle:FromValue(buffer.readu8(b, offset))
		local weight = Enum.FontWeight:FromValue(buffer.readu8(b, offset + 1) * 100)

		local family_len = buffer.readu8(b, offset + 2)
		local family = buffer.readstring(b, offset + 3, family_len)

		return Font.new(family, weight, style)
	end,
	size = @native function(value: Font): number
		local family_len = string.len(value.Family)

		return 3 + family_len
	end,

	validate = @native function(value: unknown): boolean
		return typeof(value) == "Font"
	end,
} :: types.Schema<Font>
