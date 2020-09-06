chunk 		<- function(x, ...) UseMethod("chunk", x)
chunkRef 	<- function(x, ...) UseMethod("chunkRef", x)
preview 	<- function(x, ...) UseMethod("preview", x)
resolution 	<- function(x, ...) UseMethod("resolution", x)
resolve 	<- function(x, ...) UseMethod("resolve", x)
resolved 	<- function(x, ...) UseMethod("resolved", x)

`chunkID<-` 	<- function(x, value) UseMethod("chunkID<-", x)
`jobID<-` 	<- function(x, value) UseMethod("jobID<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolution<-` 	<- function(x, value) UseMethod("resolution<-", x)

dist 		<- function(x, ...) UseMethod("dist", x) # masking
dist.default 	<- stats::dist

chunkID <- function(x, ...) {
	if (missing(x)) {
		cID <- paste0("C", rediscc::redis.inc(conn(), "CHUNK_ID"))
		info("Attained Chunk ID: ", format(cID))
		class(cID) <- "chunkID"
		return(cID)
	}
	UseMethod("chunkID", x)
}

jobID <- function(x, ...) {
	if (missing(x)) {
		jID <- paste0("J", rediscc::redis.inc(conn(), "JOB_ID"))
		info("Attained job ID: ", format(jID))
		class(jID) <- "jobID"
		return(jID)
	}
	UseMethod("jobID", x)
}
