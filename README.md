# okserde
A low-abstraction, schema-based Luau buffer serializer. Comes with some premade `Schema` for Roblox userdata types as well.

Based off of athar_adventure's [BufferConverter2](https://devforum.roblox.com/t/temporarily-archived-bufferconverter2-blazingly-fast-schema-based-buffer-serialization/3429040).

## Usage Example
```luau
local okserde = require("path/to/okserde")
local schemas, specs = okserde.schemas, okserde.specs
local serialize, deserialize = okserde.serialize, okserde.deserialize

local person_schema = schemas.struct({
	name = schemas.string(specs.u8),
	last_name = schemas.string(specs.u8),
})

local example_person = {
	name = "John",
	last_name = "Doe",
}

local serialized = serialize(person_schema, example_person)

print(buffer.len(serialized))

local deserialized = deserialize(person_schema, serialized)

assert(example_person.name == deserialized.name)
assert(example_person.last_name == deserialized.last_name)

```
