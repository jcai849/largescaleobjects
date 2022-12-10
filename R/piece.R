index <- function(x, i, ...) UseMethod("index", i)
index.numeric <- function(x, i, ...) {
	stopifnot(is.DistributedObject(x))
	x <- chunkReferenceArray(x)
	chunk_dims <- emerge(d(dim)(x))
	stopifnot(identical(dim(chunk_dims), dim(x)))
	margins <- seq(length(dim(dims))))
	
	accum_dims <- lapply(margins, function(margin) {
		cumsum(apply(chunk_dims, margin, function(s) apply(s, margin, sum)))
	})
	gi <- gen_indices(i, accum_dims)
	stopifnot(identical(dim(gi), dim(x)))
	
	DistributedObject(send_indices(x, gi))
}
gen_indices <- function(i, accum_dims) NULL
send_indices <- function(x, i) NULL

prune <- function(x) {
	DistributedObject(chunkReferenceArray(x)[emerge(do.dcall(function(x) NROW(x) == 0L, list(x)))])
}

align <- function(x, y) NULL

#utils
#dim.DistributedObject
#head.DistributedObject
#length.DistributedObject
#nrow.DistributedObject
#NROW.DistributedObject
#object.size.DistributedObject
#ncol.DistributedObject
#colnames.DistributedObject
#names.DistributedObject
