const fmt_repr = require("./fmt_repr")
const deep_equality = require("./deep_equality")

type Indexable = { [any]: any }
type Callable<A... = ...any, R... = ...any> = (A...) -> R...
type LanguageType =
	"nil"
	| "string"
	| "number"
	| "boolean"
	| "table"
	| "function"
	| "thread"
	| "userdata"
	| "vector"
	| "buffer"
	| string

export type ExpectTests = {
	to_exist: (self: ExpectTests) -> ExpectTests,
	to_never_exist: (self: ExpectTests) -> ExpectTests,

	to_equal: (self: ExpectTests, x: any) -> ExpectTests,
	to_never_equal: (self: ExpectTests, x: any) -> ExpectTests,

	to_be: (self: ExpectTests, x: any) -> ExpectTests,
	to_never_be: (self: ExpectTests, x: any) -> ExpectTests,

	to_be_a: (self: ExpectTests, type: LanguageType) -> ExpectTests,
	to_never_be_a: (self: ExpectTests, type: LanguageType) -> ExpectTests,

	-- number assertions
	to_be_near: (self: ExpectTests, x: number, tolerance: number) -> ExpectTests,
	to_never_be_near: (self: ExpectTests, x: number, tolerance: number) -> ExpectTests,

	to_be_less_than: (self: ExpectTests, x: number) -> ExpectTests,
	to_never_be_less_than: (self: ExpectTests, x: number) -> ExpectTests,

	to_be_greater_than: (self: ExpectTests, x: number) -> ExpectTests,
	to_never_be_greater_than: (self: ExpectTests, x: number) -> ExpectTests,

	-- table/userdata assertions
	to_have_key: (self: ExpectTests, key: any) -> ExpectTests,
	to_never_have_key: (self: ExpectTests, key: any) -> ExpectTests,

	to_have_keys: (self: ExpectTests, keys: { any }) -> ExpectTests,
	to_never_have_keys: (self: ExpectTests, keys: { any }) -> ExpectTests,

	to_have_keys_of_type: (self: ExpectTests, keys: { [any]: LanguageType }) -> ExpectTests,
	to_never_have_keys_of_type: (self: ExpectTests, keys: { [any]: LanguageType }) -> ExpectTests,

	to_only_have_keys: (self: ExpectTests, keys: { any }) -> ExpectTests,
	to_never_only_have_keys: (self: ExpectTests, keys: { any }) -> ExpectTests,

	to_have_value: (self: ExpectTests, value: any) -> ExpectTests,
	to_never_have_value: (self: ExpectTests, value: any) -> ExpectTests,

	to_have_values: (self: ExpectTests, values: { any }) -> ExpectTests,
	to_never_have_values: (self: ExpectTests, values: { any }) -> ExpectTests,

	to_only_have_values: (self: ExpectTests, values: { any }) -> ExpectTests,
	to_never_only_have_values: (self: ExpectTests, values: { any }) -> ExpectTests,

	to_have_pairs: (self: ExpectTests, pairs: { [any]: any }) -> ExpectTests,
	to_never_have_pairs: (self: ExpectTests, pairs: { [any]: any }) -> ExpectTests,

	to_be_empty: (self: ExpectTests) -> ExpectTests,
	to_never_be_empty: (self: ExpectTests) -> ExpectTests,

	-- callable assertions
	to_throw: (self: ExpectTests, ...unknown) -> ExpectTests,
	to_never_throw: (self: ExpectTests, ...unknown) -> ExpectTests,

	to_throw_matching: (self: ExpectTests, message: string, ...unknown) -> ExpectTests,
	to_never_throw_matching: (self: ExpectTests, message: string, ...unknown) -> ExpectTests,

	to_evaluate_to: (self: ExpectTests, value: unknown, ...unknown) -> ExpectTests,
	to_never_evaluate_to: (self: ExpectTests, value: unknown, ...unknown) -> ExpectTests,
}
type Self<T = unknown> = {
	v: T,
} & ExpectTests

const ERR_INDEXABLE_TYPE = "expect() value must be indexable"
const ERR_CALLABLE_TYPE = "expect() value must be callable"

const function check_indexable(x: unknown): boolean
	return type(x) == "table" or type(x) == "userdata"
end

const function check_callable(x: unknown): boolean
	if type(x) == "function" then
		return true
	end

	return check_indexable(x)
		and if getmetatable(x :: any) ~= nil then check_callable(getmetatable(x :: any).__call) else false
end

const function fail(value: any, reason: string, ...: any): never
	const label = debug.info(2, "n")

	const args = { ... }

	for index, arg in args do
		args[index] = fmt_repr(arg)
	end

	error({
		type = "failed_expectation",
		message = `Expectation not met, because:\n{reason}`,
		trace = debug.traceback(nil, 3),
		line = debug.info(3, "l"),
		code = `expect({fmt_repr(value)}):{label}({table.concat(args, ", ")})`,
	}, 0)
end

const function assert_usage(condition: boolean, reason: string)
	if not condition then
		const label = debug.info(2, "n")

		error(`Bad usage of expect():{label}()\nReason: {reason}`, 0)
	end
end

const CLASS_METATABLE = table.freeze({
	__index = table.freeze({
		to_exist = function(self: Self): Self
			if self.v == nil then
				fail(self.v, `is nil`)
			end

			return self
		end,
		to_never_exist = function(self: Self): Self
			if self.v ~= nil then
				fail(self.v, `isn't nil`)
			end

			return self
		end,

		to_equal = function(self: Self, x: any): Self
			if not deep_equality(self.v, x) then
				fail(self.v, `does not equal {fmt_repr(x)}`, x)
			end

			return self
		end,
		to_never_equal = function(self: Self, x: any): Self
			if deep_equality(self.v, x) then
				fail(self.v, `equals {fmt_repr(x)}`, x)
			end

			return self
		end,

		to_be = function(self: Self, x: any): Self
			if self.v ~= x then
				fail(self.v, `is not {x}`, x)
			end

			return self
		end,
		to_never_be = function(self: Self, x: any): Self
			if self.v == x then
				fail(self.v, `is {x}`, x)
			end

			return self
		end,

		to_be_a = function(self: Self, x_type: string): Self
			const a = self.v

			if typeof(a) ~= x_type then
				fail(a, `isn't of type '{x_type}'`, x_type)
			end

			return self
		end,
		to_never_be_a = function(self: Self, x_type: string): Self
			const a = self.v

			if typeof(a) == x_type then
				fail(a, `is of type '{x_type}'`, x_type)
			end

			return self
		end,

		-- number assertions
		to_be_near = function(self: Self<number>, x: number, tolerance: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number.")
			assert_usage(type(x) == "number", "to_be_near() x must be a number.")
			assert_usage(type(tolerance) == "number", "to_be_near() tolerance must be a number.")

			if math.abs(a - x) > tolerance then
				fail(a, `|{fmt_repr(a)} - {x}| > {tolerance}`, x, tolerance)
			end

			return self
		end,
		to_never_be_near = function(self: Self<number>, x: number, tolerance: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number")
			assert_usage(type(x) == "number", "to_be_near() x must be a number.")
			assert_usage(type(tolerance) == "number", "to_be_near() tolerance must be a number.")

			if math.abs(a - x) <= tolerance then
				fail(a, `|{fmt_repr(self.v)} - {x}| <= {tolerance}`, x, tolerance)
			end

			return self
		end,

		to_be_less_than = function(self: Self<number>, x: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number.")
			assert_usage(type(x) == "number", "to_be_less_than() x must be a number.")

			if a >= x then
				fail(a, `{fmt_repr(a)} >= {x}`, x)
			end

			return self
		end,
		to_never_be_less_than = function(self: Self<number>, x: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number.")
			assert_usage(type(x) == "number", "to_never_be_less_than() value must be a number.")

			if a < x then
				fail(a, `{fmt_repr(a)} < {x}`, x)
			end

			return self
		end,

		to_be_greater_than = function(self: Self<number>, x: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number.")
			assert_usage(type(x) == "number", "to_be_greater_than() x must be a number.")

			if a <= x then
				fail(a, `{fmt_repr(a)} <= {x}`, x)
			end

			return self
		end,
		to_never_be_greater_than = function(self: Self<number>, x: number): Self<number>
			const a = self.v

			assert_usage(type(a) == "number", "expect() value must be a number.")
			assert_usage(type(x) == "number", "to_never_be_greater_than() value must be a number.")

			if a > x then
				fail(a, `{fmt_repr(a)} > {x}`, x)
			end

			return self
		end,

		-- table/userdata assertions
		to_have_key = function(self: Self<Indexable>, key: any): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			if a[key] == nil then
				fail(a, `value at key [{fmt_repr(key)}] == nil`, key)
			end

			return self
		end,
		to_never_have_key = function(self: Self<Indexable>, key: any): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			if a[key] ~= nil then
				fail(a, `value at key [{fmt_repr(key)}] ~= nil`, key)
			end

			return self
		end,

		to_have_keys = function(self: Self<Indexable>, target_keys: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, key in target_keys do
				if a[key] == nil then
					fail(a, `value at key [{fmt_repr(key)}] == nil`, target_keys)
				end
			end

			return self
		end,
		to_never_have_keys = function(self: Self<Indexable>, target_keys: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, key in target_keys do
				if a[key] ~= nil then
					fail(a, `value at key [{fmt_repr(key)}] ~= nil`, target_keys)
				end
			end

			return self
		end,

		to_have_keys_of_type = function(
			self: Self<Indexable>,
			keys: { [any]: LanguageType }
		): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key, value_type in keys do
				if type(a[key]) ~= value_type then
					fail(a, `type of value at key [{fmt_repr(key)}] ~= "{value_type}"`, keys)
				end
			end

			return self
		end,
		to_never_have_keys_of_type = function(
			self: Self<Indexable>,
			keys: { [any]: LanguageType }
		): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key, value_type in keys do
				if type(a[key]) == value_type then
					fail(a, `type of value at key [{fmt_repr(key)}] == "{value_type}"`, keys)
				end
			end

			return self
		end,

		to_only_have_keys = function(self: Self<Indexable>, target_keys: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key in a do
				if table.find(target_keys, key) == nil then
					fail(a, `contained disallowed key [{fmt_repr(key)}]`, target_keys)
				end
			end

			return self
		end,
		to_never_only_have_keys = function(self: Self<Indexable>, target_keys: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key in a do
				if table.find(target_keys, key) == nil then
					return self
				end
			end

			fail(a, `contained only disallowed keys: {fmt_repr(target_keys)}`, target_keys)

			return self -- pointless but the error is annoying
		end,

		to_have_value = function(self: Self<Indexable>, value: any): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			if table.find(a, value) == nil then
				fail(a, `does not have a {fmt_repr(value)}`, value)
			end

			return self
		end,
		to_never_have_value = function(self: Self<Indexable>, value: any): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			if table.find(a, value) ~= nil then
				fail(a, `does have a {fmt_repr(value)}`, value)
			end

			return self
		end,

		to_have_values = function(self: Self<Indexable>, target_values: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, value in target_values do
				if table.find(a, value) == nil then
					fail(a, `does not have a {fmt_repr(value)}`, target_values)
				end
			end

			return self
		end,
		to_never_have_values = function(self: Self<Indexable>, target_values: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, value in target_values do
				if table.find(a, value) ~= nil then
					fail(a, `does have a {fmt_repr(value)}`, target_values)
				end
			end

			return self
		end,

		to_only_have_values = function(self: Self<Indexable>, target_values: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, value in a do
				if table.find(target_values, value) == nil then
					fail(a, `contained disallowed value {fmt_repr(value)}`, target_values)
				end
			end

			return self
		end,
		to_never_only_have_values = function(self: Self<Indexable>, target_values: { any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for _, value in a do
				if table.find(target_values, value) == nil then
					return self
				end
			end

			fail(a, `contained only disallowed values: {fmt_repr(target_values)}`, target_values)

			return self
		end,

		to_have_pairs = function(self: Self<Indexable>, target_pairs: { [any]: any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key, value in target_pairs do
				if a[key] ~= value then
					fail(a, `value at key [{fmt_repr(key)}] ~= {value}`, target_pairs)
				end
			end

			return self
		end,
		to_never_have_pairs = function(self: Self<Indexable>, target_pairs: { [any]: any }): Self<Indexable>
			const a = self.v

			assert_usage(check_indexable(a), ERR_INDEXABLE_TYPE)

			for key, value in target_pairs do
				if a[key] == value then
					fail(a, `value at key [{fmt_repr(key)}] == {fmt_repr(value)}`, target_pairs)
				end
			end

			return self
		end,

		to_be_empty = function(self: Self<Indexable>): Self<Indexable>
			const a = self.v

			if next(a) ~= nil then
				fail(a, "is not empty")
			end

			return self
		end,
		to_never_be_empty = function(self: Self<Indexable>)
			const a = self.v

			if next(a) == nil then
				fail(a, "is empty")
			end

			return self
		end,

		-- callable assertions
		to_throw = function<A...>(self: Self<Callable<A...>>, ...: A...): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const ok = pcall(fn, ...)

			if ok then
				fail(fn, "did not fail")
			end

			return self
		end,
		to_never_throw = function<A...>(self: Self<Callable<A...>>, ...: A...): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const ok = pcall(fn, ...)

			if not ok then
				fail(fn, "did fail")
			end

			return self
		end,

		to_throw_matching = function<A...>(
			self: Self<Callable<A...>>,
			message: string,
			...: A...
		): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const ok, err: string = pcall(fn, ...)

			if ok then
				fail(fn, "did not fail", fmt_repr(message), ...)
			end

			if not err:lower():match(message:lower()) then
				fail(fn, `failed with {fmt_repr(err)}`, message, ...)
			end

			return self
		end,
		to_never_throw_matching = function<A...>(
			self: Self<Callable<A...>>,
			message: string,
			...: A...
		): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const ok, err: string = pcall(fn, ...)

			if not ok and err:lower():match(message:lower()) then
				fail(fn, `failed with {fmt_repr(err)}`, message, ...)
			end

			return self
		end,

		to_evaluate_to = function<A...>(
			self: Self<Callable<A...>>,
			target_value: unknown,
			...: A...
		): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const result = fn(...)

			if not deep_equality(result, target_value) then
				fail(fn, `did not evaluate to {fmt_repr(target_value)}`, target_value, ...)
			end

			return self
		end,
		to_never_evaluate_to = function<A...>(
			self: Self<Callable<A...>>,
			target_value: unknown,
			...: A...
		): Self<Callable<A...>>
			const fn = self.v

			assert_usage(check_callable(fn), ERR_CALLABLE_TYPE)

			const result = fn(...)

			if deep_equality(result, target_value) then
				fail(fn, `evaluated to {fmt_repr(target_value)}`, target_value, ...)
			end

			return self
		end,
	}),
})

const function expect(value: any): ExpectTests
	return setmetatable({ v = value }, CLASS_METATABLE) :: any
end

return expect
