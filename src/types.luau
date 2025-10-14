export type UIntFormat = "u8" | "u16" | "u32"
export type IntFormat = "i8" | "i16" | "i32"
export type FloatFormat = "f16" | "f32" | "f64"

-- custom byte formats
export type SmallFormat = "s8" | "s16" | "s32"
export type RadianFormat = "r8" | "r16" | "r32"
export type NoneFormat = "none"

export type NumberFormat =
	UIntFormat
	| IntFormat
	| FloatFormat
	| SmallFormat
	| RadianFormat
	| NoneFormat

export type NumberFormatSpec = {
	read write: (b: buffer, offset: number, value: number) -> (),
	read read: (b: buffer, offset: number) -> number,

	read size: number,

	read min: number,
	read max: number,
}

export type Schema<T...> = {
	read name: string,

	read serialize: (self: Schema<T...>, T...) -> buffer,
	read deserialize: (self: Schema<T...>, serialized: buffer) -> T...,

	read write: (b: buffer, offset: number, T...) -> (),
	read read: (b: buffer, offset: number) -> T...,
	read size: (...unknown) -> number,
	read validate: (...unknown) -> boolean,
}

return nil
