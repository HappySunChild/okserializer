local Schema = require "../Schema"

return Schema "null" {
	write = function() end,
	read = function(): nil
		return nil -- not really necessary, but it's kind of funny
	end,
	size = function(): number
		return 0
	end,

	validate = function(value: unknown)
		return value == nil
	end,
}
