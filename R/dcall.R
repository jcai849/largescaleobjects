do.dcall <- function(what, args, size_change=FALSE) {
	aligned <- lapply(args, function(arg) if (inherits(arg, "DistributedObject") unclass(arg)$chunks else arg)
	chunks <- do.call(mapply, list(function(...) largerscale::remote_call(what, list(...)), aligned))
	structure(list(chunks=chunks, size=NA_integer_, combination=c), class="DistributedObject")
}
