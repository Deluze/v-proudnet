module main
import proud

fn main() {
	mut bytes := proud.new_byte_array()
	bytes.from_hex_string('000102030405')
	println(bytes.CFastArray.get_data())
}
