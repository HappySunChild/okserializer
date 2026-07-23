export type ReprOptions = {
	pretty_tables: boolean?,
	show_function_debug_names: boolean?,
	show_function_bodies: boolean?,
	show_buffer_bytes: boolean?,
	show_explicit_array_keys: boolean?,
	convert_numerical_language_constants: boolean?,
	max_table_depth: number?,
}

const DEFAULT_OPTIONS: ReprOptions = {
	pretty_tables = true,
	show_function_debug_names = true,
	show_function_bodies = false,
	show_buffer_bytes = true,
	show_explicit_array_keys = false,
	convert_numerical_language_constants = true,
	max_table_depth = 20, -- seems reasonable to me
}

const function render_table(
	record_part: { string },
	array_part: { string },
	indent: number,
	pretty: boolean
): string
	if #record_part + #array_part == 0 then
		return "{}"
	end

	if pretty then
		const outer_indent = string.rep("\t", indent)
		const inner_indent = string.rep("\t", indent + 1)
		const lines = { "{" }

		for _, value in array_part do
			table.insert(lines, `{inner_indent}{value},`)
		end

		for _, pair in record_part do
			table.insert(lines, `{inner_indent}{pair},`)
		end

		table.insert(lines, `{outer_indent}}`)

		return table.concat(lines, "\n")
	else
		const fields = table.create(#record_part + #array_part)

		for _, value in array_part do
			table.insert(fields, value)
		end

		for _, pair in record_part do
			table.insert(fields, pair)
		end

		return `\{ {table.concat(fields, ", ")} }`
	end
end

const LUAU_KEYWORDS = {
	["and"] = true,
	["break"] = true,
	["continue"] = true,
	["do"] = true,
	["else"] = true,
	["elseif"] = true,
	["end"] = true,
	["false"] = true,
	["for"] = true,
	["function"] = true,
	["if"] = true,
	["in"] = true,
	["local"] = true,
	["nil"] = true,
	["not"] = true,
	["while"] = true,
	["or"] = true,
	["repeat"] = true,
	["return"] = true,
	["then"] = true,
	["true"] = true,
	["until"] = true,
}

const function is_luau_identifier(v: any): boolean
	if type(v) ~= "string" then
		return false
	end

	if string.len(v) == 0 then
		return false
	end

	if string.match(v, "^[%a_][%w_]*$") == nil then
		return false
	end

	if LUAU_KEYWORDS[v] then
		return false
	end

	return true
end

const function repr_primitive(x: any, options: ReprOptions): string
	const x_type = type(x)

	if x_type == "nil" then
		return "nil"
	elseif x_type == "string" then
		return string.format("%q", x)
	elseif x_type == "boolean" then
		return tostring(x)
	elseif x_type == "number" then
		if options.convert_numerical_language_constants then
			if x == math.huge then
				return "math.huge"
			elseif x == -math.huge then
				return "-math.huge"
			elseif x ~= x then
				return "math.nan"
			end
		end

		return tostring(x)
	elseif x_type == "integer" then -- integers are generally niche, but they are technically a different data type
		return `{x}i`
	elseif x_type == "vector" then
		return `vector.create({repr_primitive(x.x, options)}, {repr_primitive(x.y, options)}, {repr_primitive(
			x.z,
			options
		)})`
	elseif x_type == "buffer" then
		const show_bytes = options.show_buffer_bytes
		const len = buffer.len(x)

		if show_bytes then
			const escapes = table.create(len)

			for index = 1, len do
				escapes[index] = string.format("\\x%02X", buffer.readu8(x, index - 1))
			end

			const buffer_string = table.concat(escapes, "")

			return `buffer.fromstring("{buffer_string}")`
		else
			return `buffer.create({len})`
		end
	elseif x_type == "function" then
		const show_debug_name = options.show_function_debug_names
		const show_body = options.show_function_bodies

		const arg_count: number, is_variadic: boolean, debug_name: string? =
			debug.info(x :: () -> (), "an")
		const arg_list: { string } = {}

		for i = 1, arg_count do
			table.insert(arg_list, `a{i}`)
		end

		if is_variadic then
			table.insert(arg_list, "...")
		end

		const display_args = table.concat(arg_list, ", ")

		const display_name = if show_debug_name and is_luau_identifier(debug_name)
			then debug_name
			else ""
		const display_body = if show_body then " end" else ""

		return `function {display_name}({display_args}){display_body}`
	end

	return `<{x_type}: {x}>`
end

const function repr_table(
	current_t: { [any]: any },
	showing: { [any]: number },
	depth: number,
	options: ReprOptions
): string
	if options.max_table_depth ~= nil and depth >= options.max_table_depth then
		return "{ ... }"
	end

	if showing[current_t] ~= nil then
		return `\{ RECURSIVE +{depth - showing[current_t]} }`
	end

	const show_array_keys = options.show_explicit_array_keys

	showing[current_t] = depth

	const record_part: { string } = {}
	const array_part: { string } = {}

	const array_len = #current_t

	for key: any, value: any in current_t do
		const field_value = if type(value) == "table"
			then repr_table(value, showing, depth + 1, options)
			else repr_primitive(value, options)

		if not show_array_keys and type(key) == "number" and key > 0 and key <= array_len then
			table.insert(array_part, field_value)
			continue
		end

		const field_key = if is_luau_identifier(key)
			then tostring(key)
			else `[{(if type(key) == "table"
				then repr_table(key, showing, depth + 1, options)
				else repr_primitive(key, options))}]`

		table.insert(record_part, `{field_key} = {field_value}`)
	end

	table.sort(record_part)

	local output = render_table(record_part, array_part, depth, options.pretty_tables or false)
	const metatable = getmetatable(current_t) :: any?

	if type(metatable) == "table" then
		output = `setmetatable({output}, {repr_table(metatable, showing, depth, options)})`
	end

	if table.isfrozen(current_t) then
		output = `table.freeze({output})`
	end

	showing[current_t] = nil

	return output
end

const function repr(x: any, options: ReprOptions?): string
	options = options or DEFAULT_OPTIONS

	if type(x) == "table" then
		return repr_table(x, {}, 0, options)
	else
		return repr_primitive(x, options)
	end
end

return repr
