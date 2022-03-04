library(largescaler)

largerscale::LOCATOR("localhost", 8989L)

n_nodes <- 3
df <- iris
colnames(df) <- NULL
iris_split <- split(df, rep(1:n_nodes, each=floor(NROW(df) / n_nodes)))
paths <- tempfile(fileext=rep(".csv", n_nodes))
mapply(write.csv, iris_split, paths, row.names=FALSE)

ddf <- read.dcsv("localhost", paths, col.names=colnames(iris), colClasses=sapply(iris, class))
emerge(do.dcall(identity, list(ddf)))

#sum(ddf$Sepal.Length > 5.8)
#small_ddf <- subset(ddf, ddf$Sepal.Length <= 5.8)
#table(small_ddf$Species, small_ddf$Petal.Width)
