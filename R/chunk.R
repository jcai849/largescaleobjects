chunk <- function(x) {
	if (!missing(x)) {
		UseMethod("chunk", x)
	} else {
		lstore("chunk", start)
	}
}
`chunk<-` <- function(x, value) UseMethod("chunk<-", x)

chunk.character <- function(x) emerge(x)
chunk.cdesc <- chunk.numeric <- function(x) chunk(as.character(x))

`chunk<-.character` <- function(x, value) {cstore()[[x]] <- value; x}
`chunk<-.cdesc` <- `chunk<-.numeric` <- function(x, value)
	{ x <- as.character(x); chunk(x) <- value; x }

root <- function() 
	tryCatch(chunk("/"),
		 error=function(e) chunk("/") <- dref("/"))
