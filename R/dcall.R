do.dcall <- function(what, args) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	aligned <- lapply(args, function(arg) if (inherits(arg, "DistributedObject")) as.list(arg) else arg)
	chunks <- chunknet::do.ccall(what, list(aligned))
	DistributedObject(unlist(chunks, recursive=FALSE))
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)
