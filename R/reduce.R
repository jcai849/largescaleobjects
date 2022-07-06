dReduce <- function(f, x, init, right = FALSE, accumulate = FALSE, ...) {
        DistributedObject(Reduce(dreducable(f, ...), as.list(x), init, right, accumulate))
}

dreducable <- function(f, ...) {
        function(x, y) {
		largerscale::remote_call(f, list(x, y), target=y, ...)
        }
}