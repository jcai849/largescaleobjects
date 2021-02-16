chunkStub	<- function(x, ...) UseMethod("chunkStub", x)
combine		<- function(...) UseMethod("combine", ..1)
distribute	<- function(x, target) UseMethod("distribute", target)
dbpass		<- function(x, ...) UseMethod("dbpass", x)
emerge		<- function(x, ...) UseMethod("emerge", x)
from		<- function(x, ...) UseMethod("from", x)
fun		<- function(x, ...) UseMethod("fun", x)
host		<- function(x, ...) UseMethod("host", x)
loc		<- function(x, ...) UseMethod("loc", x)
pass		<- function(x, ...) UseMethod("pass", x)
preview		<- function(x, ...) UseMethod("preview", x)
stub		<- function(arg, target) UseMethod("stub", target)
unstub		<- function(arg, target) UseMethod("unstub", arg)
read		<- function(x, ...) UseMethod("read", x)
resolved	<- function(x, ...) UseMethod("resolved", x)
resolve		<- function(x, ...) UseMethod("resolve", x)
size		<- function(x, ...) UseMethod("size", x)
target		<- function(x, ...) UseMethod("target", x)
to		<- function(x, ...) UseMethod("to", x)
user		<- function(x, ...) UseMethod("user", x)

`chunkStub<-` 	<- function(x, value) UseMethod("chunkStub<-", x)
`dbpass<-` 	<- function(x, value) UseMethod("dbpass<-", x)
`desc<-` 	<- function(x, value) UseMethod("desc<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`loc<-`        <- function(x, value) UseMethod("loc<-", x)
`name<-`        <- function(x, value) UseMethod("name<-", x)
`pass<-`	<- function(x, value) UseMethod("pass<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`resolved<-` 	<- function(x, value) UseMethod("resolved<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`user<-`        <- function(x, value) UseMethod("user<-", x)

port 		<- function(x, ...) {
	if (missing(x)) return(.Call(C_port))
	UseMethod("port", x)
}

desc <- function(x, ...) UseMethod("desc", x)

desc.default <- function(type) {
	typelist <- c("process", "chunk")
	stopifnot(type %in% typelist)

	desc <- rediscc::redis.inc(commsConn(), type)
	info("Attained ", type, " descriptor: ", desc)
	desc
}

# masking
args		<- function(name) UseMethod("args", name)
args.default	<- base::args
table		<- function(...) UseMethod("table", ..1)
table.default	<- base::table
dim		<- function(x) UseMethod("dim", x)
dim.default	<- base::dim
preview.default	<- utils::head
