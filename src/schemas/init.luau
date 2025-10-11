return table.freeze {
	-- Primitive
	null = require "@self/primitive/null",
	boolean = require "@self/primitive/boolean",
	number = require "@self/primitive/number",
	vector = require "@self/primitive/vector",
	buffer = require "@self/primitive/buffer",
	string = require "@self/primitive/string",

	-- Custom
	set = require "@self/custom/set",
	bitarray = require "@self/custom/bitarray",
	csetstring = require "@self/custom/csetstring",
	termstring = require "@self/custom/termstring",
	nullstring = require "@self/custom/nullstring",

	-- Compound
	array = require "@self/compound/array",
	tuple = require "@self/compound/tuple",
	struct = require "@self/compound/struct",
	union = require "@self/compound/union",
	optional = require "@self/compound/optional",

	-- Roblox
	Axes = require "@self/roblox/Axes",
	BrickColor = require "@self/roblox/BrickColor",
	CFrame = require "@self/roblox/CFrame",
	Color3 = require "@self/roblox/Color3",
	Content = require "@self/roblox/Content",
	Enum = require "@self/roblox/Enum",
	EnumItem = require "@self/roblox/EnumItem",
	NumberRange = require "@self/roblox/NumberRange",
	PathWaypoint = require "@self/roblox/PathWaypoint",
	Rect = require "@self/roblox/Rect",
	Region3 = require "@self/roblox/Region3",
	TweenInfo = require "@self/roblox/TweenInfo",
	Vector2 = require "@self/roblox/Vector2",
	Vector3 = require "@self/roblox/Vector3",
}
