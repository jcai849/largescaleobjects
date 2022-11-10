library(largescaler)

PATHS <- list.files("/course/data/airline/full", full.names=TRUE)

orcv::start()
init_locator("localhost", 9000L)
init_worker("localhost", 9001L)
init_worker("localhost", 9002L)
init_worker("localhost", 9003L)
init_worker("localhost", 9004L)
init_worker("localhost", 9005L)
init_worker("localhost", 9006L)
init_worker("localhost", 9007L)
#mapply(init_worker, "localhost", seq(9001L, length.out=6))

lairline <- read.csv(PATHS[length(PATHS)], nrows=1000)
colClasses <- vapply(lairline, class, character(1))

dairline <- read.dcsv(PATHS, header=T, colClasses=colClasses)

emerge(dplyr::summarise(dplyr::group_by(dairline, Dest), dplyr::n()))
