dReduce <- function(f, x, init, right = FALSE, accumulate = FALSE, ...) {
        DistributedObject(Reduce(dreducable(f, ...), as.list(x), init, right, accumulate))
}

dreducable <- function(f, ...) {
        function(x, y) {
		chunknet::do.ccall(f, list(list(x, y)), target=y, ...)
        }
}
