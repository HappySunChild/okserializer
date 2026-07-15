const function vararg_repr(...: any): string
	const output = {}

	for i = 1, select("#", ...) do
		const value = select(i, ...)

		table.insert(output, `{typeof(value)} ({value})`)
	end

	return table.concat(output, ", ")
end

return vararg_repr
