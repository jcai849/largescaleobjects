ddplyr <- function(FUN) function(.data, ...) do.dcall(FUN, c(.data=list(.data), lapply(as.list(substitute(list(...))[-1]), function(x) bquote(quote(.(x))))))

arrange.DistributedObject <- ddplyr(dplyr::arrange)
filter.DistributedObject <- ddplyr(dplyr::filter)
group_by.DistributedObject <- ddplyr(dplyr::group_by)
mutate.DistributedObject <- ddplyr(dplyr::mutate)
select.DistributedObject <- ddplyr(dplyr::select)
summarise.DistributedObject <- ddplyr(dplyr::summarise)
