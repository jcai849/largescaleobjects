# Local
###### SPLIT
lsplit <- split(lx, cut(seq(length(lx)), breaks=8))
str(lsplit)
###### MAP
lmap <- lapply(lsplit, sum)
str(lmap)
###### EMERGE
lemerged <- as.vector(do.call("c", lmap))
print(lemerged)
###### REDUCE
lreduced <- sum(lemerged)
print(lreduced)

# Distributed
###### MAP
dmap <- do.dcall("sum", list(dx))
preview(dmap)
###### EMERGE
demerged <- emerge(dmap)
print(demerged)
###### REDUCE
dreduced <- sum(demerged)
print(dreduced)

###### ALL-IN-ONE
sum(dx)
