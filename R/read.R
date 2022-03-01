read.dcsv <- function(hosts, paths) {
	chunks <- mapply(largerscale::push, paths, hosts)
	do.dcall(read.csv, structure(list(chunks=chunks), class="DistributedObject")
}
