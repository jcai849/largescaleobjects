chunkStub	<- function(x, ...) UseMethod("chunkStub", x)
colTypes	<- function(x, ...) UseMethod("colTypes", x)
combine		<- function(...) UseMethod("combine", ..1)
dbpass		<- function(x, ...) UseMethod("dbpass", x)
execute		<- function(x, ...) UseMethod("execute", x)
from		<- function(x, ...) UseMethod("from", x)
fun		<- function(x, ...) UseMethod("fun", x)
header		<- function(x, ...) UseMethod("header", x)
host		<- function(x, ...) UseMethod("host", x)
loc		<- function(x, ...) UseMethod("loc", x)
pass		<- function(x, ...) UseMethod("pass", x)
preview		<- function(x, ...) UseMethod("preview", x)
quotes		<- function(x, ...) UseMethod("quotes", x)
read		<- function(x, ...) UseMethod("read", x)
resolve		<- function(x, ...) UseMethod("resolve", x)
resolved	<- function(x, ...) UseMethod("resolved", x)
size		<- function(x, ...) UseMethod("size", x)
stub		<- function(arg, target) UseMethod("stub", target)
target		<- function(x, ...) UseMethod("target", x)
to		<- function(x, ...) UseMethod("to", x)
unstub		<- function(arg, target) UseMethod("unstub", arg)
user		<- function(x, ...) UseMethod("user", x)

`chunkStub<-` 	<- function(x, value) UseMethod("chunkStub<-", x)
`colTypes<-` 	<- function(x, value) UseMethod("colTypes<-", x)
`dbpass<-` 	<- function(x, value) UseMethod("dbpass<-", x)
`desc<-` 	<- function(x, value) UseMethod("desc<-", x)
`execute<-` 	<- function(x, value) UseMethod("execute<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`header<-` 	<- function(x, value) UseMethod("header<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`loc<-`        <- function(x, value) UseMethod("loc<-", x)
`name<-`        <- function(x, value) UseMethod("name<-", x)
`pass<-`	<- function(x, value) UseMethod("pass<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`quotes<-` 	<- function(x, value) UseMethod("quotes<-", x)
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

	desc <- rediscc::redis.inc(getCommsConn(), type)
	log(paste("attained", type, "descriptor", format(desc)))
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
