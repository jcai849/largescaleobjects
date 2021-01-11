as.chunkRef	<- function(x, ...) UseMethod("as.chunkRef", x)
as.node		<- function(x, ...) UseMethod("as.node", x)
chunk		<- function(x, ...) UseMethod("chunk", x)
chunkRef	<- function(x, ...) UseMethod("chunkRef", x)
combine		<- function(...) UseMethod("combine", ..1)
distribute	<- function(x, target) UseMethod("distribute", target)
emerge		<- function(x, ...) UseMethod("emerge", x)
from		<- function(x, ...) UseMethod("from", x)
fun		<- function(x, ...) UseMethod("fun", x)
host		<- function(x, ...) UseMethod("host", x)
init		<- function(x, ...) UseMethod("init", x)
pass		<- function(x, ...) UseMethod("pass", x)
postChunkDesc	<- function(x, ...) UseMethod("postChunkDesc", x)
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
`chunkDesc<-` 	<- function(x, value) UseMethod("chunkDesc<-", x)
`dbpass<-` 	<- function(x, value) UseMethod("dbpass<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`name<-`        <- function(x, value) UseMethod("name<-", x)
`pass<-`	<- function(x, value) UseMethod("pass<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolution<-` 	<- function(x, value) UseMethod("resolution<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`user<-`        <- function(x, value) UseMethod("user<-", x)

port 		<- function(x, ...) {
	if (missing(x)) return(.Call(C_port))
	UseMethod("port", x)
}

desc <- function(type) {
	typelist <- c("proc", "chunk")
	stopifnot(type %in% typelist)

	desc <- paste0(capitalise(substr(type, 1, 1)),
		     rediscc::redis.inc(commConn(), capitalise(type)))
	info("Attained ", type, " descriptor: ", desc)
	desc
}

chunkDesc <- function(x, ...) {
	if (missing(x)) {
		cd <- desc("chunk")
		class(cd) <- "chunkID"
		return(cID)
	}
	UseMethod("chunkDesc", x)
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
