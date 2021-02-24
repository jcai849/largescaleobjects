.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRProcesses	<- new.env()
.largeScaleRKeys	<- new.env()

assign("/", "/", envir=.largeScaleRKeys)
assign("uninitialisedProcesses", new.env(), envir=.largeScaleRProcesses)

uninitialisedProcesses	<- function() get("uninitialisedProcesses",
						envir = .largeScaleRProcesses)
getCommsProcess		<- function() get("commsProcess",
						envir = .largeScaleRProcesses)
getUserProcess		<- function() get("userProcess",
					 	envir = .largeScaleRProcesses)
getLogProcess		<- function() get("logProcess",
						envir = .largeScaleRProcesses)
getCommsConn		<- function() get("commsConn", 
						envir = .largeScaleRConn)

addChunk <- function(cd, val) {
	assign(as.character(cd), val, envir = .largeScaleRChunks)
	osrv::put(as.character(cd), serialize(val, NULL))
	val
}

