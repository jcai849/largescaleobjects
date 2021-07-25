# Instantiate

chunkRef.default <- function(x, ...)  {
	cs <- new.env(TRUE, emptyenv())
	class(cs) <- "chunkRef"
	desc(cs) <- x 
	reg.finalizer(cs, delete)
	cs
}

root <- function() {
	if (is.null(r <- get0("/", envir=.largeScaleRConn)))
		assign("/", (r <- chunkRef("/")), pos=.largeScaleRConn)
	return(r)
}

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
	if (is.null(desc(x))) return()
	clean <- function(xd) {
		rm(list=xd, pos=largeScaleR::getChunkStore())
		#stateLog(paste("DEL", desc(getUserProcess()), xd))
		gc()
	}
	do.ccall(envBase(clean),
		 args=list(as.character(desc(x))), target=x, store=FALSE)
	osrv::ask(paste0("DEL ", as.character(desc(x)), "\n"),
		  host=host(x), port=port(x), sfs=TRUE)
	rm(list=ls(x), pos=x)
	return()
}
