local formats = require("../../formats")
local types = require("../../types")

local s16 = formats.s16
local write, read, size = s16.write, s16.read, s16.size

return {
	write = function(b: buffer, offset: number, value: PhysicalProperties)
		write(b, offset, value.Density / 100)
		write(b, offset + size, value.Friction / 2)
		write(b, offset + size * 2, value.Elasticity)
		write(b, offset + size * 3, value.FrictionWeight / 100)
		write(b, offset + size * 4, value.ElasticityWeight / 100)
	end,
	read = function(b: buffer, offset: number): PhysicalProperties
		return PhysicalProperties.new(
			read(b, offset) * 100, -- density
			read(b, offset + size) * 2, -- friction
			read(b, offset + size * 2), -- elasticity
			read(b, offset + size * 3) * 100, -- friction weight
			read(b, offset + size * 4) * 100 -- elasticity weight
		)
	end,
	size = function(): number
		return size * 5
	end,
	validate = function(value: unknown): boolean
		return typeof(value) == "PhysicalProperties"
	end,
} :: types.Schema<PhysicalProperties>
