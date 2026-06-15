const types = require("../../types")

const determine_spec = require("../../utility/determine_spec")

const function determine_schema<T>(value: T, schemas: { types.Schema<any> }): (number?, types.Schema<T>?)
	for index, schema in schemas do
		if schema.validate(value) then
			return index, schema
		end
	end

	return nil, nil
end

const function union_schema(...: types.Schema<any>): types.Schema<any>
	const schemas = { ... }

	const id = determine_spec(#schemas)
	const id_write, id_read, id_size = id.write, id.read, id.size

	return {
		write = function(b: buffer, offset: number, value: any)
			const index, schema = determine_schema(value, schemas)

			if index == nil or schema == nil then
				error(`no valid schema available in union for value of type {typeof(value)} (value: {value})`)
			end

			id_write(b, offset, index)

			schema.write(b, offset + id_size, value)
		end,
		read = function(b: buffer, offset: number): any
			const index = id_read(b, offset)
			const schema = schemas[index]

			return schema.read(b, offset + id_size)
		end,
		size = function(value: any): number
			const index, schema = determine_schema(value, schemas)

			if index == nil or schema == nil then
				error(`no valid schema available in union for value of type {typeof(value)} (value: {value})`)
			end

			const size = schema.size(value)

			return id_size + size
		end,
		validate = function(value: unknown): boolean
			const index, schema = determine_schema(value, schemas)

			if index == nil or schema == nil then
				return false,
					`no valid schema available in union for value of type {typeof(value)} (value: {value})`
			end

			return true, nil
		end,
	}
end

return union_schema
