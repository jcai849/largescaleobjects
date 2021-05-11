splx <- split(lx, cut(seq(length(lx)), breaks=8))
sum_map <- do.call("sum", splx)
reduced <- sum(sum_map)

sum_dmap <- do.dcall("sum", dx)
dreduced <- sum(emerge(sum_dmap))

sum(dx)
