# okserde
A low-abstraction, schema-based Luau buffer serializer/deserializer.
This library provides a lot of schemas for serializing common datatypes in Luau.
It also provides some runtime-specific schemas for Roblox datatypes that can be found under the `okserde/rbx` module.

Initially based off of athar_adventure's [BufferConverter2](https://devforum.roblox.com/t/temporarily-archived-bufferconverter2-blazingly-fast-schema-based-buffer-serialization/3429040).

## Usage Example

Here's a simple example that creates a `Person` schema, then using that schema, serializes and deserializes a person,
and finally asserts that the pre-serialization and post-deserialization values are similar.

```luau
const okserde = require("okserde")
const schemas, specs = okserde.schemas, okserde.specs
const serialize, deserialize = okserde.serialize, okserde.deserialize

type Person = {
	first_name: string,
	last_name: string,
	age: number,
}

-- defining a composite schema
const person_schema = schemas.struct<<Person>>({
	first_name = schemas.string(),
	last_name = schemas.string(specs.u8), -- you can specify how the length header for strings are encoded, defaults to u16
	age = schemas.number(specs.u8), -- same for numbers, defaults to f32
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

The design of this library is supposed to be as simple as possible, so that creating your own custom schemas is super simple and easy.
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
	alloc_size = function()
		return INTEGER_BYTE_SIZE
	end,
	validate = function(value: unknown): (boolean, string?)
		if type(value) ~= "integer" then
			return false, `expected value of type integer, got {type(value)}`
		end

		return true, nil
	end,
} :: okserde.Schema<integer>

```

You can then use this schema in other composite schemas or by itself:

```luau
-- /main.luau
const okserde = require("okserde")
const schemas, specs = okserde.schemas, okserde.specs
const serialize, deserialize = okserde.serialize, okserde.deserialize

const integer_schema = require("./integer")

-- use by itself
const serialized_integer = serialize(integer_schema, 1i)
print(buffer.len(serialized_integer)) --> 8

const deserialized_integer = deserialize(integer_schema, serialized_integer)
assert(deserialized_integer == 1i)

-- use in composite schemas
const composite_schema = schemas.array(integer_schema, specs.u8)

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

const okserde = require(ReplicatedStorage.Libraries.okserde)
const okserde_rbx = require(ReplicatedStorage.Libraries.okserde.rbx)
const schemas, specs = okserde.schemas, okserde.specs
const serialize, deserialize = okserde.serialize, okserde.deserialize

-- defining a composite schema
const colors_schema = schemas.array(okserde_rbx.Color3, specs.u8)

const colors = { Color3.new(1, 0, 0), Color3.new(0, 0, 1), Color3.new(1, 0, 1) }

-- serialization
const serialized_colors = serialize(colors_schema, colors)
print(buffer.len(serialized_colors)) --> 10

-- deserialization
const deserialized_colors = deserialize(colors_schema, serialized_colors)
assert(deserialized_colors[1] == colors[1])
assert(deserialized_colors[2] == colors[2])
assert(deserialized_colors[3] == colors[3])

-- you can also send serialized data across RemoteEvents and RemoteFunctions for less bandwidth usage
-- note that the receiving side must also have the same schema to deserialize the incoming data
const some_remote = ReplicatedStorage:WaitForChild("SomeRemote") :: RemoteEvent
some_remote:FireServer(serialized_colors)

-- server side:
some_remote.OnServerEvent:Connect(function(player: Player, serialized_colors: buffer)
	const deserialized_colors = deserialize(colors_schema, serialized_colors)

	print("received colors from ", player, deserialized_colors)
end)

```