local specs = require("../../specs")
local types = require("../../types")

local s16 = specs.s16
local s16_write, s16_read, s16_size = s16.write, s16.read, s16.size

const PhysicalProperties_schema = {
	write = function(b: buffer, offset: number, value: PhysicalProperties)
		s16_write(b, offset, value.Density / 100)
		s16_write(b, offset + s16_size, value.Friction / 2)
		s16_write(b, offset + s16_size * 2, value.Elasticity)
		s16_write(b, offset + s16_size * 3, value.FrictionWeight / 100)
		s16_write(b, offset + s16_size * 4, value.ElasticityWeight / 100)
	end,
	read = function(b: buffer, offset: number): PhysicalProperties
		return PhysicalProperties.new(
			s16_read(b, offset) * 100, -- density
			s16_read(b, offset + s16_size) * 2, -- friction
			s16_read(b, offset + s16_size * 2), -- elasticity
			s16_read(b, offset + s16_size * 3) * 100, -- friction weight
			s16_read(b, offset + s16_size * 4) * 100 -- elasticity weight
		)
	end,
	size = function(): number
		return s16_size * 5
	end,
	validate = function(value: unknown): (boolean, string?)
		if typeof(value) ~= "PhysicalProperties" then
			return false, `expected value of type PhysicalProperties, got {typeof(value)}`
		end

		return true, nil
	end,
} :: types.Schema<PhysicalProperties>

return PhysicalProperties_schema
