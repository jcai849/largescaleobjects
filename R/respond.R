queue <- function(x) {class(x) <- "queue"; x}

read.queue <- function(x) {
	info("Awaiting message on queues:", format(x))
	while (is.null(serializedMsg <- rediscc::redis.pop(commsConn(), x,
							   timeout=10))) {}
	m <- unserialize(charToRaw(serializedMsg))
	info("Received message")
	m
}

evaluate <- function(fun, args, target, cd) {
	stopifnot(is.list(args))
	args <- lapply(args, unstub, target=target)
	info("Performing requested function")
	chunk <- do.call(fun, args, envir=.GlobalEnv)
}

sendMetaData <- function(cd) {
}
