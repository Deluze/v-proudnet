module proud

struct Packet {
mut:
	offset int
	buffer []u8 [required]
}

pub fn (packet Packet) buffer() []u8 {
	return packet.buffer
}

pub struct ServerPacket {
	Packet
}

pub struct ClientPacket {
	Packet
}

pub fn create_server_packet() ServerPacket {
	buff := []u8{len: 4098, init: 0}
	return ServerPacket{
		buffer: buff
	}
}

pub fn create_client_packet(buff []u8) ClientPacket {
	return ClientPacket{
		buffer: buff
	}
}

pub fn (packet ClientPacket) opcode() u32 {
	return 1337
}

pub fn (mut packet ServerPacket) shrink() {
	mut new_cap := 0
	if packet.offset > 0 {
		new_cap = packet.offset
	}

	mut new_buffer := []u8{len: new_cap}
	copy(mut new_buffer, packet.buffer)
	packet.buffer = new_buffer
}

pub fn (mut packet ServerPacket) write_u8(val u8) {
	packet.write_copy(&val, 1)
}

pub fn (mut packet ServerPacket) write_u16(val u16) {
	packet.write_copy(&val, 2)
}

pub fn (mut packet ServerPacket) write_u32(val u32) {
	packet.write_copy(&val, 4)
}

pub fn (mut packet ServerPacket) write_string(val string) {
	packet.write_copy(&val, val.len_utf8())
}

pub fn (mut packet ServerPacket) write_empty(size int) {
	packet.reserve(size)

	mut ptr := &u8(packet.buffer.data)
	unsafe {
		ptr += packet.offset
		vmemset(ptr, 0, size)
	}

	packet.offset += size
}

fn (mut packet ServerPacket) reserve(space int) {
	if packet.offset + space >= packet.buffer.len {
		to_grow := packet.offset + space - packet.buffer.len

		packet.buffer.grow_cap(to_grow)
	}
}

fn (mut packet ServerPacket) write_copy(val voidptr, size int) {
	packet.reserve(size)

	mut ptr := &u8(packet.buffer.data)
	unsafe {
		ptr += packet.offset
		vmemcpy(ptr, val, size)
	}

	packet.offset += size
}
