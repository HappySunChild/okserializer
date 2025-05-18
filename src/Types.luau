export type UIntByteFormat = "u8" | "u16" | "u32"
export type IntByteFormat = "i8" | "i16" | "i32"
export type FloatByteFormat = "f16" | "f32" | "f64"

-- custom byte formats
export type SmallByteFormat = "s8" | "s16" | "s32"
export type RadianByteFormat = "r8" | "r16" | "r32"

export type NumberByteFormat = UIntByteFormat | IntByteFormat | FloatByteFormat | SmallByteFormat | RadianByteFormat

export type Schema<V> = {
	Name: string,

	Serialize: (self: Schema<V>, value: V) -> (string, buffer),
	Deserialize: (self: Schema<V>, serialized: string) -> V,
	Validate: (self: Schema<V>, value: V) -> boolean,

	_write: (b: buffer, offset: number, value: V) -> (),
	_read: (b: buffer, offset: number) -> V,
	_size: (value: V) -> number,
	_validate: (value: V) -> boolean,
}

export type ByteFormatInfo = {
	write: (b: buffer, offset: number, value: number) -> (),
	read: (b: buffer, offset: number) -> number,
	size: number,
}

return nil
