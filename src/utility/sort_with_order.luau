local function sort_with_order<T>(list: { T }, order: { T }?)
	if order == nil then
		table.sort(list)

		return
	end

	table.sort(list, function(a: T, b: T)
		local a_index = table.find(order, a) or 0
		local b_index = table.find(order, b) or 0

		return a_index > b_index
	end)
end

return sort_with_order
