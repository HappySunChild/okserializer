const okserde = require("../types")

const function is_shape_static(
	shape: { [any]: okserde.SizedSchema | okserde.UnresolvedSchema }
): (boolean, number)
	local total_size = 0
	local is_static = true

	for key, schema in shape do
		const schema_type = type(schema)

		if schema_type == "function" then -- CASE: unresolved dynschema
			is_static = false
			continue
		elseif schema_type == "table" then -- CASE: sizedschema
			const static_size = schema.static_size

			if static_size == nil then
				is_static = false
				continue
			end

			total_size += static_size
		end
	end

	return is_static, total_size
end

return is_shape_static
