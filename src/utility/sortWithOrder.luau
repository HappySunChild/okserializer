local function sortWithOrder<T>(list: { T }, order: { T }?)
	if not order then
		table.sort(list)

		return
	end

	table.sort(list, function(a: T, b: T)
		local a_index = table.find(order, a) or 0
		local b_index = table.find(order, b) or 0

		return a_index > b_index
	end)
end

return sortWithOrder
