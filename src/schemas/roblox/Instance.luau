local types = require "../../types"

local Schema = require "../Schema"

local Schema_struct = require "../compound/struct"

-- glorified struct wrapper

-- I don't feel like making a whole system for "cleanly" replicating
-- and keeping track of instance ids for cross server communication
-- so this is all you're getting, make a PR if you really want it.
return function(className: string)
	return function(properties: { [string]: types.Schema<...any> }): types.Schema<Instance>
		local _schem = Schema_struct(properties)
		local write, read, size = _schem.write, _schem.read, _schem.size

		return Schema "Instance" {
			write = write,
			read = function(b: buffer, offset: number): Instance
				local props = read(b, offset)
				local instance = Instance.new(className)

				for key, value in props do
					(instance :: any)[key] = value
				end

				return instance
			end,
			size = size,

			validate = function(value: unknown): boolean
				return typeof(value) == "Instance" and value.ClassName == className
			end,
		}
	end
end
