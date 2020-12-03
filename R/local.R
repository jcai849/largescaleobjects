INIT <- local({
	nt <- new.env()		# node table
	rsc <- NULL		# redis connection
	v <- FALSE		# verbose
	thisNode <- NULL
	masterNode <- NULL

	# if any nodes given in ... as master, this node is treated as the user
	# node and is used as startup. Otherwise, used to fire up worker nodes
	# directly
	init <- function(..., curr, verbose=FALSE) {
		dots <- list(...)
		if (any(sapply(is.worker, dots))) {
			# paste node startup code from demo (see doRedis as
			# well)
			workerNodes <- dots[-masterNode]
			if (workerNodes > 0) lapply(registerNodes, workerNodes)
		}
		if (missing(curr) && missing(dots)) curr <- master()
		if (!is.master(curr)) {
			iMaster <- which(is.master, dots)
			stopifnot(length(iMaster) == 1L)
			store(dots[iMaster])
		} else store(curr)
		thisNode <<- curr
		v <<- verbose
		info("Connecting to Redis server")
		rsc <<- rediscc::redis.connect(host(getMaster()),
					       commPort(getMaster()),
					       commPass(getMaster()),
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
	getMaster	<- function() masterNode
	store.node	<- function(node) assign(name(node), node, envir = nt)
	store.master	<- function(x) masterNode <<- x
	nodes		<- function() nt
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
getMaster	<- fromInitTabGet("getMaster")
verbose		<- fromInitTabGet("verbose")
store.node	<- fromInitTabGet("store.node")
store.master	<- fromInitTabGet("store.master")
nodes		<- fromInitTabGet("nodes")

chunks	 	<- fromChunkTabGet("chunks")
addChunk 	<- fromChunkTabGet("addChunk")
rmChunk 	<- fromChunkTabGet("rmChunk")
localChunks	<- fromChunkTabGet("localChunks")
chunk.chunkID 	<- fromChunkTabGet("chunk.chunkID")
chunk.chunkRef 	<- fromChunkTabGet("chunk.chunkRef")
