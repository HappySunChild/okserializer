export type NumberEncoding = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
	min: number,
	max: number,
}

export type Schema<T... = ...any> = {
	write: (b: buffer, offset: number, T...) -> number,
	read: (b: buffer, offset: number) -> (number, T...),
	validate: (...any) -> (boolean, string?),

	dyn_size: ((T...) -> number)?,
	static_size: number?,
}

export type UnresolvedSchema = (self: Schema) -> Schema

return nil
