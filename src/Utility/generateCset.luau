local function generateCset(str: string)
	local frequencies = {}
	local characters = {}

	for i = 1, string.len(str) do
		local char = string.sub(str, i, i)

		if frequencies[char] == nil then
			frequencies[char] = 0
			table.insert(characters, char)
		end

		frequencies[char] += 1
	end

	table.sort(characters, function(a: string, b: string)
		return frequencies[a] > frequencies[b]
	end)

	return table.concat(characters)
end

return generateCset
