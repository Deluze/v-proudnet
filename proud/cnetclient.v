module proud

struct CP2PConnectionStats {

}

struct CP2PPairConnectionStats {

}

struct CRemoteOfflineEventArgs {

}

struct CRemoteOnlineEventArgs {

}

struct CNetClientInfo {

}

struct CClientWorkerInfo {

}

struct CServerConnectionState {
pub:
	state ConnectionState
}

struct CNetPeerInfo {

}

struct CDirectP2PInfo {

}

struct CNetClientStats {

}

struct CFrameMoveResult {

}

struct CNetConnectionParams {

}

struct CNetClient {
	CoreEventFunctions
}

pub fn new_net_client() CNetClient {
	return CNetClient{}
}

pub fn (c CNetClient) connect(params CNetConnectionParams) {

}

pub fn (c CNetClient) disconnect() {

}

pub fn (c CNetClient) disconnect_async() {

}

pub fn (c CNetClient) frame_move(max_wait_time int) CFrameMoveResult {
	return CFrameMoveResult{}
}

pub fn (c CNetClient) get_group_members(group_host_id HostID) HostIDArray {
	return HostIDArray{}
}

pub fn (c CNetClient) get_indirect_server_time_ms(peer_host HostID) {
}

pub fn (c CNetClient) get_local_host_id() HostID {
	return HostID.@none
}

pub fn (c CNetClient) get_nat_device_name() string {
	return ''
}

pub fn (c CNetClient) get_local_joined_p2p_groups() HostIDArray {
	return HostIDArray{}
}

pub fn (c CNetClient) get_stats() CNetClientStats {
	return CNetClientStats{}
}

pub fn (c CNetClient) get_p2p_server_time_ms(group_host_id HostID) u64 {
	return 0
}

pub fn (c CNetClient) get_local_udp_socket_addr(remote_peer_id HostID) AddrPort {
	return AddrPort{}
}

pub fn (c CNetClient) get_direct_p2p_info(remote_peer_id HostID) CDirectP2PInfo {
	return CDirectP2PInfo{}
}

pub fn (c CNetClient) get_server_addr_port() AddrPort {
	return AddrPort{}
}

pub fn (c CNetClient) get_peer_info(peer_host_id HostID) CNetPeerInfo {
	return CNetPeerInfo{}
}

pub fn (c CNetClient) set_host_tag(host_id HostID) {
	// todo: ?
}

pub fn (c CNetClient) get_server_time_ms() u64 {
	return 0
}

pub fn (c CNetClient) get_server_time_diff_ms() u64 {
	return 0
}

pub fn (c CNetClient) get_server_connection_state() CServerConnectionState {
	return CServerConnectionState{state: .connected}
}

pub fn (c CNetClient) get_worker_state() CClientWorkerInfo {
	return CClientWorkerInfo{}
}

pub fn (c CNetClient) has_server_connection() bool {
	return false
}



