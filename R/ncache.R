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
