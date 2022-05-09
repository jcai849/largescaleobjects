do.dcall <- function(what, args, size_change=FALSE) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	aligned <- lapply(args, function(arg) if (inherits(arg, "DistributedObject")) unclass(arg)$chunks else arg)
	chunks <- do.call(mapply, c(list(function(...) largerscale::remote_call(what, list(...))),
				    aligned,
				    list(SIMPLIFY=FALSE, USE.NAMES=FALSE)))
	structure(list(chunks=chunks, size=NA_integer_), class="DistributedObject")
}

d <- function(what, size_change=FALSE) function(...) do.dcall(what, args=list(...), size_change=size_change)
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)
