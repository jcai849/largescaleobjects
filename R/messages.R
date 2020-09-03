# messaging functions

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
	rediscc::redis.push(conn(), to, serializedMsg)
	cat("wrote message: ", format(m), 
	    " to queue belonging to chunk \"", to, "\"\n", sep="")
}

read.queue <- function(queue, clear = FALSE) {
	cat("Awaiting message on queues: ", format(queue),  "\n", sep="")
	serializedMsg <- rediscc::redis.pop(conn(), queue, timeout=Inf)
	if (clear) rediscc::redis.rm(conn(), queue)
	m <- unserialize(charToRaw(serializedMsg))
	cat("Received message:", format(m), "\n")
	m
}

# message field accessors

msgField <- function(field) function(x, ...) x[[field]]
# Requesters
op <- msgField("OP"); fun <- msgField("FUN")
static <- msgField("STATIC_ARGS")
chunk.msg <- function(x, ...) get(chunkID(msgField("CHUNK")(x)))
jobID.msg <- msgField("JOB_ID"); dist.msg <- msgField("DIST_ARGS")
# Responders
val <- msgField("VAL"); chunkID.msg <- msgField("CHUNK_ID")
