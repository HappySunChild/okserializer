local types = require "../../types"

local Schema = require "../Schema"

local Lookup = require "@self/Lookup"

-- I so badly want to be able to store every single EnumItem in just 2 bytes, but that'd require removing support for certain
-- Enums, which already sounds like a bad idea. You never know what users may be using Enums for, even if it is for the wrong
-- reasons... This also isn't very future proofed, although I don't think Roblox is going to be adding more than 65536 Enums
-- to the client anytime soon, so I think we're fine for now. Maybe in the year 5032 if someone is miraculously using this and
-- runs into issues, atleast they'll know I briefly considered them.
return Schema "Enum" {
	write = function(b: buffer, offset: number, value: EnumItem)
		-- if we wanted to be *technically* correct we'd use u32, since there is one singular EnumItem that has a value that's 2^19
		-- but I don't think wasting 2 bytes for an EnumItem that is never going to be used outside of Roblox's internals is a very
		-- good idea. (https://devforum.roblox.com/t/reservedhighlightid-enumitem-values-are-ridiculously-high/3596085)
		buffer.writeu16(b, offset, Lookup.indexOf(value.EnumType))
		buffer.writeu16(b, offset + 2, value.Value)
	end,
	read = function(b: buffer, offset: number): EnumItem
		local enumerator = Lookup.enumFor(buffer.readu16(b, offset))
		local item = enumerator:FromValue(buffer.readu16(b, offset + 2))

		return item
	end,
	size = function(): number
		return 4
	end,

	validate = function(value: unknown)
		return typeof(value) == "EnumItem"
	end,
} :: types.Schema<EnumItem>
