export type NumberTypeSpec = {
	read write: (b: buffer, offset: number, value: number) -> (),
	read read: (b: buffer, offset: number) -> number,
	read size: number,
	read min: number,
	read max: number,
}

export type Schema<T... = ...any> = {
	read write: (b: buffer, offset: number, T...) -> number,
	read read: (b: buffer, offset: number) -> (number, T...),
	read alloc_size: (T...) -> number,
	read validate: (...any) -> (boolean, string?),
}

export type UnresolvedSchema = (self: Schema) -> Schema

return nil
