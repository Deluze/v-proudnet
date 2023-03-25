module proud

enum ErrorType {
	ok
	unexpected
	already_connected
	tcp_connect_failure
	invalid_session_key
	encrypt_fail
	decrypt_fail
	connect_server_timeout
	protocol_version_mismatch
	invalid_license
	notify_server_denied_connection
	reserved_01
	disconnect_from_remote
	disconnect_from_local
	reserved_02
	unknown_addr_port
	reserved_03
	server_port_listen_failure
	already_exists
	permission_denied
	bad_session_guid
	invalid_credential
	invalid_hero_name
	reserved_06
	reserved_07
	reserved_08
	unit_test_failed
	p2p_udp_failed
	reliable_udp_failed
	server_udp_failed
	no_p2p_group_relation
	exception_from_user_function
	user_requested
	invalid_packet_format
	too_large_message_detected
	reserved_09
	value_not_exist
	time_out
	loaded_data_not_found
	send_queue_is_heavy
	too_slow_heartbeat_warning
	compress_fail
	local_socket_creation_failed
	none_available_in_port_pool
	invalid_host_id
	message_overload
	database_access_failed
	out_of_memory
	auto_connection_recovery_failed
	not_implemented_rmi
}

pub enum HostID as u32 {
	@none
	server
	last
}

enum RmiID as u16 {
	@none
	last = u16(65535)
}

enum LogCategory {
	system
	tcp
	udp
	p2p
}

fn log_category_to_string(cat LogCategory) string {
	return match cat {
		.system { 'System' }
		.tcp { 'TCP' }
		.udp { 'UDP' }
		.p2p { 'P2P' }
	}
}

enum HackType {
	@none
	speed_hack
	packet_rig
}

enum ConnectionState {
	disconnected
	connecting
	connected
	disconnecting
}

pub fn connection_state_to_string(state ConnectionState) string {
	return match state {
		.disconnected { 'Disconnected' }
		.connecting { 'Connecting' }
		.connected { 'Connected' }
		.disconnecting { 'Disconnecting' }
	}
}

enum FallbackMethod {
	@none
	peers_udp_to_tcp
	server_udp_to_tcp
	close_udp_socket
}

enum DirectP2PStartCondition {
	jit
	always
	last
}

enum ErrorReaction {
	message_box
	access_violation
	debug_output
	debug_break
}

enum ValueOperationType {
	plus
	minus
	multiply
	division
}

enum ValueCompareType {
	greater_equal
	greater
	less_equal
	less
	equal
	not_equal
}

enum EncryptLevel {
	low = 128
	middle = 192
	high = 256
}

enum FastEncryptLevel {
	low = 512
	middle = 1024
	high = 2048
}

enum HostType {
	server
	peer
	all
}

enum HostIDGenerationPolicy {
	recycle
	no_recycle
}

enum ThreadModel {
	single_threaded
	multi_threaded
	use_external_thread_pool
}