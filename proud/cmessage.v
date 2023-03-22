module proud

struct CMessage {
mut:
	buffer             ByteArray [required]
	simple_packet_mode bool
	// if true, read/write scalar is disabled and u64 is always used. Simplified packet structure, less efficient.
	read_offset        int
	write_offset       int
	bit_alignment      u8
}

pub fn new_message() CMessage {
	mut buffer := new_byte_array()
	buffer.use_internal_buffer() or { panic(err) }

	return CMessage{
		buffer: buffer
	}
}

pub fn (mut message CMessage) is_simple_packet_mode() bool {
	return message.simple_packet_mode
}

pub fn (mut message CMessage) set_simple_packet_mode(state bool) {
	message.simple_packet_mode = state
}

pub fn (mut message CMessage) get_buffer() ByteArray {
	return message.buffer
}

pub fn (mut message CMessage) can_read(count int) bool {
	return count + message.read_offset < message.get_length()
}

pub fn (mut message CMessage) read(mut data []u8, count int) bool {
	if !message.can_read(count) {
		return false
	}

	ptr := &u8(message.buffer.CFastArray.get_data().data)
	unsafe {
		ptr += message.read_offset
		vmemcpy(data.data, ptr, count)
	}
	return true
}

pub fn (mut message CMessage) write(data voidptr, count int) {
	if count == 0 {
		return
	}

	message.adjust_write_offset_byte_align()

	mut buffer := message.get_buffer()
	buffer.CFastArray.set_min_capacity(message.write_offset + count)
	buffer.CFastArray.insert_range(message.write_offset, data, count)

	message.write_offset += count
}

pub fn (mut message CMessage) copy_from_array_and_reset_read_offset(data []u8, count int) {
	mut new_buffer := []u8{len: count}
	copy(mut new_buffer, data)

	message.buffer = new_byte_array_from_data_copy(new_buffer)
	message.read_offset = 0
}

pub fn (mut message CMessage) set_read_offset(offset int) {
	message.read_offset = offset
}

pub fn (mut message CMessage) set_length(count int) {
	mut buffer := message.get_buffer()
	buffer.CFastArray.set_count(count)
}

pub fn (mut message CMessage) get_write_offset() int {
	return message.write_offset
}

pub fn (mut message CMessage) adjust_write_offset_byte_align() {
	if message.bit_alignment > 0 {
		message.write_offset++
	}

	message.bit_alignment = 0
}

pub fn (mut message CMessage) read_with_share_buffer(output &CMessage, length int) {
	// todo: ?
}

pub fn (mut message CMessage) write_array_t[T](array []T) {
	length := u32(array.len * sizeof(T))

	message.write_scalar(length)
	for x in array {
		message.write_t(&x, sizeof(T))
	}
}

/*
Scalars:
		Usually used to fit an unknown length. e.g. array.
		Write the size of the data type to hold the length in bytes in 1 byte. e.g. u32 -> 4, u64-> 8.
		Then, write the value using 1,2,4 or 8 bytes.

		If simple packet mode is enabled, always write the value using 8 bytes.
*/
pub fn (mut message CMessage) write_scalar[T](scalar T) {
	if message.is_simple_packet_mode() {
		message.write_u8(8)
		message.write_u64(scalar)

		return
	}

	size_in_bytes := u8(sizeof(scalar))
	message.write_u8(size_in_bytes)
	message.write_t(scalar)
}

pub fn (mut message CMessage) write_t[T](data T) {
	message.write(&data, int(sizeof(T)))
}

pub fn (mut message CMessage) write_flag(flag bool) {
	message.write(&flag, 1)
}

pub fn (mut message CMessage) write_u8(data u8) {
	message.write(&data, 1)
}

pub fn (mut message CMessage) write_i8(data i8) {
	message.write(&data, 1)
}

pub fn (mut message CMessage) write_u16(data u16) {
	message.write(&data, 2)
}

pub fn (mut message CMessage) write_i16(data i16) {
	message.write(&data, 2)
}

pub fn (mut message CMessage) write_u32(data u32) {
	message.write(&data, 4)
}

pub fn (mut message CMessage) write_i32(data i32) {
	message.write(&data, 4)
}

pub fn (mut message CMessage) write_u64(data u64) {
	message.write(&data, 8)
}

pub fn (mut message CMessage) write_i64(data i64) {
	message.write(&data, 8)
}

fn (mut message CMessage) read_to_ptr(dst voidptr, count int) {
	if !message.can_read(count) {
		panic('Count too big')
	}

	mut ptr := &u8(message.buffer.CFastArray.data.data)
	unsafe {
		ptr += message.read_offset
		vmemcpy(dst, ptr, count)
	}
	message.read_offset += count
}

pub fn (mut message CMessage) read_t[T]() T {
	data := T(0)

	message.read_to_ptr(&data, int(sizeof(T)))

	return data
}

pub fn (mut message CMessage) read_u8() u8 {
	return message.read_t[u8]()
}

pub fn (mut message CMessage) read_i8() i8 {
	return message.read_t[i8]()
}

pub fn (mut message CMessage) read_u16() u16 {
	return message.read_t[u16]()
}

pub fn (mut message CMessage) read_i16() i16 {
	return message.read_t[i16]()
}

pub fn (mut message CMessage) read_u32() u32 {
	return message.read_t[u32]()
}

pub fn (mut message CMessage) read_i32() i32 {
	return message.read_t[i32]()
}

pub fn (mut message CMessage) read_u64() u64 {
	return message.read_t[u64]()
}

pub fn (mut message CMessage) read_i64() i64 {
	return message.read_t[i64]()
}

pub fn (mut message CMessage) read_scalar() u64 {
	size_in_bytes := message.read_u8()

	if message.is_simple_packet_mode() {
		return message.read_u64()
	}

	data := u64(0)
	message.read_to_ptr(&data, size_in_bytes)
	return data
}

pub fn (mut message CMessage) read_array_t[T]() []T {
	length := int(message.read_scalar())

	if !message.can_read(length) {
		return []
	}

	array := []T{len: length}
	message.read_to_ptr(array.data, int(sizeof(T)) * length)

	return array
}

pub fn (mut message CMessage) write_byte_array(mut array ByteArray) {
	// message.write(array.data().data, array.get_count())
}

pub fn (mut message CMessage) read_byte_array() ByteArray {
	array := message.read_array_t[u8]()
	return new_byte_array_from_data(array)
}

pub fn (mut message CMessage) get_length() int {
	return 0
	// return message.get_buffer().get_count()
}
