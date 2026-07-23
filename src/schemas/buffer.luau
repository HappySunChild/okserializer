const encodings = require("../encodings")
const okserde = require("../types")

const DEFAULT_LEN_ENCODING = encodings.u16

const function buffer_schema(len_enc: okserde.NumberEncoding?): okserde.Schema<buffer>
	const len = if len_enc == nil then DEFAULT_LEN_ENCODING else len_enc
	const len_write, len_read, len_size = len.write, len.read, len.size

	return {
		write = @native function(b: buffer, offset: number, value: buffer): number
			const count = buffer.len(value)

			len_write(b, offset, count)
			buffer.copy(b, offset + len_size, value)

			return len_size + count
		end,
		read = @native function(b: buffer, offset: number): (number, buffer)
			const count = len_read(b, offset)
			const new_buffer = buffer.create(count)

			buffer.copy(new_buffer, 0, b, offset + len_size, count)

			return len_size + count, new_buffer
		end,
		size = @native function(value: buffer): number
			return len_size + buffer.len(value) % (len.max + 1)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if type(value) ~= "buffer" then
				return false, `expected value of type buffer, got {type(value)}`
			end

			return true, nil
		end,
	}
end

return buffer_schema
