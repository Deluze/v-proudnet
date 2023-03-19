module proud

import net

pub struct TcpServer {
pub:
	port u16 [required]
mut:
	clients []TcpClient = []
}

[inline]
pub fn create_tcp_server(port u16) TcpServer {
	return TcpServer{
		port: port,
	}
}

pub fn (server TcpServer) listen(incoming_conns chan &net.TcpConn) ! {
	mut listener := net.listen_tcp(net.AddrFamily.ip, ':${server.port}')!

	for {
		mut conn := listener.accept() or {
			break
		}

		incoming_conns <- conn
	}
}

pub fn (mut server TcpServer) check_incoming_connections(connection_ch chan &net.TcpConn) ! {
	len := connection_ch.len

	for _ in 0 .. len {
		mut conn := <-connection_ch
		server.add_connection(mut conn)
	}
}

pub fn (mut server TcpServer) check_incoming_packets() {

	for i := 0; i < server.clients.len; {
		mut client := &server.clients[i]

		for {
			success := server.process_packet(mut client)

			if !success {
				break
			}
		}

		if client.error_state {
			server.clients.delete(i)

			continue
		}

		i++
	}
}

pub fn (server TcpServer) process_packet(mut client TcpClient) bool {
	if client.error_state {
		return false
	}

	mut buffer := []u8{len: 1028}
	bytes := client.connection.read(mut buffer) or {
		// todo: client disconnect
		client.error_state = true

		return false
	}

	if bytes == 0 {
		return false
	}

	println('Received packet:')
	println(buffer.hex())

	return true
}

fn (mut server TcpServer) add_connection(mut connection &net.TcpConn) {
	mut client := create_tcp_client(mut connection)
	client.connection.set_blocking(false) or {
		panic(err)
	}
	server.clients << client

	write_handshake(mut client)
}

fn write_handshake (mut client TcpClient) {
	mut message := new_message()

	// HEADER
	message.write_u16(2) // nothing
	message.write_scalar(u8(1)) // ?
	message.write_u16(0x5713) // magic
	message.write_scalar(u16(0)) // payload size
	// PAYLOAD:


	client.send_message(mut message)
}