module proud

import datatypes

struct P2PGroup {
pub mut:
	host_id HostID [required]
	members datatypes.Set[HostID]
}

pub fn new_p2p_group(host_id HostID) P2PGroup {
	return P2PGroup{
		host_id: host_id
	}
}

pub fn (mut g P2PGroup) add_member(client_host_id HostID) {
	g.members.add(client_host_id)
}

pub fn (mut g P2PGroup) remove_member(client_host_id HostID) {
	g.members.remove(client_host_id)
}