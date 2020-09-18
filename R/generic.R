to              <- function(x, ...) UseMethod("to", x)
from            <- function(x, ...) UseMethod("from", x)
combine         <- function(x, ...) UseMethod("combine", x)
emerge          <- function(x, ...) UseMethod("emerge", x)
size            <- function(x, ...) UseMethod("size", x)
chunk 		<- function(x, ...) UseMethod("chunk", x)
chunkRef 	<- function(x, ...) UseMethod("chunkRef", x)
preview 	<- function(x, ...) UseMethod("preview", x)
resolution 	<- function(x, ...) UseMethod("resolution", x)
resolve 	<- function(x, ...) UseMethod("resolve", x)
resolved 	<- function(x, ...) UseMethod("resolved", x)
fun		<- function(x, ...) UseMethod("fun", x)
anteChunkID	<- function(x, ...) UseMethod("anteChunkID", x)
anteJobID	<- function(x, ...) UseMethod("anteJobID", x)
postChunkID	<- function(x, ...) UseMethod("postChunkID", x)
postJobID	<- function(x, ...) UseMethod("postJobID", x)
as.chunkRef	<- function(x, ...) UseMethod("fun", x)
refToRec	<- function(arg, target) UseMethod("refToRec", arg)

`chunkID<-` 	<- function(x, value) UseMethod("chunkID<-", x)
`chunk<-` 	<- function(x, value) UseMethod("chunk<-", x)
`jobID<-` 	<- function(x, value) UseMethod("jobID<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolution<-` 	<- function(x, value) UseMethod("resolution<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)

# masking
args		<- function(name) UseMethod("args", name)
args.default	<- base::args

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
