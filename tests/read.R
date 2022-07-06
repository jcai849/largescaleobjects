library(largescaler)

Sys.sleep(2)

largerscale::LOCATOR("localhost", 8999L)

n_nodes <- 3
df <- iris
colnames(df) <- NULL
iris_split <- split(df, rep(1:n_nodes, each=floor(NROW(df) / n_nodes)))
paths <- tempfile(fileext=rep(".csv", n_nodes))
mapply(write.csv, iris_split, paths, row.names=FALSE)

ddf <- read.dcsv("localhost", paths, col.names=colnames(iris), colClasses=sapply(iris, class))
emerge(ddf)
emerge(do.dcall(identity, list(ddf)))
sum(ddf$Sepal.Length > 5.8)
small_ddf <- subset(ddf, ddf$Sepal.Length <= 5.8)
emerge(small_ddf)
table(small_ddf$Species, small_ddf$Petal.Width)

emerge(dReduce("sum", ddf$Sepal.Length))
emerge(dReduce("sum", ddf$Sepal.Length, init=3, accumulate=T))

unique(emerge(do.dcall(names, list(ddf))))

dnames <- d(names)
unique(emerge(dnames(ddf)))

q("no")
