# Instantiate

chunkStub.integer <- function(cd)  {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- cd 
	cs
}

root <- function() {
	cs <- new.env()
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	cs
}

# Inherit

is.chunkStub <- function(x) inherits(x, "chunkStub")

# Get

access.chunkStub <- function(field, alt=requestField) {
	function(x) {
	tryCatch(get(field, x, inherits=FALSE), 
		 error = function(e) alt(field, x))
	}
}

desc.chunkStub		<- access.chunkStub("desc")
host.chunkStub		<- access.chunkStub("host")
port.chunkStub		<- access.chunkStub("port")
preview.chunkStub	<- access.chunkStub("preview")
size.chunkStub 		<- access.chunkStub("size")
from.chunkStub 		<- access.chunkStub("from", stop)
to.chunkStub 		<- access.chunkStub("to", stop)

host.default <- function(x) host(getUserProcess())
port.default <- function(x) port(getUserProcess())

# Set

envSet <- function(field) function(x, value)
	{assign(field, value, x); x}
`desc<-.chunkStub`	<- envSet("desc")
`from<-.chunkStub`	<- envSet("from")
`host<-.chunkStub` 	<- envSet("host")
`isEndPosition<-.chunkStub`<- envSet("isEndPosition")
`port<-.chunkStub` 	<- envSet("port")
`preview<-.chunkStub` 	<- envSet("preview")
`cached<-.chunkStub`	<- envSet("cached")
`size<-.chunkStub` 	<- envSet("size")
`to<-.chunkStub` 	<- envSet("to")

# Other methods

print.chunkStub 	<- function(x, ...) {
	cat("Chunk stub with Descriptor", format(desc(x)), "\n")
#	cat(" and size", format(size(x)), 
#	    "\n", "Preview:", "\n")
#	print(preview(x))
#	cat("...\n")
}
