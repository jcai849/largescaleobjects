send <- function(..., loc) {
	m <- msg(...)
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}

receive <- function(loc) {
	stateLog(paste("WTQ", desc(getUserProcess()))) # WTQ X - Waiting on queues at worker X
        while (is.null(serializedMsg <-
                rediscc::redis.pop(getCommsConn(), loc, timeout=10))) {}
        unserialize(charToRaw(serializedMsg))
}

msg <- function(...) {
	m <- list(...)
	class(m) <- "msg"
	m
}

print.msg <- function(x, ...) {
	cat("Message with components:\n")
	for (n in names(x)) {
		cat("\t", n, ":\n")
		print(x[[n]])
	}
}

getMsg		<- function(field) function(x, ...) x[[field]]
args.msg	<- getMsg("args")
desc.msg	<- getMsg("desc")
from.msg	<- getMsg("from")
fun.msg		<- getMsg("fun")
host.msg	<- getMsg("host")
mask.msg	<- getMsg("mask")
port.msg	<- getMsg("port")
preview.msg	<- getMsg("preview")
size.msg	<- getMsg("size")
store.msg	<- getMsg("store")
target.msg	<- getMsg("target")
to.msg		<- getMsg("to")
