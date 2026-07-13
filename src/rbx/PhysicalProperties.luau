local specs = require("../../specs")
local types = require("../../types")

local s16 = specs.s16
local s16_write, s16_read, s16_size = s16.write, s16.read, s16.size

const schema_size = s16_size * 5

const PhysicalProperties_schema: types.Schema<PhysicalProperties> = {
	write = @native function(b: buffer, offset: number, value: PhysicalProperties): number
		s16_write(b, offset, value.Density / 100)
		s16_write(b, offset + s16_size, value.Friction / 2)
		s16_write(b, offset + s16_size * 2, value.Elasticity)
		s16_write(b, offset + s16_size * 3, value.FrictionWeight / 100)
		s16_write(b, offset + s16_size * 4, value.ElasticityWeight / 100)
		return schema_size
	end,
	read = @native function(b: buffer, offset: number): (number, PhysicalProperties)
		return schema_size,
			PhysicalProperties.new(
				s16_read(b, offset) * 100, -- density
				s16_read(b, offset + s16_size) * 2, -- friction
				s16_read(b, offset + s16_size * 2), -- elasticity
				s16_read(b, offset + s16_size * 3) * 100, -- friction weight
				s16_read(b, offset + s16_size * 4) * 100 -- elasticity weight
			)
	end,
	alloc_size = @native function(): number
		return schema_size
	end,
	validate = @native function(value: unknown): (boolean, string?)
		if typeof(value) ~= "PhysicalProperties" then
			return false, `expected value of type PhysicalProperties, got {typeof(value)}`
		end

		return true, nil
	end,
}

return PhysicalProperties_schema
