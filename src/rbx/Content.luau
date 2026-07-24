const encodings = require("../encodings")
const okserde = require("../types")

const string_schema = require("../schemas/string")

const uri_schema = string_schema(encodings.u8)
const uri_write, uri_read, uri_size = uri_schema.write, uri_schema.read, uri_schema.size

const Content_schema: okserde.DynSchema<Content> = {
	write = @native function(b: buffer, offset: number, value: Content): number
		const source_type = value.SourceType

		buffer.writeu8(b, offset, value.SourceType.Value)

		if source_type == Enum.ContentSourceType.Uri then
			return 1 + uri_write(b, offset + 1, value.Uri or "")
		end

		return 1
	end,
	read = @native function(b: buffer, offset: number): (number, Content)
		const source_type = Enum.ContentSourceType:FromValue(buffer.readu8(b, offset))

		if source_type == Enum.ContentSourceType.Uri then
			const bytes_read, uri = uri_read(b, offset + 1)
			return 1 + bytes_read, Content.fromUri(uri)
		end

		return 1, Content.none
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "Content" then
			return false, `expected value of type Content, got {typeof(value)}`
		end

		return true, nil
	end,

	dyn_size = @native function(value: Content): number
		const source_type = value.SourceType

		if source_type == Enum.ContentSourceType.Uri then
			return 1 + uri_size(value.Uri or "")
		end

		return 1
	end,
}

return Content_schema
