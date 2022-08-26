do.dcall <- function(what, args) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	enlisted_args <- lapply(args, function(arg) if (inherits(arg, "DistributedObject")) as.list(arg) else arg),
	aligned <- do.call(mapply, c(list, enlisted_args, SIMPLIFY=FALSE))
	chunks <- chunknet::do.ccall(list(what), aligned)
	DistributedObject(unlist(chunks, recursive=FALSE))
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)
