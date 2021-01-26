.largeScaleRConfig	<- new.env()
.largeScaleRChunks	<- new.env()
.largeScaleRConn	<- new.env()
.largeScaleRKeys	<- new.env()

addChunk <- function(cID, val) {
	info("Assigned chunk to ID:", 
	     format(cID), "in chunk table")
	assign(cID, val, envir = .largeScaleRChunks)
	osrv::put(cID, serialize(val, NULL))
	val
}

commsConn <- function() get("commsConn", .largeScaleRConn)
