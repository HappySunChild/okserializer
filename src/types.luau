export type UIntFormat = "u8" | "u16" | "u32"
export type IntFormat = "i8" | "i16" | "i32"
export type FloatFormat = "f16" | "f32" | "f64"

-- custom byte formats
export type SmallFormat = "s8" | "s16" | "s32"
export type RadianFormat = "r8" | "r16" | "r32"

export type NumberFormat =
	UIntFormat
	| IntFormat
	| FloatFormat
	| SmallFormat
	| RadianFormat

export type NumberFormatSpec = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
}

export type Schema<T...> = {
	name: string,

	serialize: (self: Schema<T...>, T...) -> buffer,
	deserialize: (self: Schema<T...>, serialized: buffer) -> T...,
	validate: (self: Schema<T...>, ...unknown) -> boolean,

	_write: (b: buffer, offset: number, T...) -> (),
	_read: (b: buffer, offset: number) -> T...,
	_size: (T...) -> number,
	_validate: (...unknown) -> boolean,
}

return nil
