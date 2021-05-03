# Instantiate

chunkRef.integer <- function(x, ...)  {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkRef"
	desc(cs) <- x 
	cs
}

root <- function() {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkRef"
	desc(cs) <- "/" 
	cs
}

# Inherit

is.chunkRef <- function(x) inherits(x, "chunkRef")

# Other methods

print.chunkRef 	<- function(x, ...) {
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")
#	cat(" and size", format(size(x)), 
#	    "\n", "Preview:", "\n")
#	print(preview(x))
#	cat("...\n")
}

ncol.chunkRef <- function(x)
	emerge(do.call.chunkRef("ncol", list(x), x))
colnames.chunkRef <- function(x, ...)
	emerge(do.call.chunkRef("colnames", list(x), x))
