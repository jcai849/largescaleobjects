################################# Populate  ################################

access.chunkStub <- function(field, alt=requestField) {
	function(x) {
	tryCatch(get(field, x, inherits=FALSE), 
		 error = function(e) alt(field, x))
	}
}

requestField.chunkStub <- function(field, x) {
	commQueue <- paste0(field, desc(x))
	fieldSym <- str2lang(field)
	request <- substitute(
			do.call.chunkStub(what=function(x)
					  send(fieldSym=fieldSym(x), 
					       loc=commQueue),
					  args=list(x=x),
					  target=x,
					  store=FALSE),
			list(fieldSym = fieldSym,
			     commQueue = commQueue ))
	names(request$what[[3]])[2] <- field # parse tree hack
	eval(request)
        response <- receive(commQueue)
        eval(substitute({
		fieldSym(x) <- fieldSym(response)
		fieldSym(response)},
		list(fieldSym = fieldSym)))
}

fillMetaData.distObjStub <- function(x) {size(x); to(x); from(x); return()}
fillMetaData.default <- identity

################################# Get  ################################

distObjDo <- function(fun, rtype) function(x) vapply(chunkStub(x), fun, rtype(1))

desc.chunkStub		<- access.chunkStub("desc")
from.chunkStub 		<- access.chunkStub("from", stop)
host.chunkStub		<- access.chunkStub("host")
host.default 		<- function(x) host(getUserProcess())
port.chunkStub		<- access.chunkStub("port")
preview.chunkStub	<- access.chunkStub("preview")
port.default 		<- function(x) port(getUserProcess())
size.chunkStub 		<- access.chunkStub("size")
size.distObjStub 	<- distObjDo(size, integer)
to.chunkStub 		<- access.chunkStub("to", stop)
to.distObjStub		<- function(x) 
	tryCatch(distObjDo(to, integer)(x),
		 error = function(e) {
			 to(x) <- cumsum(size(x))
			 to(x)
		 })
from.distObjStub 	<- function(x)
	tryCatch(distObjDo(from, integer)(x),
		 error = function(e) {
			 from(x) <- c(1L, to(x)[-length(to(x))] + 1L)
			 from(x)
		 })

################################# Set ################################

distObjSet <- function(fun) function(x, value) {
	mapply(fun, chunkStub(x), value)
	x
}

envSet <- function(field) function(x, value)
	{assign(field, value, x); x}

`cached<-.chunkStub`	<- envSet("cached")
`chunkStub<-.distObjStub`<- function(x, value) {assign("chunk", value, x); x}
`desc<-.chunkStub`	<- envSet("desc")
`from<-.chunkStub`	<- envSet("from")
`from<-.distObjStub`	<- distObjSet(`from<-`)
`host<-.chunkStub` 	<- envSet("host")
`isEndPosition<-.chunkStub`<- envSet("isEndPosition")
`port<-.chunkStub` 	<- envSet("port")
`preview<-.chunkStub` 	<- envSet("preview")
`size<-.chunkStub` 	<- envSet("size")
`to<-.chunkStub` 	<- envSet("to")
`to<-.distObjStub`	<- distObjSet(`to<-`)
