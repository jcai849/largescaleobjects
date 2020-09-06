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

# Generics
op 	<- function(x, ...) UseMethod("op", x)
static 	<- function(x, ...) UseMethod("static", x)
fun 	<- function(x, ...) UseMethod("fun", x)

msgField <- function(field) function(x, ...) x[[field]]

# Requests
op.msg 		<- msgField("OP")
fun.msg 	<- msgField("FUN")
static.msg 	<- msgField("STATIC_ARGS")
chunkRef.msg 	<- msgField("CHUNK")
jobID.msg 	<- msgField("JOB_ID")
dist.msg 	<- msgField("DIST_ARGS")
chunkID.msg 	<- msgField("CHUNK_ID");

chunk.msg <- function(x, ...) chunk(chunkID(chunkRef(x)))

# Responses
resolution.msg	<- msgField("RESOLUTION")
preview.msg 	<- msgField("PREVIEW")
