distObj::beginNZSA2020Demo()

flights <- do.call.distObjRef("read.csv", 
			      list(file		= fileNames,
				   header	= FALSE,
				   col.names	= names(cols),
				   colClasses	= as.vector(cols)))

# anonfun
sanOrig <- do.call.distObjRef(function(df) df$Origin == "SAN", 
			      list(df = flights))

sanOrigCounts <- emerge(do.call.distObjRef("sum", list(sanOrig)))

sanOrigCount <- sum(sanOrigCounts)

# table

table(flights$Origin, flights$Dest)

# lm

lm(Distance ~ Year, data = flights)

# (later) recycling local objects

# ending through a 'quit'

do.call.distObjRef(function(x) q("no"),
		   list(x = flights))
