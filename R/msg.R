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

format.msg <- function(x) 
	paste0(c("Message with components:", sapply(names(x), format)),
	       collapse="\n")

fun.msg		<- function(x) x$fun
args.msg	<- function(x) x$args
target.msg	<- function(x) x$target
desc.msg	<- function(x) x$desc

send <- function(..., loc) {
	m <- msg(...)
	ulog::ulog(paste("sending msg to ", format(loc), ":\n", format(m)))
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}
