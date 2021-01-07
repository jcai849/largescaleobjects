msg <- function(...) {
	structure(list(...), class = "msg")
}

send <- function(..., to) {
	items <- list(...)
	m <- do.call(msg, items)
	write.msg(m, to)
}

write.msg <- function(m, to) {
	serializedMsg <- rawToChar(serialize(m, NULL, T))
	info("writing message:", format(m), 
	     "to queue belonging to chunk", to)
	rediscc::redis.push(conn(), to, serializedMsg)
}

read.queue <- function(queue, clear = FALSE) {
	info("Awaiting message on queues:", format(queue))
	while (is.null(serializedMsg <-rediscc::redis.pop(conn(), queue,
							  timeout=10))) {}
	if (clear) rediscc::redis.rm(conn(), queue)
	m <- unserialize(charToRaw(serializedMsg))
	info("Received message:", format(m))
	m
}

# Get
msgField <- function(field) function(x, ...) x[[field]]

# Requests
fun.msg 	<- msgField("FUN")
args.msg	<- msgField("ARGS")
target.msg	<- msgField("TARGET")
postChunkID.msg	<- msgField("POST_CHUNK_ID")
postJobID.msg	<- msgField("POST_JOB_ID")

chunk.msg <- function(x, ...) chunk(chunkID(chunkRef(x)))

# Responses
resolution.msg	<- msgField("RESOLUTION")
preview.msg 	<- msgField("PREVIEW")
size.msg 	<- msgField("SIZE")
host.msg 	<- msgField("HOST")
port.msg 	<- msgField("PORT")
