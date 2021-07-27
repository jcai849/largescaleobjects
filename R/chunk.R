chunk <- function(x) {
	if (missing(x)) {
		nc <- ncache()$chunk
		if (is.null(nc))
			ncache()$chunk <- cache(mutable=TRUE)
		return(nc)}
	else UseMethod("chunk", x)
}
`chunk<-`<- function(x, value) UseMethod("chunk<-", x)

chunk.character <- function(x) get(x, chunk())
chunk.cdesc <- chunk.numeric <- function(x) chunk(as.character(x))

`chunk<-.character` <- function(x, value) {chunk()[[x]] <- value; x}
`chunk<-.cdesc` <- `chunk<-.numeric` <- function(x, value) {
	x <- as.character(x)
	chunk(x) <- value
}
