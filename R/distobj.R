emerge <- function(x) {
	do.call(unclass(x)$combination, lapply(unclass(x)$chunks, largerscale::pull))
}

Math.DistributedObject <- function(x, ...) 
	do.dcall(.Generic, c(list(x=x), list(...)))

Ops.DistributedObject <- function(e1, e2) 
	if (missing(e2)) { do.dcall(.Generic, list(e1=e1)) 
	} else             do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.DistributedObject <- function(z) 
	do.dcall(.Generic, list(z=z))

Summary.DistributedObject <- function(..., na.rm = FALSE) {
	mapped <- emerge(do.dcall(.Generic, c(list(...), list(na.rm=na.rm))))
	do.call(.Generic, c(list(mapped), list(na.rm=na.rm)))
}

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
	emerge(do.dcall("table", list(...), combination=combine.table))

subset.DistributedObject <- function(x, subset, ...)
	do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.DistributedObject <- function(x) {
	dims <- emerge(do.dcall("dim", list(x=x)))
	c(sum(dims[1,]), dims[,1][-1])
}

size <- function(measure) function(x) sum(do.dcall(measure, x))
length.DistributedObject <- size(length)
nrow.DistributedObject <- size(nrow)

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
