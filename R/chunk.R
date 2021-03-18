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

access.chunk <- function(field, alt=requestfield) {
	function(x) {
	tryCatch(get(field, x, inherits=FALSE), 
		 error = function(e) alt(field, x))
	}
}
requestField.chunk <- function(field, x) {
	do.call.chunkStub(function(x, xStub, field) {
				  send(get(field)(x),
				       paste0(field, desc(xStub)))
		 },
		 list(x, I(x), I(field)), 
		 save=FALSE)
	response <- receive(paste0(field, desc(x)))
	eval(substitute(field(x) <- response, 
		   list(field=str2lang(field))))
}

desc.chunkStub		<- access.chunk("desc")
host.chunkStub		<- access.chunk("host")
port.chunkStub		<- access.chunk("port")
preview.chunkStub	<- access.chunk("preview")
size.chunkStub 		<- access.chunk("size")
from.chunkStub 		<- access.chunk("from", stop)
to.chunkStub 		<- access.chunk("to", stop)

host.default <- function(x) host(getUserProcess())
port.default <- function(x) port(getUserProcess())

# Set

`desc<-.chunkStub`	<- largeScaleR:::envSet("desc")
`from<-.chunkStub`	<- largeScaleR:::envSet("from")
`host<-.chunkStub` 	<- largeScaleR:::envSet("host")
`isEndPosition<-.chunkStub`<- largeScaleR:::envSet("isEndPosition")
`port<-.chunkStub` 	<- largeScaleR:::envSet("port")
`preview<-.chunkStub` 	<- largeScaleR:::envSet("preview")
`cached<-.chunkStub`	<- largeScaleR:::envSet("cached")
`size<-.chunkStub` 	<- largeScaleR:::envSet("size")
`to<-.chunkStub` 	<- largeScaleR:::envSet("to")

# Other methods

format.chunkStub	<- function(x, ...) {
	paste("Chunk Stub", format(desc(x)))
}

print.chunkStub 	<- function(x, ...) {
	cat("Chunk stub with Descriptor", format(desc(x)))
	cat(" and size", format(size(x)), 
	    "\n", "Preview:", "\n")
	print(preview(x))
	cat("...\n")
}
