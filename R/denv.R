denvref <- function(target)
        structure(do.dcall(benv(function(null)
                                   structure(new.env(parent=baseenv()),
                                             class="denv")), list(target)),
                  class=c("denvref", class(target)))

is.denvref <- function(x) inherits(x, "denvref")
is.denv <- function(x) inherits(x, "denv")

# vars is to be a named list of additional variables to send, with said names
# corresponding to names in expr
with.dref <- function(data, expr, vars=list(), result=TRUE) {
        stopifnot(is.list(vars), length(names(vars)) == length(vars))
        wfun <- as.function(c(alist(data=),
                                structure(rep(alist(placeholder=), length(vars)),
                                          names=names(vars)),
                                substitute({
                                        n <- sys.nframe()
                                        e <- sys.frame(n)
                                        p <- parent.env(data)
                                        parent.env(data) <- e
                                        out <- with(data, expr)
                                        parent.env(data) <- p
                                        out
                                },
                                list(expr=substitute(expr)))))
        do.dcall(benv(wfun), c(list(data), vars), store=result)
}
