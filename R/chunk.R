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

# Other methods

print.chunkStub 	<- function(x, ...) {
	cat("Chunk stub with Descriptor", format(desc(x)), "\n")
#	cat(" and size", format(size(x)), 
#	    "\n", "Preview:", "\n")
#	print(preview(x))
#	cat("...\n")
}
