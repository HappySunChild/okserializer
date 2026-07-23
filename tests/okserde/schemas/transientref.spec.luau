const transientref_schema = require("@okserde/schemas/transientref")

const generate_serde_tests = require("@utility/generate_serde_tests")

const butler = require("@butler/butler")

return function(configured: butler.Configured)
	const expect = configured.expect

	return configured.unit("schema / transientref", function(test: butler.Test)
		test("constructs", function()
			expect(transientref_schema({})):to_exist()
		end)
		test("255 max references", function()
			const references = table.create(254, 0)
			expect(#references):to_be(254)

			const schema = transientref_schema(references)
			const b = buffer.create(1)
			expect(schema.write):to_never_throw(b, 0, 0)
			expect(schema.write):to_throw(b, 0, 0)
			table.clear(references)
			expect(schema.write):to_never_throw(b, 0, 0)
		end)

		generate_serde_tests({
			test = test,
			cases = {
				{
					label = "transientref",
					schema = transientref_schema({}),
					sets = {
						{
							expected_size_bytes = 1,
							values = { newproxy() },
						},
						{
							expected_size_bytes = 1,
							values = { { foo = math.huge, bar = "foobar", car = function() end } },
						},
					},
				},
			},
		})
	end)
end
