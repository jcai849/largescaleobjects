distObj::beginNZSA2020Demo()

flights <- do.call.distObjRef("read.csv", 
			      list(file		= fileNames,
				   header	= FALSE,
				   col.names	= names(cols),
				   colClasses	= as.vector(cols)))
