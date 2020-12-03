as.chunkRef	<- function(x, ...) UseMethod("as.chunkRef", x)
as.node		<- function(x, ...) UseMethod("as.node", x)
chunk		<- function(x, ...) UseMethod("chunk", x)
chunkRef	<- function(x, ...) UseMethod("chunkRef", x)
combine		<- function(...) UseMethod("combine", ..1)
distribute	<- function(x, target) UseMethod("distribute", target)
emerge		<- function(x, ...) UseMethod("emerge", x)
from		<- function(x, ...) UseMethod("from", x)
fun		<- function(x, ...) UseMethod("fun", x)
password	<- function(x, ...) UseMethod("password", x)
postChunkID	<- function(x, ...) UseMethod("postChunkID", x)
postJobID	<- function(x, ...) UseMethod("postJobID", x)
preview		<- function(x, ...) UseMethod("preview", x)
recToRef	<- function(arg, target) UseMethod("recToRef", target)
refToRec	<- function(arg, target) UseMethod("refToRec", arg)
resolution	<- function(x, ...) UseMethod("resolution", x)
resolve		<- function(x, ...) UseMethod("resolve", x)
resolved	<- function(x, ...) UseMethod("resolved", x)
size		<- function(x, ...) UseMethod("size", x)
store		<- function(x, ...) UseMethod("store", x)
target		<- function(x, ...) UseMethod("target", x)
to		<- function(x, ...) UseMethod("to", x)
user		<- function(x, ...) UseMethod("user", x)

`chunk<-` 	<- function(x, value) UseMethod("chunk<-", x)
`chunkID<-` 	<- function(x, value) UseMethod("chunkID<-", x)
`commPass<-` 	<- function(x, value) UseMethod("commPass<-", x)
`commPort<-` 	<- function(x, value) UseMethod("commPort<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`jobID<-` 	<- function(x, value) UseMethod("jobID<-", x)
`name<-`        <- function(x, value) UseMethod("name<-", x)
`objectPort<-`	<- function(x, value) UseMethod("objectPort<-", x)
`password<-`    <- function(x, value) UseMethod("password<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolution<-` 	<- function(x, value) UseMethod("resolution<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`user<-`        <- function(x, value) UseMethod("user<-", x)

host <- function(x, ...) {
	if (missing(x)) return(host(node()))
	UseMethod("host", x)
}

port <- function(x, ...) {
	if (missing(x)) return(port(node()))
	UseMethod("port", x)
}

name <- function(x, type) {
	if (missing(x)) {
		typelist <- c("node", "chunk", "job")
		stopifnot(type %in% typelist)

		ID <- paste0(capitalise(substr(type, 1, 1)),
			     rediscc::redis.inc(conn(), capitalise(type)))
		info("Attained ", type, " name: ", format(cID))
		return(ID)
	}
	UseMethod("name", x)
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
