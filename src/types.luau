export type NumberEncoding = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
	min: number,
	max: number,
}

type StaticallySized = { static_size: number }
type DynamicallySized<T...> = { dyn_size: (T...) -> number }

--- An object that can read and write a value from or to a buffer.
export type Schema<T... = ...any> = {
	write: (b: buffer, offset: number, T...) -> number,
	read: (b: buffer, offset: number) -> (number, T...),
	validate: (...any) -> (boolean, string?),
}
--- A schema that's dynamically sized.
export type DynSchema<T... = ...any> = Schema<T...> & DynamicallySized<T...>
--- A schema that's statically sized.
export type StaticSchema<T... = ...any> = Schema<T...> & StaticallySized
--- A schema that's either dynamically or statically sized.
export type SizedSchema<T... = ...any> = Schema<T...> & StaticallySized & DynamicallySized<T...>

export type UnresolvedSchema = (self: SizedSchema) -> DynSchema

return nil
