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

struct RmiContext {

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

