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

format.msg <- function(x) {
	previews <- sapply(x, preview)
	paste0(c("Message with components:", 
		 paste(names(previews), previews, sep=": ", collapse="\n")),
	       collapse="\n")
}

preview.function <- function(x) format(args(x))[1]
preview.list	<- function(x) {
	previews <- sapply(x, preview)
	paste(names(previews), previews, sep=": ", collapse="; ")
}
preview.default <- identity
fun.msg		<- function(x) x$fun
args.msg	<- function(x) x$args
target.msg	<- function(x) x$target
desc.msg	<- function(x) x$desc

send <- function(..., loc) {
	m <- msg(...)
	log(paste("sending msg to ", format(loc), ":\n", format(m)))
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	rediscc::redis.push(getCommsConn(), loc, serializedMsg)
}
