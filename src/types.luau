export type NumberEncoding = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
	min: number,
	max: number,
}

--- An object that can read and write a value from or to a buffer.
export type Schema<T... = ...any> = {
	write: (b: buffer, offset: number, T...) -> number,
	read: (b: buffer, offset: number) -> (number, T...),
	validate: (...any) -> (boolean, string?),
}
--- A schema that's dynamically sized.
export type DynSchema<T... = ...any> = Schema<T...> & { dyn_size: (T...) -> number }
--- A schema that's statically sized.
export type StaticSchema<T... = ...any> = Schema<T...> & { static_size: number }
--- A schema that's either dynamically or statically sized.
export type SizedSchema<T... = ...any> = DynSchema<T...> & StaticSchema<T...>

export type Unresolved<T> = (self: Schema) -> T
export type Resolvable<T> = T | Unresolved<T>

return nil
