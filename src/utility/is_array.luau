const function is_array(t: unknown): boolean
	if type(t) ~= "table" then
		return false
	end

	return next(t, #t) == nil
end

return is_array
