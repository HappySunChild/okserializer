# okserializer
A low-abstraction, schema-based Luau buffer serializer. Comes with some premade `Schema` for Roblox userdata types as well.

Based off of athar_adventure's [BufferConverter2](https://devforum.roblox.com/t/temporarily-archived-bufferconverter2-blazingly-fast-schema-based-buffer-serialization/3429040).

## Usage Example
```luau
local okserializer = require "path/to/okserializer"
local Schemas = okserializer.Schemas

local person_schema = Schemas.struct {
	name = Schemas.string "u8",
	last_name = Schemas.string "u8",
}

local example_person = {
	name = "John",
	last_name = "Doe",
}

local serialized = person_schema:serialize(example_person)

print(buffer.len(serialized))

local deserialized = person_schema:deserialize(serialized)

assert(example_person.name == deserialized.name)
assert(example_person.last_name == deserialized.last_name)
```