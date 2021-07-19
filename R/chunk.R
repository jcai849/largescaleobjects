# Instantiate

chunkRef.default <- function(x, ...)  {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkRef"
	desc(cs) <- x 
	reg.finalizer(cs, delete)
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
delete.chunkRef <- function(x, ...) {
	goodcleanfun <- function(xd) {
		rm(list=xd, pos=largeScaleR::getChunkStore())
		gc()
		osrv::ask(paste0("DEL ", xd, "\n"))
	}
	do.ccall(envBase(goodcleanfun),
		 args=list(as.character(desc(x))), target=x, store=FALSE)
	rm(list=ls(x), pos=x)
	invisible(NULL)
}
