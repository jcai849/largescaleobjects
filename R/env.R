.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRProcesses	<- new.env()
.largeScaleRKeys	<- new.env()

assign("/", "/", envir=.largeScaleRKeys)
assign("workerProcesses", new.env(), envir=.largeScaleRProcesses)

addChunk <- function(cd, val) {
	info("Added chunk with descriptor:", 
	     format(cd), "in chunk table")
	assign(as.character(cd), val, envir = .largeScaleRChunks)
	osrv::put(as.character(cd), serialize(val, NULL))
	val
}

commsConn <- function() get("commsConn", envir=.largeScaleRConn)
