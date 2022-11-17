do.dcall <- function(what, args, balance=FALSE) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	prealigned_args <- lapply(args, prealign)
	aligned_args <- do.call(mapply, c(list, prealigned_args, SIMPLIFY=FALSE, USE.NAMES=FALSE))
	chunks <- chunknet::do.ccall(rep(list(what), length(aligned_args)), aligned_args, balance=balance)
	DistributedObject(chunks)
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)

prealign <- function(x, ...) UseMethod("prealign", x)
prealign.default <- function(x, ...) list(x) 
prealign.DistributedObject <- function(x, ...) as.list(x)
prealign.RecyclesWithChunks <- function(x, ...) unclass_RWC(x)
RecyclesWithChunks <- function(x, ...) {
	class(x) <- unique.default(c("RecyclesWithChunks", oldclass(x)))
	x
}
unclass_RWC <- function(x) {
	class(x) <- setdiff(oldClass(x), "RecyclesWithChunks")
	x
}
