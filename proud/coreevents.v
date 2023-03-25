module proud

struct CoreEventFunctions {
pub mut:
	on_error OnError
	on_exception OnException
	on_information OnInformation
	on_no_rmi_processed OnNoRmiProcessed
	on_receive_user_message OnReceiveUserMessage
	on_warning OnWarning
	on_tick OnTick
	on_user_worker_thread_callback_begin OnUserWorkerThreadCallbackBegin
	on_user_worker_thread_callback_end OnUserWorkerThreadCallbackEnd
}

struct ErrorInfo {

}

struct Exception {

}

enum MessagePriority {
	default
}

enum MessageReliability {
	reliable
	unreliable
}

enum EncryptMode {
	normal
	fast
}

enum CompressMode {
	normal
	fast
}

struct RmiContext {
pub mut:
	relayed bool
	sent_from HostID
	unreliable_s2c_routed_multicast_max_count int
	unreliable_s2c_routed_multicast_max_ping_ms int
	max_direct_p2p_multicast_count int
	uid u64
	priority MessagePriority
	reliability MessageReliability
	enable_loop_back bool
	host_tag voidptr
	enable_p2p_jit_trigger bool
	allow_relay_send bool
	force_relay_threshold_ratio u64
	is_proud_specific_rmi bool
	fragment_on_need bool
	encrypt_mode EncryptMode
	compress_mode CompressMode
}

pub fn new_rmi_context(priority MessagePriority, reliability MessageReliability, unreliable_s2c_routed_multicast_max_count int, encrypt_mode EncryptMode) RmiContext {
	return RmiContext{
		relayed: false
		sent_from: 0
		unreliable_s2c_routed_multicast_max_count: unreliable_s2c_routed_multicast_max_count
		unreliable_s2c_routed_multicast_max_ping_ms: 0
		max_direct_p2p_multicast_count: -1
		uid: 0
		priority: MessagePriority.default
		reliability: MessageReliability.unreliable
		enable_loop_back: true
		host_tag: unsafe { nil }
		enable_p2p_jit_trigger: false
		allow_relay_send: false
		force_relay_threshold_ratio: 0
		is_proud_specific_rmi: false
		fragment_on_need: true
		encrypt_mode: EncryptMode.normal
		compress_mode: CompressMode.normal
	}
}


type OnError = fn (error ErrorInfo)
type OnException = fn (exception Exception)
type OnInformation = fn (info ErrorInfo)
type OnNoRmiProcessed = fn (rmi_id RmiID)

type OnReceiveUserMessage = fn (host HostID, context RmiContext, data voidptr, unk int)
type OnWarning = fn (warning ErrorInfo)
type OnTick = fn (unk voidptr)
type OnUserWorkerThreadCallbackBegin = fn ()
type OnUserWorkerThreadCallbackEnd = fn ()

