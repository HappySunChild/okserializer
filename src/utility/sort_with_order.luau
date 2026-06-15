const function sort_with_order<T>(list: { T }, order: { T }?)
	if order == nil then
		table.sort(list)
		return
	end

	const values_to_indices: { [T]: number } = {}

	for index, value in order do
		values_to_indices[value] = index
	end

	table.sort(list, function(a: T, b: T)
		const a_index = values_to_indices[a] or 0
		const b_index = values_to_indices[b] or 0

		return a_index > b_index
	end)
end

return sort_with_order
