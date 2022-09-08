dReduce <- function(f, x, init, right = FALSE, accumulate = FALSE, ...) {
	stopifnot(inherits(x, "DistributedObject"))
        DistributedObject(Reduce(dreducable(f, ...), as.list(x), init, right, accumulate))
}

dreducable <- function(f, ...) {
        function(x, y) {
		chunknet::do.ccall(list(f), list(list(x, y)), target=list(y), ...)
        }
}
