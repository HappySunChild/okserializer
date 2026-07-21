const function is_similar(a: any, b: any): boolean
	const eq = a == b

	if eq then
		return true
	end

	const a_type = type(a)
	const b_type = type(b)

	if a_type ~= b_type then
		return false
	end

	if a_type == "table" then
		for a_key, a_value in a do
			const b_value = b[a_key]

			if not is_similar(a_value, b_value) then
				return false
			end
		end

		for b_key, b_value in b do
			const a_value = a[b_key]

			if not is_similar(a_value, b_value) then
				return false
			end
		end
	end

	return true
end

return is_similar
