# cref

length.cref <- function(x) 0L
ncol.cref <- function(x)
        emerge(do.ccall("ncol", list(x), x))
colnames.cref <- function(x, ...)
        emerge(do.ccall("colnames", list(x), x))

# dref

Math.dref <- function(x, ...)
        do.dcall(.Generic, c(list(x=x), list(...)))

Ops.dref <- function(e1, e2)
        if (missing(e2)) {
                do.dcall(.Generic, list(e1=e1))
        } else  do.dcall(.Generic, list(e1=e1, e2=e2))

Complex.dref <- function(z)
        do.dcall(.Generic, list(z=z))

Summary.dref <- function(..., na.rm = FALSE) {
        mapped <- emerge(do.dcall(.Generic,
                                  c(list(...),
                                    list(na.rm=I(na.rm)))))
        do.call(.Generic, c(list(mapped), list(na.rm=na.rm)))
}

`$.dref` <- function(x, name)
        do.dcall("$", list(x=x, name=I(name)))

table.dref <- function(...)
        emerge(do.dcall("table", list(...)))

subset.dref <- function(x, subset, ...)
        do.dcall("subset", c(list(x=x, subset=subset), list(...)))

dim.dref <- function(x) {
        dims <- sapply(cref(do.dcall("dim", list(x=x))), emerge)
        c(sum(dims[1,]), dims[,1][-1])
}

length.dref <- function(x) sum(size(x))
nrow.dref <- function(x) sum(size(x))
ncol.dref <- function(x) ncol(cref(x)[[1]])
colnames.dref <- function(x, ...) colnames(cref(x)[[1]])
cbind.dref <- function(..., deparse.level = 1) do.dcall("cbind", list(...))
rbind.dref <- function(...) combine(...)
c.dref <- function(...) combine(...)
combine.dref <- function(...) {
        chunks <- do.call(c, (lapply(list(...), cref)))
        x <- dref(chunks)
        to(dref) <- NULL
        from(dref) <- NULL
        x
}
object.dsize <- function(x) sum(do.dcall("object.size", list(x)))
combine.default		<- function(...) c(...)
combine.data.frame 	<- function(...) rbind(...)
combine.matrix	 	<- function(...) Reduce('+', list(...))
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
size.default 		<- function(...) length(...)
size.data.frame 	<- function(...) nrow(...)
size.matrix	 	<- function(...) nrow(...)
size.error		<- function(...) NULL

preview.error		<- function(...) identity(...)
preview.default		<- function(...) utils::head(...)
