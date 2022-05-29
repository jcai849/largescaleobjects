do.dcall <- function(what, args) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	aligned <- lapply(args, function(arg) if (inherits(arg, "DistributedObject")) unclass(arg)$chunks else arg)
	chunks <- do.call(mapply, c(list(function(...) largerscale::remote_call(what, list(...))),
				    aligned,
				    list(SIMPLIFY=FALSE, USE.NAMES=FALSE)))
	structure(list(chunks=chunks), class="DistributedObject")
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)
