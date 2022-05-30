DistributedObject <- function(chunks) {
	if (inherits(chunks, "ChunkReference")) chunks <- list(chunks) # if single chunk
        stopifnot(is.list(chunks)) 
	chunks <- lapply(chunks, function(x) if (inherits(x, "ChunkReference")) x else largerscale::push(x))
        structure(list(chunks=chunks), class="DistributedObject")
}

as.list.DistributedObject <- function(x, ...) unclass(x)$chunks

emerge <- function(x, ...) UseMethod("emerge", x)

emerge.DistributedObject <- function(x, ...) {
	do.call(combine, lapply(as.list(x), largerscale::pull))
}

emerge.default <- function(x, ...) x

Math.DistributedObject <- function(x, ...) 
	do.dcall(.Generic, c(list(x=x), list(...)))

Ops.DistributedObject <- function(e1, e2) 
	if (missing(e2)) { do.dcall(.Generic, list(e1=e1)) 
	} else             do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.DistributedObject <- function(z) 
	do.dcall(.Generic, list(z=z))

map_reduce <- function(map, reduce) {
	function(..., addl_map_args, addl_reduce_args) {
		mapped <- emerge(do.dcall(map, c(list(...), addl_map_args)))
		do.call(reduce, c(list(mapped), addl_reduce_args)) # reduced
	}
}

Summary.DistributedObject <- function(..., na.rm = FALSE)
	map_reduce(.Generic, .Generic)(..., addl_map_args=list(na.rm=na.rm), addl_reduce_args=list(na.rm=na.rm))

`$.DistributedObject` <- function(x, name)
	do.dcall("$", list(x=x, name=name))

table <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  dnn = list.names(...), deparse.level = 1) UseMethod("table", ..1)
table.default <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  dnn = list.names(...), deparse.level = 1)
	base::table(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  dnn = list.names(...), deparse.level = 1)
table.DistributedObject <- function(...,
		  exclude = if (useNA == "no") c(NA, NaN),
		  useNA = c("no", "ifany", "always"),
		  dnn = list.names(...), deparse.level = 1)
	emerge(do.dcall("table", list(...)))

subset.DistributedObject <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.DistributedObject <- function(x) {
	dims <- emerge(do.dcall("dim", list(x=x)))
	c(sum(dims[1,]), dims[,1][-1])
}

size <- function(measure) function(x) sum(do.dcall(measure, list(x)))
length.DistributedObject <- size(length)
nrow.DistributedObject <- size(nrow)

combine <- function(...) UseMethod("combine", ..1)
combine.default <- function(...) c(...)
combine.data.frame <- function(...) rbind(...)
combine.table <- function(...) {
	tabs <- list(...)
	chunknames <- lapply(tabs, dimnames)
	stopifnot(all(lengths(chunknames) == length(chunknames[[1]])))
	groupedvarnames <- lapply(seq(length(chunknames[[1]])),
			      function(i) lapply(chunknames,
						 function(chunk) chunk[[i]]))
	wholenames <- structure(lapply(groupedvarnames,
		       function(names) sort(unique(do.call(c, names)))),
			  names = names(chunknames[[1]]))
	wholearray <- array(0L, dim = lengths(wholenames, use.names = FALSE),
			    dimnames = wholenames)
	lapply(seq(length(tabs)), function(i)
	       {eval(substitute(wholearray_sub <<- wholearray_sub + tab_chunk, 
		   list(wholearray_sub =  do.call(call, c(list("["),
			x = quote(quote(wholearray)),
			unname(chunknames[[i]]))),
			tab_chunk = substitute(tabs[[i]], list(i = i)))))
	NULL})
	as.table(wholearray)
}

solve.DistributedObject <- function(a, b, ...) {
	a <- emerge(a)
	if (!missing(b)) solve(a=a, b=emerge(b), ...) else solve(a=a, ...)
}
