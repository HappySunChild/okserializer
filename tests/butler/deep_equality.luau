const function deep_equality(a: any, b: any): boolean
	if a == b then
		return true
	end

	local a_type = type(a)
	local b_type = type(b)

	if a_type ~= b_type then
		return false
	end

	if a_type == "table" then
		for key, value in a do
			if not deep_equality(value, b[key]) then
				return false
			end
		end

		for key, value in b do
			if a[key] == nil then
				return false
			end
		end

		return true
	elseif a_type == "number" then
		return math.isnan(a) and math.isnan(b)
	elseif a_type == "buffer" then
		return buffer.tostring(a) == buffer.tostring(b)
	end

	return false
end

return deep_equality
