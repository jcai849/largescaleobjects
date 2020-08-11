parseFileLoc <- function(fileLoc) {
	matchIndices <- regexec("([^:]+):(.*)", fileLoc)
	matches <- regmatches(fileLoc, matchIndices)
	splitTable <- do.call(rbind,
			      lapply(matches, `[`, c(2L, 3L)))
	colnames(splitTable) <- c("host", "filePath")
	as.data.frame(splitTable)
}
