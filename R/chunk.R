chunk <- function(x) {
	if (missing(x)) {
		ncc <- ncget("chunk", start)
		nccs <- cstore(ncc)
		if (is.null(nccs)) {
			nccs <- cache(mutable=TRUE)
			class(nccs) <- c("cstore", class(nccs))
			chunk(ncc) <- nccs
		} return(nccc)
	} else UseMethod("chunk", x)
}
`chunk<-`<- function(x, value) UseMethod("chunk<-", x)

chunk.character <- function(x) get(x, chunk())
chunk.cdesc <- chunk.numeric <- function(x) chunk(as.character(x))
chunk.cache <- function(x) x$chunk

`chunk<-.character` <- function(x, value) {chunk()[[x]] <- value; x}
`chunk<-.cache` <- function(x, value) {x$chunk <- value; x}
`chunk<-.cdesc` <- `chunk<-.numeric` <- function(x, value) {
	x <- as.character(x)
	chunk(x) <- value
}
