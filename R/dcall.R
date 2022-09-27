do.dcall <- function(what, args) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	prealigned_args <- lapply(args, prealign)
	aligned_args <- do.call(mapply, c(list, prealigned_args, SIMPLIFY=FALSE, USE.NAMES=FALSE))
	chunks <- chunknet::do.ccall(rep(list(what), length(aligned_args)), aligned_args)
	DistributedObject(chunks)
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)

prealign <- function(x, ...) UseMethod("prealign", x)
prealign.default <- function(x, ...) x
prealign.DistributedObject <- function(x, ...) as.list(x)
prealign.AsIs <- function(x, ...) list(unAsIs(x))
unAsIs <- function(x) {
	class(x) <- setdiff(oldClass(x), "AsIs")
	x
}
