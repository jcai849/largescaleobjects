ncache <- local(function() {
			nc <- get0("nc", -2, inherits=FALSE)
			if (is.null(nc)) {
				nc <- cache(mutable=TRUE)
				class(nc) <- c("ncache", class(nc))
				msg(nc) <- msg()
				chunk(nc) <- chunk()
				log(nc) <- log()
				nc <<- nc
			}
			nc
})

ncget <- function(what, conninit, ...) {
	ncx <- ncache()[[what]]
	if (is.null(ncx)) {
		ncx <- ncache()[[what]] <- cache(mutable=TRUE)
		class(ncx) <- c("loc", class(ncx))
	} else if (is.null(conn(ncx)) &&
		   !is.null(host(ncx))
		   !is.null(host(ncx))) {
		conn(ncx) <- conninit(host(ncx), port(ncx), ...)
	}
	ncx
}
