ncache <- local(function() {
			nc <- get0("nc", -2, inherits=FALSE)
			if (is.null(nc)) {
				nc <- cache(mutable=TRUE)
				class(nc) <- c("ncache", class(nc))
				nc$self <- node()
				nc$msg <- msg()
				nc$chunk <- chunk()
				nc$log <- log()
				nc <<- nc
			}
			nc
})

ncget <- function(what, connfun, ...) {
	ncx <- ncache()[[what]]
	if (is.null(ncx)) {
		ncx <- ncache()[[what]] <- cache(mutable=TRUE)
	} else if (is.null(ncx$conn) &&
		   !is.null(ncx$host) &&
		   !is.null(ncx$port)) {
		ncx$conn <- connfun(ncx$host, ncx$port, ...)
	}
	ncx
}
