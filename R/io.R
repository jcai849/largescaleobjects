dist.read.csv <- function(files) {
	fileLoc <- parseFileLoc(files)
	hosts <- fileLoc$host; filePaths <- fileLoc$filePath
	nodes <- attainNodes(hosts)
	distFilePaths <- send(filePaths, nodes)
	dist.do.call(read.csv, argsDist = list(distFilePaths), argsStatic = list(), assign = TRUE)
}
