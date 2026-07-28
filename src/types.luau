export type NumberEncoding = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
	min: number,
	max: number,
}

type StaticallySized = { static_size: number }
type DynamicallySized<T...> = { dyn_size: (T...) -> number }

--- A callback function that writes values to a buffer.
export type write<T... = ...any> = (b: buffer, offset: number, T...) -> number
--- A callback function that reads values from a buffer.
export type read<T... = ...any> = (b: buffer, offset: number) -> (number, T...)
--- A callback function that returns whether the given values are valid for a specific schema.
export type validate = (...any) -> (boolean, string?)

--- An object that can read and write a value from or to a buffer.
export type Schema<T... = ...any> = {
	write: write<T...>,
	read: read<T...>,
	validate: validate,
}
--- A schema that's dynamically sized.
export type DynSchema<T... = ...any> = Schema<T...> & DynamicallySized<T...>
--- A schema that's statically sized.
export type StaticSchema<T... = ...any> = Schema<T...> & StaticallySized
--- A schema that's either dynamically or statically sized.
export type SizedSchema<T... = ...any> = Schema<T...> & StaticallySized & DynamicallySized<T...>

export type UnresolvedSchema = (self: SizedSchema) -> DynSchema

return nil
