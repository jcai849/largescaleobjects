.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRProcesses	<- new.env()
.largeScaleRKeys	<- new.env()

assign("/", "/", envir=.largeScaleRKeys)
assign("unregisteredProcesses", new.env(), envir=.largeScaleRProcesses)

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
	assign(as.character(cd), val, envir = .largeScaleRChunks)
	osrv::put(as.character(cd), serialize(val, NULL))
	val
}

