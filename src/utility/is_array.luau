const function is_array(t: unknown): boolean
	if type(t) ~= "table" then
		return false
	end

	const len = #t

	return next(t, if len > 0 then len else nil) == nil
end

return is_array
