module proud

import net

struct NamedAddrPort {
pub:
	addr string
	port u16
}

struct AddrPort {
pub:
	addr u32
	port u16
}

pub fn addr_port_from_ip_port_v4(ip_address string, port u16) AddrPort {
	segments := ip_address.split('.')

	assert segments.len == 4

	mut addr_u32 := u32(0)
	for segment in segments {
		addr_u32 *= 256
		addr_u32 += segment.u8()
	}

	return AddrPort{
		addr: addr_u32,
		port: port
	}
}

pub fn addr_port_from_ip_port_v6(ip_address string, port u16) AddrPort {
	return AddrPort{}
}

pub fn addr_port_from_ip_port(af u32, ip_address string, port u16) AddrPort {
	return AddrPort{}
}

pub fn addr_port_from_hostname_port(hostname string, port u16) !AddrPort {
	return error('not implemented')
}

pub fn addr_port_from_named_addr_port(src NamedAddrPort) AddrPort {
	return AddrPort{}
}

pub fn (a AddrPort) equals(rhs AddrPort) bool {
	return a.port == rhs.port && a.addr == rhs.port
}

pub fn (a AddrPort) str() string {
	return a.addr.str()
}


pub fn named_addr_port_from_addr_port(addr string, port u16) NamedAddrPort {
	return NamedAddrPort{
		addr: addr
		port: port
	}
}

pub fn named_addr_port_from(src AddrPort) NamedAddrPort {
	return NamedAddrPort{
		addr: '127.0.0.1'
		port: src.port
	}
}

pub fn (a NamedAddrPort) equals(rhs NamedAddrPort) bool {
	return a.port == rhs.port && a.addr == rhs.addr
}

pub fn (a NamedAddrPort) str() string {
	return '${a.addr}:${a.port}'
}