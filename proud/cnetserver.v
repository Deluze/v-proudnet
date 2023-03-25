module proud

struct CThreadInfo {

}

enum CP2PGroupOption {
	default
}

struct NetServerEvent {

}

struct CP2PGroup {

}

struct CP2PGroupInfo {

}

struct CNetServerStats {

}

struct ServerUdpAssignMode {

}

struct CNetServerParameter {
	server_addr_at_client string
	local_nic_addr string
	tcp_ports CFastArray[int]
	udp_ports CFastArray[int]
	udp_assign_mode ServerUdpAssignMode
	protocol_version GuidWithBrackets
	thread_count int
	net_worker_thread_count int
	encrypted_key_message_key_length EncryptLevel
	fast_encrypted_key_message_key_length FastEncryptLevel
	enable_p2p_encrypted_messaging bool
	allow_server_as_p2p_group_member bool
	enable_iocp bool
	upnp_detect_nat_device bool
	upnp_tcp_addr_port_mapping bool
	using_over_block_icmp_environment bool
	timer_callback_interval_ms u32
	timer_callback_parallel_max_count i32
	timer_callback_context voidptr
	enable_nagle_algorithm bool
	host_id_generation_policy HostIDGenerationPolicy
	client_emergency_log_max_line_count u32
	pre_create_p2p_group_start_host_id HostID
	pre_create_p2p_group_count int
	pre_create_p2p_group_option CP2PGroupOption
	enable_ping_test bool
	ignore_failed_bind_port bool
	failed_bind_ports CFastArray[int]
	external_user_worker_thread_pool voidptr
	external_net_worker_thread_pool voidptr
}

struct CNetServer {
	CoreEventFunctions
}

pub fn (mut s CNetServer) start(param CNetServerParameter) ! {
	return error('not implemented')
}

pub fn (mut s CNetServer) stop() {

}

pub fn (mut s CNetServer) allow_empty_p2p_groups(enable bool) {

}

pub fn (mut s CNetServer) get_remote_identifiable_local_addrs() []NamedAddrPort {
	return []
}

pub fn (mut s CNetServer) get_tcp_listener_local_addrs() []AddrPort {
	return []
}

pub fn (mut s CNetServer) get_udp_listener_local_addrs() []AddrPort {
	return []
}

pub fn (mut s CNetServer) set_default_timeout_time_ms(ms int) {

}

pub fn (mut s CNetServer) set_timeout_time_ms(ms int) {

}

pub fn (mut s CNetServer) set_default_auto_connection_recovery_timeout_time_ms(ms int) {

}

pub fn (mut s CNetServer) set_auto_connection_recovery_timeout_time_ms(ms int) {

}

pub fn (mut s CNetServer) set_default_fallback_method(default FallbackMethod) {

}

pub fn (mut s CNetServer) enable_log(filename string) {

}

pub fn (mut s CNetServer) disable_log() {

}

pub fn (mut s CNetServer) set_speed_hack_detector_reck_ratio_percent(percent int) {

}

pub fn (mut s CNetServer) enable_speed_hack_detector(enable bool) {

}

pub fn (mut s CNetServer) set_message_max_length(server_message_max_length int, client_message_max_length int) {

}

pub fn (mut s CNetServer) is_nagle_algorithm_enabled() bool {
	return false
}

pub fn (mut s CNetServer) set_max_direct_p2p_connection_count(client_id HostID, max int) {

}

pub fn (mut s CNetServer) set_direct_p2p_start_condition(condition DirectP2PStartCondition) bool {
	return false
}

pub fn (mut s CNetServer) get_most_suitable_super_peer_in_group(group_id HostID, exclude HostID) HostID {
	return HostID.server
}

pub fn (mut s CNetServer) get_udp_socket_addr_list() []AddrPort {
	return []
}

pub fn (mut s CNetServer) get_internal_version() int {
	return 1
}

pub fn (mut s CNetServer) get_p2p_connection_stats(remote_host_id HostID) CP2PConnectionStats {
	return CP2PConnectionStats{}
}

pub fn (mut s CNetServer) get_p2p_pair_connection_stats(remote_host_id HostID) CP2PPairConnectionStats {
	return CP2PPairConnectionStats{}
}

pub fn (mut s CNetServer) get_user_worker_thread_info() []CThreadInfo {
	return []
}

pub fn (mut s CNetServer) get_net_worker_thread_info() []CThreadInfo {
	return []
}

pub fn (mut s CNetServer) send_user_message(remote HostID, context RmiContext, payload []u8) bool {
	return s.send_users_message([remote], context, payload)
}

pub fn (mut s CNetServer) send_users_message(remotes []HostID, context RmiContext, payload []u8) bool {
	return false
}

pub fn (mut s CNetServer) close_connection(id HostID) bool {
	return true
}

pub fn (mut s CNetServer) close_every_connection() {

}

pub fn (mut s CNetServer) create_p2p_group(client_host_ids []HostID) {

}

pub fn (mut s CNetServer) destroy_p2p_group(group_host_id HostID) {

}

pub fn (mut s CNetServer) destroy_empty_p2p_groups() {

}

pub fn (mut s CNetServer) dump_group_status() string {
	return ''
}

pub fn (mut s CNetServer) get_client_count() int {
	return 0
}

pub fn (mut s CNetServer) get_stats() CNetServerStats {
	return CNetServerStats{}
}

pub fn (mut s CNetServer) get_client_host_ids() []HostID {
	return []
}

pub fn (mut s CNetServer) get_last_ping_sec(client_id HostID) !f64 {
	ms := s.get_last_unreliable_ping_ms(client_id)!

	if ms < 0 {
		return f64(ms)
	}

	return f64(ms) / 1000
}

pub fn (mut s CNetServer) get_last_unreliable_ping_ms(client_id HostID) !int {
	return error('0')
}

pub fn (mut s CNetServer) get_recent_ping_sec(client_id HostID) !f64 {
	ms := s.get_recent_unreliable_ping_ms(client_id)!

	if ms < 0 {
		return f64(ms)
	}

	return f64(ms) / 1000
}

pub fn (mut s CNetServer) get_recent_unreliable_ping_ms(client_id HostID) !int {
	return error('0')
}

pub fn (mut s CNetServer) get_p2p_recent_ping_ms(lhs HostID, rhs HostID) int {
	return 0
}

pub fn (mut s CNetServer) get_p2p_group_info(group_host_id HostID) CP2PGroupInfo {
	return CP2PGroupInfo{}
}

pub fn (mut s CNetServer) is_valid_host_id(host_id HostID) bool {
	return false
}

pub fn (mut s CNetServer) get_p2p_groups() []CP2PGroup {
	return []
}

pub fn (mut s CNetServer) get_p2p_group_count() int {
	return 0
}

pub fn (mut s CNetServer) get_client_info(client_host_id HostID) !CNetClientInfo {
	return error(':o')
}

pub fn (mut s CNetServer) is_connected_client(client_host_id HostID) bool {
	return false
}

pub fn (mut s CNetServer) set_host_tag(host_id HostID, tag voidptr) bool {
	return false
}

pub fn (mut s CNetServer) get_time_ms() u64 {
	return 0
}

pub fn (mut s CNetServer) join_p2p_group(member_host_id HostID, group_host_id HostID) bool {
	return false
}

pub fn (mut s CNetServer) leave_p2p_group(member_host_id HostID, group_host_id HostID) bool {
	return false
}

pub fn (mut s CNetServer) set_event_sink(event_sink []NetServerEvent) {

}

type OnClientJoin = fn (CNetClientInfo)
type OnClientLeave = fn (CNetClientInfo, ErrorInfo, ByteArray)
type OnClientHackSuspected = fn (HostID, HackType)
type OnClientOffline = fn (CRemoteOfflineEventArgs)
type OnClientOnline = fn (CRemoteOnlineEventArgs)
type OnConnectionRequest = fn (AddrPort, ByteArray, ByteArray) bool
type OnP2PGroupJoinMemberAckComplete = fn (HostID, HostID, ErrorType)
type OnP2PGroupRemoved = fn (HostID)