as.chunkRef	<- function(x, ...) UseMethod("as.chunkRef", x)
chunk 		<- function(x, ...) UseMethod("chunk", x)
chunkRef 	<- function(x, ...) UseMethod("chunkRef", x)
combine         <- function(...) UseMethod("combine", ..1)
emerge          <- function(x, ...) UseMethod("emerge", x)
from            <- function(x, ...) UseMethod("from", x)
fun		<- function(x, ...) UseMethod("fun", x)
distribute	<- function(x, target) UseMethod("distribute", target)
postChunkID	<- function(x, ...) UseMethod("postChunkID", x)
postJobID	<- function(x, ...) UseMethod("postJobID", x)
preview 	<- function(x, ...) UseMethod("preview", x)
refToRec	<- function(arg, target) UseMethod("refToRec", arg)
recToRef	<- function(arg, target) UseMethod("recToRef", target)
resolution 	<- function(x, ...) UseMethod("resolution", x)
resolve 	<- function(x, ...) UseMethod("resolve", x)
resolved 	<- function(x, ...) UseMethod("resolved", x)
size            <- function(x, ...) UseMethod("size", x)
target		<- function(x, ...) UseMethod("target", x)
to              <- function(x, ...) UseMethod("to", x)

`chunk<-` 	<- function(x, value) UseMethod("chunk<-", x)
`chunkID<-` 	<- function(x, value) UseMethod("chunkID<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`jobID<-` 	<- function(x, value) UseMethod("jobID<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolution<-` 	<- function(x, value) UseMethod("resolution<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)

host <- function(x, ...) {
	if (missing(x)) return(myHost())
	UseMethod("host", x)
}

port <- function(x, ...) {
	if (missing(x)) return(myPort())
	UseMethod("port", x)
}

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

# masking
args		<- function(name) UseMethod("args", name)
args.default	<- base::args
table		<- function(...) UseMethod("table", ..1)
table.default	<- base::table
read.csv	<- function(...) UseMethod("read.csv", ..1)
read.csv.default<- utils::read.csv
dim		<- function(x) UseMethod("dim", x)
dim.default	<- base::dim
