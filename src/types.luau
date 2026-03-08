export type NumberTypeSpec = {
	read write: (b: buffer, offset: number, value: number) -> (),
	read read: (b: buffer, offset: number) -> number,
	read size: number,
	read min: number,
	read max: number,
}

export type Schema<T...> = {
	read write: (b: buffer, offset: number, T...) -> (),
	read read: (b: buffer, offset: number) -> T...,
	read size: (T...) -> number,
	read validate: (T...) -> boolean,
}

return nil
