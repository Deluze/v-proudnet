module main
import proud

fn main() {
	random := proud.guid_random()
	with_brackets := proud.guid_to_bracket_string(random)

	println(random)
	println(with_brackets)
	println(proud.guid_bracket_string_to_guid(with_brackets))
}
