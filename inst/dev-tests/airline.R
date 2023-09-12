library(largescaleobjects)

PATHS <- list.files("/course/data/airline/full", full.names=TRUE)

orcv::start()
chunknet::LOCATOR("localhost", 8999L)

Sys.sleep(2)

lairline <- read.csv(PATHS[length(PATHS)], nrows=1000)
colClasses <- vapply(lairline, class, character(1))

dairline <- read.dcsv(PATHS, header=T, colClasses=colClasses)

dest_table <- dplyr::summarise(dplyr::group_by(dairline, Dest), dplyr::n())