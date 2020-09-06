INIT <- local({
	rsc <- NULL

	distInit <- function(queueHost="localhost", queuePort=6379L, ...) {
		# Place for starting up server nodes
		rsc <<- rediscc::redis.connect(queueHost, queuePort) }
	conn <- function() {
		if (is.null(rsc)) 
			stop("Redis connection not found. Use `distInit` to initialise.")
		rsc }
})

CHUNK_TABLE <- local({
	ct <- new.env()

	chunkTable 	<- function() ct
	addChunk 	<- function(cID, val) assign(cID, val, envir = ct)
	rmChunk 	<- function(cID) rm(list = ciD, envir = ct)
	chunk.chunkID 	<- function(x, ...) get(x, ct)
	queues 		<- function() ls(ct)
})

getLocal <- function(loc) function(field) get(field, environment(loc))

getInit <- getLocal(INIT)
getChunkTable 	<- getLocal(CHUNK_TABLE)

distInit <- getInit("distInit")
conn <- getInit("conn")

chunkTable 	<- getChunkTable("chunkTable")
addChunk 	<- getChunkTable("addChunk")
rmChunk 	<- getChunkTable("rmChunk")
queues 		<- getChunkTable("queues")
chunk.chunkID 	<- getChunkTable("chunk.chunkID")

# alias
chunk.default <- chunk.chunkID
