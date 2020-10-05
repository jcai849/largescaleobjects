getLocal <- function(loc) function(field) get(field, environment(loc))
envGet <- function(field) function(x) get(field, x)
envSet <- function(field) function(x, value) {
	assign(field, value, x)
	x
}

isA <- function(class) function(x) inherits(x, class)

info <- function(...) {
	op <- options(digits.secs = 6)
	if (verbose()) do.call(cat, c(if (!is.null(myNode()))
				      c("[",myNode(),"]") else NULL,
				      format(Sys.time(), "%H:%M:%OS6"),
				      list(...), "\n"))
	options(op)
}

combine.default 	<- c
combine.data.frame 	<- rbind
size.default 		<- length
size.data.frame 	<- nrow

# Testing

addTestChunk <- function(name, contents) {
	ck <- makeTestChunk(name, contents)
	addChunk(name, contents)
	ck
}

makeTestChunk <- function(name, contents, 
			  host=Sys.info()["nodename"], port=integer()) {
	ck		<- structure(new.env(), class = "chunkRef")
	chunkID(ck)	<- structure(name, class="chunkID")
	preview(ck)	<- contents
	from(ck)	<- contents[1]
	to(ck)		<- contents[length(contents)]
	size(ck)	<- length(contents)
	resolution(ck)	<- "RESOLVED"
	host(ck) 	<- host
	port(ck) 	<- port
	ck
}
