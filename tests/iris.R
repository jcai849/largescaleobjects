library(largescaler)

Sys.sleep(2)

chunknet::LOCATOR("localhost", 8999L)
orcv::start()

n_nodes <- 3
df <- iris
colnames(df) <- NULL
iris_split <- split(df, rep(1:n_nodes, each=floor(NROW(df) / n_nodes)))
paths <- tempfile(fileext=rep(".csv", n_nodes))
mapply(write.table, iris_split, paths, sep=",", col.names=FALSE, row.names=FALSE)
colClasses <- sapply(iris, class)
colClasses[5] <- "character"
ddf <- read.dcsv(paths, colClasses=colClasses)
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

gc()

emerge(dplyr::select(ddf, Sepal.Length, Sepal.Width))
emerge(dplyr::mutate(ddf, x=sum(Sepal.Length), y=Sepal.Length^2, z=Sepal.Width^2))

rbind(ddf, ddf)

debug(shuffle)
unishuff <- shuffle(ddf, ddf$Sepal.Width, 4)
multishuff <- shuffle(ddf, ddf[,c("Sepal.Width", "Species")], 4)

tidy_table <- dplyr::summarise(dplyr::group_by(ddf, Sepal.Width), dplyr::n())
multi_tidy_table <- dplyr::summarise(dplyr::group_by(ddf, Sepal.Width, Species), dplyr::n())

#chunknet::kill_all_nodes()
#q("no")
