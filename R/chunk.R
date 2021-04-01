# Instantiate

chunkStub.integer <- function(x, ...)  {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkStub"
	desc(cs) <- x 
	cs
}

root <- function() {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkStub"
	desc(cs) <- "/" 
	cs
}

# Inherit

is.chunkStub <- function(x) inherits(x, "chunkStub")

# Other methods

print.chunkStub 	<- function(x, ...) {
	cat("Chunk stub with Descriptor", format(desc(x)), "\n")
#	cat(" and size", format(size(x)), 
#	    "\n", "Preview:", "\n")
#	print(preview(x))
#	cat("...\n")
}

ncol.chunkStub <- function(x)
	unstub(do.call.chunkStub("ncol", list(x), x))
colnames.chunkStub <- function(x, ...)
	unstub(do.call.chunkStub("colnames", list(x), x))
