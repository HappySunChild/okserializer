# okserde
A low-abstraction, schema-based Luau buffer serializer/deserializer.
This library provides a lot of schemas for serializing common datatypes in Luau.
It also provides some runtime-specific schemas for Roblox datatypes that can be found under the `okserde/rbx` module.

## Usage Example

Here's a simple example that creates a `Person` schema, then using that schema, serializes and deserializes a person,
and finally asserts that the pre-serialization and post-deserialization values are similar.

```luau
const okserde = require("okserde")
const schemas, encodings = okserde.schemas, okserde.encodings
const serialize, deserialize = okserde.serialize, okserde.deserialize

type Person = {
	first_name: string,
	last_name: string,
	age: number,
}

-- defining a composite schema
const person_schema = schemas.struct<<Person>>({
	first_name = schemas.string(),
	last_name = schemas.string(encodings.u8), -- you can specify how the length header for strings are encoded, defaults to u16
	age = schemas.number(encodings.u8), -- same for numbers, defaults to f32
})

const candidate: Person = { first_name = "John", last_name = "Doe", age = 20 }

-- serialization
const serialized_person = serialize(person_schema, candidate)
print(buffer.len(serialized_person), buffer.tostring(serialized_person))

-- deserialization
const deserialized_person = deserialize(person_schema, serialized_person)
assert(deserialized_person.first_name == candidate.first_name)
assert(deserialized_person.last_name == candidate.last_name)
assert(deserialized_person.age == candidate.age)

```

### Custom Schemas

Here's a quick example showing how to create a **uniform** schema (not composed of other preexisting schemas, like `struct`):

```luau
-- /integer.luau
const okserde = require("okserde")

const INTEGER_BYTE_SIZE = 8

return {
	write = function(b: buffer, offset: number, value: integer): number
		buffer.writeinteger(b, offset, value)

		return INTEGER_BYTE_SIZE
	end,
	read = function(b: buffer, offset: number): (number, integer)
		return INTEGER_BYTE_SIZE, buffer.readinteger(b, offset)
	end,
	validate = function(value: unknown): (boolean, string?)
		if type(value) ~= "integer" then
			return false, `expected value of type integer, got {type(value)}`
		end

		return true, nil
	end,
	
	static_size = INTEGER_BYTE_SIZE,
} :: okserde.StaticSchema<integer>

```

You can then use this schema in other composite schemas or by itself:

```luau
-- /main.luau
const okserde = require("../../src")
const schemas, encodings = okserde.schemas, okserde.encodings
const serialize, deserialize = okserde.serialize, okserde.deserialize

const integer_schema = require("./integer")

-- use by itself
const serialized_integer = serialize(integer_schema, 1i)
print(buffer.len(serialized_integer)) --> 8

const deserialized_integer = deserialize(integer_schema, serialized_integer)
assert(deserialized_integer == 1i)

-- use in composite schemas
const composite_schema = schemas.array(integer_schema, encodings.u8)

const serialized_composite = serialize(composite_schema, { 3i, 31i, 3141592i })
print(buffer.len(serialized_composite)) --> 25

const deserialized_composite = deserialize(composite_schema, serialized_composite)
assert(deserialized_composite[1] == 3i)
assert(deserialized_composite[2] == 31i)
assert(deserialized_composite[3] == 3141592i)

```

### Roblox Example

```luau
const ReplicatedStorage = game:GetService("ReplicatedStorage")

const okserde = require(ReplicatedStorage.okserde)
const okserde_rbx = require(ReplicatedStorage.okserde.rbx)
const schemas, encodings = okserde.schemas, okserde.encodings
const serialize, deserialize = okserde.serialize, okserde.deserialize

-- defining a composite schema
const colors_schema = schemas.array(okserde_rbx.Color3, encodings.u8)

const colors = { Color3.new(1, 0, 0), Color3.new(0, 0, 1), Color3.new(1, 0, 1) }

-- serialization
const serialized_colors = serialize(colors_schema, colors)
print(buffer.len(serialized_colors)) --> 10

-- deserialization
const deserialized_colors = deserialize(colors_schema, serialized_colors)
assert(deserialized_colors[1] == colors[1])
assert(deserialized_colors[2] == colors[2])
assert(deserialized_colors[3] == colors[3])

-- you can send buffers across RemoteEvents and RemoteFunctions for less bandwidth usage
const some_remote = ReplicatedStorage:WaitForChild("SomeRemote") :: RemoteEvent
some_remote:FireServer(serialized_colors)

-- server side:
some_remote.OnServerEvent:Connect(function(player: Player, serialized_colors: buffer)
	-- you will also have to define the same schema on the receiving context to deserialize properly
	const deserialized_colors = deserialize(colors_schema, serialized_colors)

	print("received colors from ", player, deserialized_colors)
end)

```

## Out-of-Scope Features/Goals

Here are some things that while would be nice to have all in one library, are generally out of the scope of this project.
That doesn't mean that this library couldn't be used to accomplish some of these things however!
- lossless buffer compression (`zlib`, `DEFLATE`, etc.)
- value deduplication
- Roblox networking / client-server synchronization
- built-in full Roblox Instance serializing/deserializing (can be manually done with the given tools!)
- AOT compilation
- JSON serialization/deserialization

## Attributions

- Initially based off of athar_adventure's [BufferConverter2](https://devforum.roblox.com/t/temporarily-archived-bufferconverter2-blazingly-fast-schema-based-buffer-serialization/3429040),
though has severely pivotted towards a more modular, runtime-agnostic paradigm.

## Alternatives

- [BufferConverter2](https://devforum.roblox.com/t/temporarily-archived-bufferconverter2-blazingly-fast-schema-based-buffer-serialization/3429040) by @athar-adv
- [BufferEncoder](https://github.com/anexpia/BufferEncoder) by @anexpia
- [Sera](https://github.com/MadStudioRoblox/Sera) by Mad Studio
- [BufferUtil](https://github.com/Sleitnick/RbxUtil/tree/main/modules/buffer-util) by @Sleitnick
- [Serde](https://devforum.roblox.com/t/serde-schema-based-serialization-deserialization/3668435) by @saaawdust