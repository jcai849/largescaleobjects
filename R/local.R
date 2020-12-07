INIT <- local({
	rsc <- NULL		# redis connection
	v <- FALSE		# verbose
	thisNode <- NULL
	commServer <- NULL

	# if any nodes given in ... as master, this node is treated as the user
	# node and is used as startup. Otherwise, used to fire up worker nodes
	# directly
	init <- function(curr, commServer, ..., verbose=FALSE) {
		dots <- list(...)
		# paste node startup code from demo (see doRedis as
		# well) 
		# --- 
		# foreach in dots:
		# 	init;
		# 	put root queue on list;
		# 	server;
		# ---
		thisNode <<- curr
		commServer <<- commServer
		v <<- verbose
		info("Connecting to Redis server")
		rsc <<- rediscc::redis.connect(host(getCommServer()),
					       commPort(getCommServer()),
					       commPass(getCommServer()),
					       reconnect=TRUE)
		info("Starting osrv server")
		osrv::start(host(getNode()), objectPort(getNode()))
		NULL }

	conn <- function() {
		if (!connected()) 
			stop("Redis connection not found.",
			     "Use `distInit` to initialise.")
		rsc }
	connected	<- function() !is.null(rsc)
	verbose 	<- function() v
	getNode		<- function() thisNode
	getCommServer	<- function() commServer
})

CHUNK_TABLE <- local({
	ct <- new.env()	# chunk table

	chunks	 	<- function() ct
	rmChunk 	<- function(cID) rm(list = cID, envir = ct)
	chunk.chunkID 	<- function(x, ...) get(x, ct)
	chunk.chunkRef 	<- function(x, ...) get(chunkID(x), ct)
	localChunks	<- function() ls(ct)
	addChunk 	<- function(cID, val) {
		info("Assigned chunk to ID:", 
		     format(cID), "in chunk table")
		assign(cID, val, envir = ct)
		osrv::put(cID, serialize(val, NULL))}
})

fromInitTabGet	<- getLocal(INIT)
fromChunkTabGet	<- getLocal(CHUNK_TABLE)

init		<- fromInitTabGet("init")
conn		<- fromInitTabGet("conn")
connected	<- fromInitTabGet("connected")
getNode		<- fromInitTabGet("getNode")
getCommServer	<- fromInitTabGet("getCommServer")

chunks	 	<- fromChunkTabGet("chunks")
addChunk 	<- fromChunkTabGet("addChunk")
rmChunk 	<- fromChunkTabGet("rmChunk")
localChunks	<- fromChunkTabGet("localChunks")
chunk.chunkID 	<- fromChunkTabGet("chunk.chunkID")
chunk.chunkRef 	<- fromChunkTabGet("chunk.chunkRef")
