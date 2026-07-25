const okserde = require("../types")

const function move_dyn_sizes_into<K>(
	schemas: { [K]: okserde.SizedSchema },
	mut_dyn_sizes: { [K]: (...any) -> number }
)
	for key, schema in schemas do
		const dyn_size = schema.dyn_size

		if dyn_size ~= nil then
			mut_dyn_sizes[key] = dyn_size
		end
	end
end

return move_dyn_sizes_into
