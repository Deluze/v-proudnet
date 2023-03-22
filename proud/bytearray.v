module proud


pub struct ByteArray {
	CFastArray[u8]
mut:
	null bool = true
	internal bool
}

[inline]
pub fn new_byte_array() ByteArray {
	return ByteArray{}
}

pub fn new_byte_array_from_data(data []u8) ByteArray {
	return ByteArray{
		data: data,
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

	buffer_size := match array.grow_policy {
		.normal { 1028 }
		.high_speed { 4096 }
		.low_memory { 0 }
	}

	array.data = []u8{len: buffer_size}
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
	return ''
}