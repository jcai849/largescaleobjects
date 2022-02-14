do.dcall <- function(what, args, quote = FALSE, envir = parent.frame()) {
	#see if any args are already distributed objects
	dist_obj_args <- sapply(args, inherits, "DistributedObject")
	#split up any non-distributed objects according to already distributed
	# make an alignment mask (matrix)
	if (any(dist_obj_args)) {
	}
	#determine alignments
	#send out remote procedure calls for each alignment block
	#return a distributed object
}
