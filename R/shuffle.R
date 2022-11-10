# returns "multiset" of partitioned indices of input 
partition <- function(x, k, ...) UseMethod("partition")
partition.default <- function(x, k) {
	as.multiset(lapply(partition(table(x), k), function(i) {
		keys <- names(table(x))[i]
		mode(keys) <- mode(x)
		which(x %in% keys)
	}))
}
partition.table <- function(x, k, ...) {
	if (missing(k)) k <- prod(dim(x))
	partition(as.multiset(x, k), k)
}
partition.Multiset <- function(x, k) {
	for (pass in seq_along(x)[-1]) {
		sums <- distance(x, k)
		largest <- which.max(sums)
		sums[largest] <- -1
		second_largest <- which.max(sums)
		merged <- merge(x[largest], x[second_largest])
		x <- x[-c(largest, second_largest)]
		x <- c(x, merged)
	}
	as.multiset(lapply(x[[1]], function(y) as.integer(names(y))))
}

# multiset: list(list(integer()), list(integer()), ...)
as.multiset <- function(x, k, ...) UseMethod("as.multiset", x)
as.multiset.table <- function(x, k, ...) {
	sub <- vector("list", k)
	sub[[1]] <- integer(1)
	p <- lapply(x, function(y) {sub[[1]] <- y; sub})
	for (i in seq_along(p)) names(p[[i]][[1]]) <- i
	as.multiset(p)
}
as.multiset.list <- function(x, k, ...) structure(x, class="Multiset")

distance <- function(x, k, ...) UseMethod("distance", x)
distance.Multiset <- function(x, k, ...) {
	vapply(x, function(y) {a <- vapply(y, sum, integer(1)); max(a) - min(a)}, integer(1))
}

merge.Multiset <- function(x, y, ...) {
	xx <- vapply(x[[1]], sum, integer(1))
	yy <- vapply(y[[1]], sum, integer(1))
	as.multiset(list(mapply(c, x[[1]][order(xx, decreasing=TRUE)], y[[1]][order(yy)],
                           SIMPLIFY=FALSE, USE.NAMES=FALSE)))
}

'[.Multiset' <- function(x, i, ...) as.multiset(unclass(x)[i])
c.Multiset <- function(...) as.multiset(do.call(c, lapply(list(...), unclass)))

shuffle <- function(X, index, n.chunks) UseMethod("shuffle", X)
shuffle.DistributedObject <- function(X, index, n.chunks=length(as.list(X)), ...) {
	tab <- table(index)
	tnames <- expand.grid(dimnames(tab), KEEP.OUT.ATTRS=FALSE, stringsAsFactors=FALSE)
	keys <- lapply(partition(tab, n.chunks), function(i) tnames[i[tab[i] > 0],])
	subsets <- lapply(keys, function(key) do.dcall(multimatch, list(X, index, key)))
	t_subsets <- do.call(mapply, c(list, lapply(subsets, as.list), SIMPLIFY=FALSE, USE.NAMES=FALSE))
	do.dcall(function(...) combine(list(...)), lapply(t_subsets, DistributedObject))
}

multimatch <- function(X, index, key) {
	if (!is.list(index)) index <- list(index)
	if (!is.list(key)) key <- list(key)
	US <- '\037'
	matches <- do.call(paste, c(index, sep=US)) %in% do.call(paste, c(key, sep=US))
	subset(X, matches)
}
