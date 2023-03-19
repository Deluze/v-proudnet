module main

import net
import proud

fn main() {
	incoming_conns := chan &net.TcpConn{cap: 100}

	mut server_main := proud.create_tcp_server(23111)

	spawn server_main.listen(incoming_conns)

	for {
		server_main.check_incoming_connections(incoming_conns)!
		server_main.check_incoming_packets()
	}
}
