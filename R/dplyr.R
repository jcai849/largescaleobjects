ddplyr <- function(FUN) function(.data, ...) do.dcall(FUN, c(.data=list(.data), as.list(substitute(list(...)))[-1]))

arrange.DistributedObject <- ddplyr(dplyr::arrange)
filter.DistributedObject <- ddplyr(dplyr::filter)
group_by.DistributedObject <- function(.data, ...) {
	shuffled <- shuffle(.data, .data[,sapply(as.list(sys.call())[-(1:2)], deparse)])
	ddplyr(dplyr::group_by)(shuffled, ...)
}
mutate.DistributedObject <- ddplyr(dplyr::mutate)
select.DistributedObject <- ddplyr(dplyr::select)
summarise.DistributedObject <- ddplyr(dplyr::summarise)
