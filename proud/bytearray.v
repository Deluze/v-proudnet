module proud


pub struct ByteArray {
	CFastArray[u8]
mut:
	buffer []u8 = []
	null bool = true
	internal bool
}

[inline]
pub fn new_byte_array() ByteArray {
	return ByteArray{}
}

pub fn new_byte_array_from_data(data []u8) ByteArray {
	return ByteArray{
		buffer: data
		internal: true
		null: false
	}
}

[inline]
pub fn new_byte_array_from_data_copy(data []u8) ByteArray {
	return ByteArray{
		buffer: data.clone()
		internal: true
		null: false
	}
}

[inline]
pub fn new_byte_array_copy_from(mut array &ByteArray) ByteArray {
	return array.clone()
}

pub fn (mut lhs ByteArray) equals (mut rhs &ByteArray) bool {
	if lhs.get_count() != rhs.get_count() {
		return false
	}

	result := false
	unsafe {
		result = vmemcmp(lhs.data().data, rhs.data().data, rhs.get_count()) == 0
	}
	return result
}

pub fn (mut array ByteArray) use_external_buffer(external_buffer []u8) ! {
	if !array.null {
		return error('ByteArray must not be initialized')
	}

	array.buffer = external_buffer
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

	array.buffer = []u8{len: buffer_size}
	array.null = false
	array.internal = true
}

pub fn (mut array ByteArray) capacity() int {
	return array.buffer.cap
}

pub fn (array ByteArray) get_count() int {
	return array.buffer.len
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

pub fn (mut array ByteArray) set_capacity(length int) {
	if !array.internal {
		panic('ByteArray can not change capacity as buffer is not internal')
	}

	if length > array.buffer.cap {
		array.buffer.grow_cap(length - array.buffer.cap)

		return
	}

	mut new_buffer := []u8{len: length}
	copy(mut new_buffer, array.buffer)
	array.buffer = new_buffer
}

pub fn (mut array ByteArray) set_min_capacity(length int) {
	if array.buffer.cap < length {
		array.set_capacity(length)
	}
}

pub fn (mut array ByteArray) set_count(length int) {
	diff := length - array.buffer.len
	unsafe {
		array.buffer.grow_len(diff)
	}
}

pub fn (mut array ByteArray) add_count(length int) {
	array.set_count(array.buffer.len + length)
}

pub fn (mut array ByteArray) add(data u8) {
	array.buffer << data
}

pub fn (mut array ByteArray) add_range(data []u8) {
	array.buffer << data
}

pub fn (mut array ByteArray) insert_range(indexAt int, data voidptr, count int) {
	mut ptr := &u8(array.buffer.data)
	unsafe {
		ptr += indexAt
		vmemcpy(ptr, data, count)
	}
}

pub fn (mut array ByteArray) remove_range(indexAt int, count int) {
	array.buffer.delete_many(indexAt, count)
}

pub fn (mut array ByteArray) remove_at(index int) {
	array.buffer.delete(index)
}

pub fn (mut array ByteArray) clear() {
	array.set_count(0)
}

pub fn (mut array ByteArray) data() []u8 {
	return array.buffer
}

[inline]
pub fn (mut array ByteArray) clone() ByteArray {
	mut ret := new_byte_array()

	ret.use_internal_buffer() or { panic(err) }
	ret.set_count(array.get_count())

	array.copy_range_to(mut ret, 0, array.get_count())

	return ret
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
	array.buffer = []
	array.null = true
	array.internal = true
}

pub fn (mut array ByteArray) get_value_at_index(index int) u8 {
	return array.buffer[index]
}

pub fn (mut array ByteArray) copy_range_to(mut dest ByteArray, srcOffset int, count int) {
	mut ptr := &u8(array.buffer.data)
	unsafe {
		ptr += srcOffset
		vmemcpy(dest.buffer.data, ptr, count)
	}
}

