distObj::beginNZSA2020Demo()

fileNames

flights <- read.csv(file	= fileNames,
		    header	= I(FALSE),
		    col.names	= I(names(cols)),
		    colClasses	= I(as.vector(cols)))
flights

sanOrig <- flights$Origin == "SAN"
sanOrig

sanOrigCounts <- sum(sanOrig, na.rm=TRUE)
sanOrigCounts

moveTab <- table(flights$Origin, flights$Dest)
moveTab
bigMoves <- moveTab[rowSums(moveTab) > 3E6, colsums(moveTab) > 3E6]
circlize::chordDiagram(bigMoves)

# timeseries

killAt(flights)
clear()
