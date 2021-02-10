metadata <- function(preview, size) {
	x <- list(preview = preview, size = size)
	class(x) <- "metadata"
	x
}

print.metadata <- function(x) {
	cat("metadata of some chunk:\n")
	cat("\tpreview:\n"); print(preview(x))
	cat("\tsize:\n"); print(size(x))
}

preview.metadata <- function(x) x$metadata
size.metadata <- function(x) x$size
