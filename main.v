module main
import proud

fn main() {
	addr_port := proud.addr_port_from_ip_port_v4('127.0.0.1', 8080)
	println(addr_port)
}
