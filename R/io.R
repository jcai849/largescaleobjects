dist.read.csv <- function(files) {
	URI <- parseURI(files)
	hosts <- URI$host; filepaths <- URI$filepath
	nodes <- attainNodes(hosts)
	distFilePaths <- send(filepaths, nodes)
	dist.do.call(read.csv, argsDist = list(distFilePaths), argsStatic = list(), assign = TRUE)
}
