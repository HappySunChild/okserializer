--[[

this schema is a little hard to understand at first glance... so allow me to try to explain it

this schema stores values externally instead of directly inside the buffer.

when writing, this schema appends the provided value to it's external "references" table, then writes the index of the
value in that array into the buffer as an unsigned 8-bit integer.

when reading, this schema reads the index from the buffer as an unsigned 8-bit integer, then returns the value in the
reference table at that index.

this means serialization and deserialization **MUST** use the same references tables!! if they don't then the
deserialized values may (and most likely will) be incorrect!!

because of this it is very much **NOT** suitable for persistent storage, where the references tables will most
certainly not be the same. if you're looking for a schema that can store arbitrary values that can't be serialized in a
buffer, that also needs to work with persistent storage, then you should check out the `enum` schema.

one use case for this schema is when serializing Roblox Instances into buffers, and sending them across the network, since
buffers can't directly hold references to Instances in them.

since the references table must be managed manually it is HEAVILY recommended that you only use this if you understand
its lifetime and synchronization requirements!!

--]]

const okserde = require("../types")

const function transientref_schema<T>(references: { T }): okserde.Schema<T>
	return {
		write = @native function(b: buffer, offset: number, value: T): number
			const index = #references + 1

			assert(
				index <= 255,
				"can't have more than 255 references; make sure you're clearing your reference table periodically"
			)

			references[index] = value

			buffer.writeu8(b, offset, index - 1)

			return 1
		end,
		read = function(b: buffer, offset: number): (number, T)
			const index = buffer.readu8(b, offset) + 1

			return 1, references[index]
		end,
		validate = function(): (boolean, string?)
			return true
		end,
		
		static_size = 1,
	}
end

return transientref_schema
