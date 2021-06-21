chunkRef	<- function(x, ...) UseMethod("chunkRef", x)
access		<- function(x, ...) UseMethod("access", x)
combine		<- function(...) UseMethod("combine", ..1)
dbpass		<- function(x, ...) UseMethod("dbpass", x)
execute		<- function(x, ...) UseMethod("execute", x)
from		<- function(x, ...) UseMethod("from", x)
fillMetaData	<- function(x, ...) UseMethod("fillMetaData", x)
fun		<- function(x, ...) UseMethod("fun", x)
host		<- function(x, ...) UseMethod("host", x)
mask		<- function(x, ...) UseMethod("mask", x)
pass		<- function(x, ...) UseMethod("pass", x)
preview		<- function(...) UseMethod("preview", ..1)
read		<- function(x, ...) UseMethod("read", x)
requestField	<- function(field, x, ...) UseMethod("requestField", x)
size		<- function(...) UseMethod("size", ..1)
store		<- function(x, ...) UseMethod("store", x)
distribute		<- function(arg, target) UseMethod("distribute", target)
target		<- function(x, ...) UseMethod("target", x)
to		<- function(x, ...) UseMethod("to", x)
emerge		<- function(arg, target) UseMethod("emerge", arg)
user		<- function(x, ...) UseMethod("user", x)

`chunkRef<-` 	<- function(x, value) UseMethod("chunkRef<-", x)
`dbpass<-` 	<- function(x, value) UseMethod("dbpass<-", x)
`desc<-` 	<- function(x, value) UseMethod("desc<-", x)
`execute<-` 	<- function(x, value) UseMethod("execute<-", x)
`from<-`        <- function(x, value) UseMethod("from<-", x)
`host<-`        <- function(x, value) UseMethod("host<-", x)
`mask<-`        <- function(x, value) UseMethod("mask<-", x)
`name<-`        <- function(x, value) UseMethod("name<-", x)
`pass<-`	<- function(x, value) UseMethod("pass<-", x)
`port<-`        <- function(x, value) UseMethod("port<-", x)
`preview<-` 	<- function(x, value) UseMethod("preview<-", x)
`size<-`        <- function(x, value) UseMethod("size<-", x)
`to<-`          <- function(x, value) UseMethod("to<-", x)
`user<-`        <- function(x, value) UseMethod("user<-", x)

port 		<- function(x, ...) {
	if (missing(x)) return(.Call(C_port))
	UseMethod("port", x)
}

desc <- function(x, ...) UseMethod("desc", x)

desc.default <- function(x, ...) {
	typelist <- c("process", "chunk")
	stopifnot(x %in% typelist)

	desc <- rediscc::redis.inc(getCommsConn(), x)
	desc
}

# masking
args		<- function(...) UseMethod("args", ..1)
args.default	<- function(...) base::args(...)
table		<- function(...) UseMethod("table", ..1)
table.default	<- function(...) base::table(...)
nrow		<- function(x) UseMethod("nrow", x)
nrow.default	<- function(x) base::nrow(x)
ncol		<- function(x) UseMethod("ncol", x)
ncol.default	<- function(x) base::ncol(x)
colnames	<- function(x, ...) UseMethod("colnames", x)
colnames.default<- function(x, ...) base::colnames(x, ...)
