INIT <- local({
	rsc <- NULL		# redis connection
	v <- FALSE		# verbose
	h <- character()	# host
	p <- character()	# port

	distInit <- function(redisHost="localhost", redisPort=6379L, 
			     osrvHost=Sys.info()$nodename, osrvPort=9012L,
			     verbose=FALSE, ...) {
		v <<- verbose
		h <<- osrvHost
		p <<- osrvPort
		# Place for starting up server nodes
		info("Connecting to Redis server")
		rsc <<- rediscc::redis.connect(queueHost, queuePort) 
		info("Starting osrv server")
		osrv::start(osrvHost, osrvPort)
		NULL }
	conn <- function() {
		if (is.null(rsc)) 
			stop("Redis connection not found.",
			     "Use `distInit` to initialise.")
		rsc }
	verbose <- function() v
	myHost	<- function() h
	myPort	<- function() p
})

CHUNK_TABLE <- local({
	ct <- new.env()	# chunk table

	chunkTable 	<- function() ct
	rmChunk 	<- function(cID) rm(list = cID, envir = ct)
	chunk.chunkID 	<- function(x, ...) get(x, ct)
	chunk.chunkRef 	<- function(x, ...) get(chunkID(x), ct)
	queues 		<- function() ls(ct)
	addChunk 	<- function(cID, val) {
		info("Assigned chunk to ID:", 
		     format(cID), "in chunk table")
		assign(cID, val, envir = ct)
		osrv::put(cID, serialize(val, NULL))}
})

getInit		<- getLocal(INIT)
getChunkTable	<- getLocal(CHUNK_TABLE)

distInit	<- getInit("distInit")
conn		<- getInit("conn")
verbose		<- getInit("verbose")
myHost		<- getInit("myHost")
myPort		<- getInit("myPort")

chunkTable 	<- getChunkTable("chunkTable")
addChunk 	<- getChunkTable("addChunk")
rmChunk 	<- getChunkTable("rmChunk")
queues 		<- getChunkTable("queues")
chunk.chunkID 	<- getChunkTable("chunk.chunkID")
chunk.chunkRef 	<- getChunkTable("chunk.chunkRef")
