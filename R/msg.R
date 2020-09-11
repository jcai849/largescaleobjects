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
	     "to queue belonging to chunk\"", to, "\"")
	rediscc::redis.push(conn(), to, serializedMsg)
}

read.queue <- function(queue, clear = FALSE, timeOut=Inf) {
	info("Awaiting message on queues:", format(queue))
	serializedMsg <- rediscc::redis.pop(conn(), queue, timeout=timeOut)
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
anteChunkID.msg	<- msgField("ANTE_CHUNK_ID")
anteJobID.msg	<- msgField("ANTE_JOB_ID")
postChunkID.msg	<- msgField("POST_CHUNK_ID")
postJobID.msg	<- msgField("POST_JOB_ID")

toAssign	<- function(x) hasName(x, "POST_CHUNK_ID")

chunk.msg <- function(x, ...) chunk(chunkID(chunkRef(x)))

# Responses
resolution.msg	<- msgField("RESOLUTION")
preview.msg 	<- msgField("PREVIEW")
