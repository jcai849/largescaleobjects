do.dcall <- function(what, args, size_change=FALSE) {
	dist_obj_args <- sapply(args, inherits, "DistributedObject")
	args[!dist_obj_args] <- lapply(args[!dist_obj_args], split, args[dist_obj_args][1])
	chunks <- lapply(seq(length(args[[1]]$chunks)),
			 function(i) largerscale::remote_call(what,
							      lapply(args, function(arg) arg$chunks[[i]]))
	structure(list(chunks=chunks, size=NA_integer_, combination=c), class="DistributedObject")
}
