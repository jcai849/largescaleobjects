getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}

isA <- function(class) function(x) inherits(x, class)

is.verbose <- function() get("verbose", envir = .largeScaleRConfig)

is.distributed <- function(x) is.distObjRef(x) | is.chunkRef(x)
is.AsIs <- isA("AsIs")

unAsIs <- function(x) {
	class(x) <- class(x)[!class(x) == "AsIs"]
	x
}

info <- function(...) {
	if (is.verbose()) {
		op <- options(digits.secs = 6)
		tryCatch(cat("[ ", 
			     get("procDesc", envir = .largeScaleRConn),
			     "] "),
			 error=function(e){})
		cat(format(Sys.time(), "%H:%M:%OS6"), " ")
		for (item in list(...)) {
			if (is.vector(item) && length(item) == 1) {
				cat(" ", format(item))
			} else {cat("\n"); print(item)}
		}
		cat("\n")
		options(op)
	}
}

combine.default 	<- c
combine.data.frame 	<- rbind
combine.matrix	 	<- rbind
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
size.default 		<- length
size.data.frame 	<- nrow
size.matrix	 	<- nrow

resolve.default <- function(x, ...) identity

killAt <- function(x) {
	do.call.distObjRef(function(x) q("no"), list(x=x))
	NULL
}
