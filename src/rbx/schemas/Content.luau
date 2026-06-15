local specs = require("../../specs")
local types = require("../../types")

local string_schema = require("../../schemas/primitive/string")

local uri_schema = string_schema(specs.u8)
local uri_write, uri_read, uri_size = uri_schema.write, uri_schema.read, uri_schema.size

const Content_schema = {
	write = function(b: buffer, offset: number, value: Content)
		local source_type = value.SourceType

		buffer.writeu8(b, offset, value.SourceType.Value)

		if source_type == Enum.ContentSourceType.Uri then
			uri_write(b, offset + 1, value.Uri or "")
		end
	end,
	read = function(b: buffer, offset: number): Content
		local source_type = Enum.ContentSourceType:FromValue(buffer.readu8(b, offset))

		if source_type == Enum.ContentSourceType.Uri then
			return Content.fromUri(uri_read(b, offset + 1))
		end

		return Content.none
	end,
	size = function(value: Content): number
		local source_type = value.SourceType

		if source_type == Enum.ContentSourceType.Uri then
			return 1 + uri_size(value.Uri or "")
		end

		return 1
	end,
	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Content" then
			return false, `expected value of type Content, got {typeof(value)}`
		end

		return true, nil
	end,
} :: types.Schema<Content>

return Content_schema
