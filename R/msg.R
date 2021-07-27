msgconn <- function() conn(msg())

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

getMsg		<- function(field) function(x, ...) getElement(x, field)
args.msg	<- function(x, target, ...) 
	rapply(getMsg("args")(x, ...),  emerge,
	       classes = c("AsIs", "chunkRef", "distObjRef"),
	       deflt = NULL, how="replace", target=target)
desc.msg	<- getMsg("desc")
from.msg	<- getMsg("from")
fun.msg		<- function(x, ...) as.function(getMsg("fun")(x, ...))
host.msg	<- getMsg("host")
insert.msg	<- getMsg("insert")
port.msg	<- getMsg("port")
preview.msg	<- getMsg("preview")
size.msg	<- getMsg("size")
store.msg	<- getMsg("store")
target.msg	<- getMsg("target")
to.msg		<- getMsg("to")

as.function.character <- function(x, ...) {
                funsplit <- strsplit(x, "::", fixed=TRUE)[[1]]
                if (length(funsplit) == 2L) {
                        getFromNamespace(funsplit[2], funsplit[1])
                } else get(x)
}
