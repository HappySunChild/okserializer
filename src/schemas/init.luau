return table.freeze {
	null = require "@self/primitive/null",
	boolean = require "@self/primitive/boolean",
	number = require "@self/primitive/number",
	vector = require "@self/primitive/vector",
	array = require "@self/primitive/array",
	bitarray = require "@self/primitive/bitarray",
	buffer = require "@self/primitive/buffer",
	set = require "@self/primitive/set",

	string = require "@self/primitive/string",
	csetstring = require "@self/primitive/csetstring",
	tmstring = require "@self/primitive/tmstring",
	nullstring = require "@self/primitive/nullstring",

	struct = require "@self/compound/struct",
	union = require "@self/compound/union",
	optional = require "@self/compound/optional",
	tuple = require "@self/compound/tuple",

	CFrame = require "@self/roblox/CFrame",
	Enum = require "@self/roblox/Enum",
	Vector2 = require "@self/roblox/Vector2",
	Vector3 = require "@self/roblox/Vector3",
	BrickColor = require "@self/roblox/BrickColor",
	Color3 = require "@self/roblox/Color3",
}
