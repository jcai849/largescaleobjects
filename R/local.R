INIT <- local({
	rsc <- NULL	# redis connection
	v <- FALSE	# verbose

	distInit <- function(queueHost="localhost", queuePort=6379L, 
			     verbose=FALSE, ...) {
		v <<- verbose
		# Place for starting up server nodes
		rsc <<- rediscc::redis.connect(queueHost, queuePort) }
	conn <- function() {
		if (is.null(rsc)) 
			stop("Redis connection not found.",
			     "Use `distInit` to initialise.")
		rsc }
	verbose <- function() v
})

CHUNK_TABLE <- local({
	ct <- new.env()	# chunk table

	chunkTable 	<- function() ct
	rmChunk 	<- function(cID) rm(list = cID, envir = ct)
	chunk.chunkID 	<- function(x, ...) get(x, ct)
	queues 		<- function() ls(ct)
	addChunk 	<- function(cID, val) {
		info("Assigned chunk to ID:", 
		     format(cID), "in chunk table")
		assign(cID, val, envir = ct)}
})

getLocal <- function(loc) function(field) get(field, environment(loc))

getInit <- getLocal(INIT)
getChunkTable 	<- getLocal(CHUNK_TABLE)

distInit <- getInit("distInit")
conn <- getInit("conn")
verbose <- getInit("verbose")

chunkTable 	<- getChunkTable("chunkTable")
addChunk 	<- getChunkTable("addChunk")
rmChunk 	<- getChunkTable("rmChunk")
queues 		<- getChunkTable("queues")
chunk.chunkID 	<- getChunkTable("chunk.chunkID")

# alias
chunk.default <- chunk.chunkID
