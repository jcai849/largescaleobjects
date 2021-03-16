.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRProcesses	<- new.env()
.largeScaleRKeys	<- new.env()

assign("/", "/", envir=.largeScaleRKeys)
assign("unregisteredProcesses", new.env(), envir=.largeScaleRProcesses)
final <- function(e) {
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

addChunk <- function(cd, val) {
	log(paste("assigning as descriptor", cd, "chunk of size",
			 size(val), "using",
			 format(object.size(val), units="Mb")))
	assign(as.character(cd), val, envir = .largeScaleRChunks)
	log("storing chunk in osrv")
	osrv::put(as.character(cd), serialize(val, NULL))
	val
}

