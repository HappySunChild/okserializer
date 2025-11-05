local types = require "../../types"

local Schema = require "../Schema"

local Schema_string = require "../primitive/string"

local _uri = Schema_string "u8"
local uri_write, uri_read, uri_size = _uri.write, _uri.read, _uri.size

return Schema {
	write = function(b: buffer, offset: number, content: Content)
		local source_type = content.SourceType

		buffer.writeu8(b, offset, content.SourceType.Value)

		if source_type == Enum.ContentSourceType.Uri then
			uri_write(b, offset + 1, content.Uri or "")
		end
	end,
	read = function(b: buffer, offset: number): Content
		local source_type = Enum.ContentSourceType:FromValue(buffer.readu8(b, offset))

		if source_type == Enum.ContentSourceType.Uri then
			return Content.fromUri(uri_read(b, offset + 1))
		end

		return Content.none
	end,
	size = function(content: Content): number
		local source_type = content.SourceType

		if source_type == Enum.ContentSourceType.Uri then
			return 1 + uri_size(content.Uri)
		end

		return 1
	end,

	validate = function(content: unknown): boolean
		return true
	end,
} :: types.Schema<Content>
