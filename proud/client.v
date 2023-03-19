module proud

import net

pub struct TcpClient {
pub mut:
	connection &net.TcpConn
	error_state bool
}

[inline]
pub fn create_tcp_client(mut connection &net.TcpConn) TcpClient {
	return TcpClient{
		connection: connection
	}
}

pub fn (mut client TcpClient) send_packet(packet ServerPacket) ! {
	client.connection.write(packet.buffer)!
}

pub fn (mut client TcpClient) send_message(mut message CMessage) {
	if client.error_state {
		return
	}

	mut byte_array := message.get_buffer()
	buffer := byte_array.data()

	client.connection.write(buffer) or {
		panic(err)
	}
}