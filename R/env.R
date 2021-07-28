benv <- function(x) {
	if (missing(x)) return(baseenv())
        if (!is.null(x)) attr(x, ".Environment") <- baseenv()
        x
}

currCallFun <- function(n=0) { 
	cl <- sys.call(n-1)
	as.function(c(alist(...=), call("quote", cl)))
}
