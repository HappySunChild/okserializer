local encodings = require("../encodings")
local okserde = require("../types")

local un16 = encodings.un16
local un16_write, un16_read, un16_size = un16.write, un16.read, un16.size

const SCHEMA_SIZE = un16_size * 5

const PhysicalProperties_schema: okserde.StaticSchema<PhysicalProperties> = {
	write = @native function(b: buffer, offset: number, value: PhysicalProperties): number
		un16_write(b, offset, value.Density / 100)
		un16_write(b, offset + un16_size, value.Friction / 2)
		un16_write(b, offset + un16_size * 2, value.Elasticity)
		un16_write(b, offset + un16_size * 3, value.FrictionWeight / 100)
		un16_write(b, offset + un16_size * 4, value.ElasticityWeight / 100)
		return SCHEMA_SIZE
	end,
	read = @native function(b: buffer, offset: number): (number, PhysicalProperties)
		return SCHEMA_SIZE,
			PhysicalProperties.new(
				un16_read(b, offset) * 100, -- density
				un16_read(b, offset + un16_size) * 2, -- friction
				un16_read(b, offset + un16_size * 2), -- elasticity
				un16_read(b, offset + un16_size * 3) * 100, -- friction weight
				un16_read(b, offset + un16_size * 4) * 100 -- elasticity weight
			)
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "PhysicalProperties" then
			return false, `expected value of type PhysicalProperties, got {typeof(value)}`
		end

		return true, nil
	end,

	static_size = SCHEMA_SIZE,
}

return PhysicalProperties_schema
