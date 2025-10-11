local types = require "../../types"

local Schema = require "../Schema"

type ContentTypeImplementation = {
	read write: (b: buffer, offset: number, content: Content) -> (),
	read read: (b: buffer, offset: number) -> Content,
	read size: (content: Content) -> number,
}

local SOURCE_TYPE_IMPLEMENTATIONS: { [Enum.ContentSourceType]: ContentTypeImplementation } =
	table.freeze {
		[Enum.ContentSourceType.None] = table.freeze {
			write = function() end,
			read = function(): Content
				return Content.none
			end,
			size = function(): number
				return 0
			end,
		},
		[Enum.ContentSourceType.Uri] = table.freeze {
			write = function(b: buffer, offset: number, content: Content)
				local uri = content.Uri :: string
				local uri_count = string.len(uri)

				buffer.writeu8(b, offset, uri_count)
				buffer.writestring(b, offset + 1, uri)
			end,
			read = function(b: buffer, offset: number): Content
				local uri_count = buffer.readu8(b, offset) + 1 -- assuming they aren't going to be above 256 characters
				local uri = buffer.readstring(b, offset + 1, uri_count)

				return Content.fromUri(uri)
			end,
			size = function(content: Content): number
				local uri = content.Uri :: string
				local uri_count = string.len(uri)

				return 1 + uri_count
			end,
		},
	}

local function getImplementation(source_type: Enum.ContentSourceType?): ContentTypeImplementation
	return SOURCE_TYPE_IMPLEMENTATIONS[source_type or Enum.ContentSourceType.None]
end

return Schema "Content" {
	write = function(b: buffer, offset: number, content: Content)
		local source_type = content.SourceType
		local impl = getImplementation(source_type)

		buffer.writeu8(b, offset, content.SourceType.Value)
		impl.write(b, offset + 1, content)
	end,
	read = function(b: buffer, offset: number): Content
		local source_type = Enum.ContentSourceType:FromValue(buffer.readu8(b, offset))
		local impl = getImplementation(source_type)

		return impl.read(b, offset + 1)
	end,
	size = function(content: Content): number
		local source_type = content.SourceType
		local impl = getImplementation(source_type)

		return 1 + impl.size(content)
	end,

	validate = function(content: unknown): boolean
		return true
	end,
} :: types.Schema<Content>
