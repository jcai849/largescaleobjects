m <- 20
n <- 50000
N <- 5
A <- matrix(runif(m*n), n, m)
A[,1] <- 1
x_actual <- matrix(0, m)
x_actual[c(1, 3, 14, 15, 9),] <- c(27, 1, 8, 2, 82)
b <- A %*% x_actual

n_nodes <- 3
df <- iris
colnames(df) <- NULL
iris_split <- split(df, rep(1:n_nodes, each=floor(NROW(df) / n_nodes)))
paths <- tempfile(fileext=rep(".csv", n_nodes))
mapply(write.table, iris_split, paths, sep=",", col.names=FALSE, row.names=FALSE)
colClasses <- sapply(iris, class)
colClasses[5] <- "character"
ddf <- read.dcsv(paths, colClasses=colClasses)
cat("Providing Distributed Data Frame 'ddf'\n")

dA <- write_load_matrix(A)
cat("Providing Distributed Matrix 'dA'\n")
db <- write_load_matrix(b)
cat("Providing Distributed Vector 'db'\n")