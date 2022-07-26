dReduce <- function(f, x, init, right = FALSE, accumulate = FALSE, ...) {
        DistributedObject(Reduce(dreducable(f, ...), as.list(x), init, right, accumulate))
}

dreducable <- function(f, ...) {
        function(x, y) {
		chunknet::remote_call(f, list(x, y), target=y, ...)
        }
}
