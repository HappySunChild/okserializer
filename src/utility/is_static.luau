const okserde = require("../types")

const function is_static(shape: { [any]: okserde.Schema<any> }): (boolean, number?)
	local total_size = 0

	for _, schema in shape do
		const static_size = schema.static_size

		if static_size == nil then
			return false
		end

		total_size += static_size
	end

	return true, total_size
end

return is_static
