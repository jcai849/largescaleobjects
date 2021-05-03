kill <- function(chunk) {
	do.call.chunkRef(function() {
				  stateLog(paste("EXT", desc(getUserProcess())))
				  quit("no")},
			  list(), chunk)
	return()
}

 # EXT X - Exiting at worker X
clearComms <- function() {
	rediscc::redis.rm(getCommsConn(),
			  rediscc::redis.keys(getCommsConn(), "*"))
}
