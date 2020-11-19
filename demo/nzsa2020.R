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

dateTab <- table(flights$Month, flights$Year)
dateTab

allFlights <- as.integer(dateTab[order(as.integer(rownames(dateTab))),])
nFlights <- ts(allFlights[allFlights > 0], start=c(1987, 10), frequency=12)
dygraphs::dyRangeSelector(dygraphs::dygraph(nFlights,
				    main = "Monthly Commercial Flights in USA",
				    xlab = "Count",
				    ylab = "Time"))

moveTab <- table(flights$Origin, flights$Dest)
moveTab
bigMoves <- moveTab[rowSums(moveTab) > 3E6, colSums(moveTab) > 3E6]
X11(type="cairo")
circlize::chordDiagram(bigMoves)

killAt(flights)
clear()
