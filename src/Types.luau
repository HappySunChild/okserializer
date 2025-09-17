export type UIntByteFormat = "u8" | "u16" | "u32"
export type IntByteFormat = "i8" | "i16" | "i32"
export type FloatByteFormat = "f16" | "f32" | "f64"

-- custom byte formats
export type SmallByteFormat = "s8" | "s16" | "s32"
export type RadianByteFormat = "r8" | "r16" | "r32"

export type NumberByteFormat = UIntByteFormat | IntByteFormat | FloatByteFormat | SmallByteFormat | RadianByteFormat
export type ByteFormatInfo = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
}

export type Schema<T> = {
	name: string,

	serialize: (self: Schema<T>, value: T) -> (string, buffer),
	deserialize: (self: Schema<T>, serialized: string) -> T,
	validate: (self: Schema<T>, value: T) -> boolean,
}

return nil
