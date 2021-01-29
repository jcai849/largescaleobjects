.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRProcesses	<- new.env()
.largeScaleRKeys	<- new.env()

assign("/", "/", envir=.largeScaleRKeys)
assign("workerProcesses", new.env(), envir=.largeScaleRProcesses)

addChunk <- function(cID, val) {
	info("Assigned chunk to ID:", 
	     format(cID), "in chunk table")
	assign(cID, val, envir = .largeScaleRChunks)
	osrv::put(cID, serialize(val, NULL))
	val
}

commsConn <- function() get("commsConn", envir=.largeScaleRConn)
