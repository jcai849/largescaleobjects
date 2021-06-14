# Instantiate

chunkRef.default <- function(x, ...)  {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkRef"
	desc(cs) <- x 
	cs
}

root <- function() chunkRef("/")

# Inherit

is.chunkRef <- function(x) inherits(x, "chunkRef")

# Other methods

print.chunkRef 	<- function(x, ...)
	cat("Chunk Reference with Descriptor", format(desc(x)), "\n")

length.chunkRef <- function(x) 0L
ncol.chunkRef <- function(x)
	emerge(do.ccall("ncol", list(x), x))
colnames.chunkRef <- function(x, ...)
	emerge(do.ccall("colnames", list(x), x))
