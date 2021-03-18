send <- function(..., loc) {
	m <- msg(...)
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}

receive <- function(loc) {
        while (is.null(serializedMsg <-
                rediscc::redis.pop(getCommsConn(), loc, timeout=10))) {}
        unserialize(charToRaw(serializedMsg))
}

msg <- function(...) {
	m <- list(...)
	class(m) <- "msg"
	m
}

print.msg <- function(x) {
	cat("Message with components:\n")
	for (n in names(x)) {
		cat("\t", n, ":\n")
		print(x[[n]])
	}
}

getMsg		<- function(field) function(x) x[[field]]
fun.msg		<- getMsg("fun")
args.msg	<- getMsg("args")
target.msg	<- getMsg("target")
desc.msg	<- getMsg("desc")
save.msg	<- getMsg("save")
