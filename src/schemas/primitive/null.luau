local Schema = require "../Schema"

return Schema "null" {
	write = function() end,
	read = function(): nil end,
	size = function(): number
		return 0
	end,

	validate = function(value: unknown): boolean
		return value == nil
	end,
}
