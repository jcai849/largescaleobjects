DistributedObject <- function(chunks) UseMethod("DistributedObject", chunks)
DistributedObject.ChunkReferenceArray <- function(chunks) {
	class(chunks) <- c("DistributedObject", oldClass(chunks))
	chunks
}
DistributedObject.ChunkReference <- function(chunks) {
	DistributedObject(chunknet::ChunkReferenceArray(chunks))
}
DistributedObject.list <- function(chunks) {
	chunks <- lapply(chunks, function(x) if (chunknet::is.ChunkReference(x)) x else chunknet::push(x)[[1]])
	DistributedObject(chunknet::ChunkReferenceArray(chunks))
}

ChunkReferenceArray.DistributedObject <- function(chunkrefs, dim) {
	chunkref_base <- unclass(chunkrefs)
	dimension <- if (missing(dim)) base::dim(chunkref_base) else dim
	ChunkReferenceArray(chunkref_base, dim=dimension)
}

DistributedObjectReference <- function(x) UseMethod("DistributedObjectReference", x)
DistributedObjectReference.ChunkReferenceArray <- function(x) {
	class(x) <- c("DistributedObjectReference", oldClass(x))
	x
}
DistributedObjectReference.DistributedObject <- function(x) {
	DistributedObjectReference(ChunkReferenceArray(x))
}
materialise <- function(do) UseMethod("materialise", do)
materialise.DistributedObject <- function(do) DistributedObjectReference(do)
dematerialise <- function(dor) UseMethod("dematerialise", dor)
dematerialise.DistributedObjectReference <- function(dor) DistributedObject(dor)
print.DistributedObjectReference <- function(x, ...) {
	cat("Distributed Object Reference\n")
	cat("Pointing to", length(as.list(x)), "chunks\n")
}

as.list.DistributedObject <- function(x, ...) unclass(x)

emerge <- function(x, combiner=TRUE, ...) UseMethod("emerge", x)
emerge.DistributedObject <- function(x, combiner=TRUE, ...) {
	data_chunks <- chunknet::pull(as.list(x))
	dim(data_chunks) <- dim(materialise(x))
	if (is.function(combiner)) {
		combiner(data_chunks)
	} else if (combiner) {
		combine(data_chunks)
	} else data_chunks
}
emerge.default <- function(x, combiner, ...) x

# TODO: generalise to arbitrary dimension
`[.DistributedObject` <- function(x, i, j, ..., drop=TRUE) {
	if (missing(i) && missing(j)) {
		emerge(x)
	} else if (missing(i)) {
		do.dcall(function(x, j) x[,j], list(x, j))
	} else if (missing(j)) {
		do.dcall(function(x, i) x[i,], list(x, i))
	} else
		do.dcall(function(x, i, j) x[i, j], list(x, i, j))
}

Math.DistributedObject <- function(x, ...) 
	do.dcall(.Generic, c(list(x=x), list(...)))

Ops.DistributedObject <- function(e1, e2) 
	if (missing(e2)) { do.dcall(.Generic, list(e1=e1)) 
	} else             do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.DistributedObject <- function(z) 
	do.dcall(.Generic, list(z=z))

map_reduce <- function(map, reduce) {
	function(..., addl_map_args, addl_reduce_args) {
		mapped <- emerge(do.dcall(map, c(list(...), if (missing(addl_map_args)) NULL else addl_map_args)))
		do.call(reduce, c(list(mapped), if (missing(addl_map_args)) NULL else addl_reduce_args)) # reduced
	}
}

Summary.DistributedObject <- function(..., na.rm = FALSE)
	map_reduce(.Generic, .Generic)(..., addl_map_args=list(na.rm=na.rm), addl_reduce_args=list(na.rm=na.rm))

`$.DistributedObject` <- function(x, name)
	do.dcall("$", list(x=x, name=name))

table <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  deparse.level = 1) UseMethod("table", ..1)
table.default <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"), dnn, deparse.level = 1)
	base::table(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"), deparse.level = 1)
table.DistributedObject <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  deparse.level = 1)
	emerge(do.dcall("table", list(...)))


subset.DistributedObject <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

combine <- function(x, ...) UseMethod("combine", x[[1]])
combine.default <- function(x, ...) {
	combined <- do.call(rbind, apply(x, 1, function(chunks) do.call(cbind, chunks), simplify=F))
	dim(combined) <- dim(combined)[seq_along(dim(x))]
	combined
}
combine.list <- function(x, ...) {
	combined <- do.call(c, x)
	class(combined) <- class(x[[1]])
	combined
}

combine.data.frame <- function(x, ...) do.call(rbind, x)
combine.table <- function(x, ...) {
	chunknames <- lapply(x, dimnames)
	stopifnot(all(lengths(chunknames) == length(chunknames[[1]])))
	groupedvarnames <- lapply(seq(length(chunknames[[1]])),
			      function(i) lapply(chunknames,
						 function(chunk) chunk[[i]]))
	wholenames <- structure(lapply(groupedvarnames,
		       function(names) sort(unique(do.call(c, names)))),
			  names = names(chunknames[[1]]))
	wholearray <- array(0L, dim = lengths(wholenames, use.names = FALSE),
			    dimnames = wholenames)
	lapply(seq(length(x)), function(i)
	       {eval(substitute(wholearray_sub <<- wholearray_sub + tab_chunk, 
		   list(wholearray_sub =  do.call(call, c(list("["),
			x = quote(quote(wholearray)),
			unname(chunknames[[i]]))),
			tab_chunk = substitute(x[[i]], list(i = i)))))
	NULL})
as.table(wholearray)
}

combine.DistributedObject <- function(x, ...) DistributedObject(do.call(c, lapply(x, as.list)))

rbind.DistributedObject <- function(..., deparse.level=1) combine(list(...))
c.DistributedObject <- function(...) combine(list(...))

solve.DistributedObject <- function(a, b, ...) {
	a <- emerge(a)
	if (!missing(b)) solve(a=a, b=emerge(b), ...) else solve(a=a, ...)
}

print.DistributedObject <- function(x, ...) {
	cat("Distributed Object\n")
	cat("Consisting of", length(as.list(x)), "chunks\n")
}

t.ChunkReferenceArray <- function(x) t.default(chunknet::dapply(X, c(1,2), t))

dim.DistributedObject <- function(x) {
	stop("Getting dimension of an arbitrarily shaped distributed object?
	This is way harder than you think, but possible. No time right now.")
}
`dim<-.DistributedObject` <- function(x, value) {
	stop("Setting dimension of an arbitrarily shaped distributed object?
	This is way harder than you think, but possible. No time right now.")
}
