kill <- function(chunk) {
	do.call.chunkStub("q", list(save="no"), chunk)
	return()
}

clearComms <- function() {
	rediscc::redis.rm(getCommsConn(),
			  rediscc::redis.keys(getCommsConn(), "*"))
}
