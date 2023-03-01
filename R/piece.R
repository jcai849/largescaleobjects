index <- function(x, i, ...) UseMethod("index", i)
index.numeric <- function(x, i, ...) {
	stopifnot(is.DistributedObject(x))
	x <- chunkReferenceArray(x)
	chunk_dims <- emerge(d(dim)(x))
	stopifnot(identical(dim(chunk_dims), dim(x)))

	gi <- gen_indices(i, accumulated_dims(chunk_dims))
	stopifnot(identical(dim(gi), dim(x)))
	
	DistributedObject(prune(send_indices(x, gi)))
}
accumulated_dims <- function(chunk_dims) UseMethod("accumulated_dims", chunk_dims)
accumulated_dims.array <- function(chunk_dims) {
	margins <- seq(length(dim(chunk_dims)))
	lapply(margins, function(margin)
		cumsum(apply(chunk_dims, margin,
			     function(s) apply(s, margin, sum)))
	)
}
gen_indices <- function(i, accum_dims) {
	which.max(accum_dims[-1] < i & i < accum_dims) # something like this... maybe using that geographical routine?
}
send_indices <- function(x, gi) {
	ChunkReferenceArray(mapply(function(x, gi) do.ccall(list('['),
			           list(list(x, gi))), x, gi))
}

prune <- function(x) {
	DistributedObject(chunkReferenceArray(x)[emerge(do.dcall(function(x) NROW(x) == 0L, list(x))), drop=FALSE])
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
