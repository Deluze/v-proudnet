module proud

import encoding.hex

pub struct ByteArray {
	CFastArray[u8]
mut:
	null     bool = true
	internal bool = true
}

[inline]
pub fn new_byte_array() ByteArray {
	return ByteArray{
		data: []u8{cap: 0}
	}
}

pub fn new_byte_array_from_data(data []u8) ByteArray {
	return ByteArray{
		data: data
		internal: true
		null: false
	}
}

[inline]
pub fn new_byte_array_from_data_copy(data []u8) ByteArray {
	return ByteArray{
		data: data.clone()
		internal: true
		null: false
	}
}

pub fn (mut array ByteArray) use_external_buffer(external_buffer []u8) ! {
	if !array.null {
		return error('ByteArray must not be initialized')
	}

	array.data = external_buffer
	array.null = false
	array.internal = false
}

pub fn (mut array ByteArray) use_internal_buffer() ! {
	if !array.null {
		return error('ByteArray must not be initialized')
	}

	array.CFastArray.data = []u8{cap: array.CFastArray.get_recommended_capacity(1024)}
	array.null = false
	array.internal = true
}

pub fn (array ByteArray) must_not_null() ! {
	if array.null {
		return error('ByteArray must not be null')
	}
}

pub fn (array ByteArray) must_null() ! {
	if !array.null {
		return error('ByteArray must be null')
	}
}

pub fn (mut array ByteArray) is_null() bool {
	return array.null
}

pub fn (mut array ByteArray) must_internal_buffer() ! {
	if !array.internal {
		return error('ByteArray does not use internal buffer')
	}
}

pub fn (mut array ByteArray) un_init_buffer() {
	array.CFastArray.clear()

	array.null = true
	array.internal = true
}

pub fn (mut array ByteArray) to_hex_string() string {
	return hex.encode(array.CFastArray.data)
}

pub fn (mut array ByteArray) from_hex_string(value string) bool {
	buffer := hex.decode(value) or {
		return false
	}

	if !array.is_null() {
		array.un_init_buffer()
	}

	array.use_internal_buffer() or {
		panic(err)
	}

	array.CFastArray.add_range(buffer.data, buffer.len)

	return true
}
