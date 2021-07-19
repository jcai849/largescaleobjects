.largeScaleRConfig	<- new.env(TRUE, emptyenv())
.largeScaleRChunks	<- new.env(TRUE, emptyenv())
.largeScaleRConn	<- new.env(TRUE, emptyenv())
.largeScaleRProcesses	<- new.env(TRUE, emptyenv())
.largeScaleRKeys	<- new.env(TRUE, emptyenv())

assign("/", "/", envir=.largeScaleRKeys)
assign("unregisteredProcesses", new.env(TRUE, emptyenv()), envir=.largeScaleRProcesses)
final <- function(e) {
	if (identical(ls(.largeScaleRConn), character(0))) return()
	stateLog(paste("EXT", desc(getUserProcess()))) # EXT X - Exiting at worker X
	if (identical(ls(e), "unregisteredProcesses")) return()
	workers <- as.integer(rediscc::redis.get(getCommsConn(),
						 "process")) - 1
	for (proc in seq(workers))
		kill(root())
	clearComms()
}
reg.finalizer(.largeScaleRProcesses,
	      final,
	      onexit=TRUE)

unregisteredProcesses	<- function() get("unregisteredProcesses",
						envir = .largeScaleRProcesses,
						inherits=FALSE)
getCommsProcess		<- function() get("commsProcess",
						envir = .largeScaleRProcesses,
						inherits=FALSE)
getUserProcess		<- function() get("userProcess",
					 	envir = .largeScaleRProcesses,
						inherits=FALSE)
getLogProcess		<- function() get("logProcess",
						envir = .largeScaleRProcesses,
						inherits=FALSE)
getCommsConn		<- function() get("commsConn", 
						envir = .largeScaleRConn,
						inherits=FALSE)
getChunkStore		<- function() .largeScaleRChunks

addChunk <- function(cd, val) {
	assign(as.character(cd), val, envir = .largeScaleRChunks)
	osrv::put(as.character(cd), serialize(val, NULL))
	stateLog(paste("SVD", desc(getUserProcess()), 
		       as.character(cd))) # SVD X Y - Saving at worker X, chunk Y
	val
}

envBase <- function(x) {
        if (!is.null(x)) attr(x, ".Environment") <- baseenv()
        x
}

currCallFun <- function(n=0) { 
	cl <- sys.call(n-1)
	as.function(c(alist(...=), call("quote", cl)))
}
