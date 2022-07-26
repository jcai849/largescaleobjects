do.dcall <- function(what, args) {
	if (inherits(args, "DistributedObject")) stop("Requires list for argument, not distributed object")
	aligned <- lapply(args, function(arg) if (inherits(arg, "DistributedObject")) as.list(arg) else arg)
	chunks <- do.call(mapply, c(list(function(...) chunknet::remote_call(what, list(...), post_locs=FALSE)),
				    aligned,
				    list(SIMPLIFY=FALSE, USE.NAMES=FALSE)))
	post_locations(sapply(chunk, '$', "href"), sapply(chunk, '$', "init_loc"))
	DistributedObject(chunks)
}

d <- function(what) function(...) do.dcall(what, args=list(...))
# e.g. d.model.matrix <- d(model.matrix); d.model.matrix(object=~ a + b, dd)
