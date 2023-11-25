\name{do.dcall}
\alias{do.dcall}
\alias{d}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Execute a call over a distributed object.
}
\description{
Abstract function application for a distributed object.
}
\usage{
do.dcall(what, args, balance = FALSE)
d(what)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{what}{
Function to apply.
}
  \item{args}{
List of arguments, including distributed objects.
}
  \item{balance}{
Logical, to balance results over cluster.
}
}
\details{
\code{do.dcall} asynchronously requests the function application over a distributed object, with the remote nodes taking care of argument location and transfers.
\code{d} wraps \code{do.dcall}, returning a distributed function.
}
\value{
\item{d}{Returns a distributed version of the input function. Function application returns a DistributedObject.}
\item{do.dcall}{DistributedObject.}
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\seealso{
\code{\link{emerge}}
}
\examples{

d.model.matrix <- d(model.matrix)
d.model.matrix(object=~ a + b, dd)

##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (what, args, balance = FALSE) 
{
    if (inherits(args, "DistributedObject")) 
        stop("Requires list for argument, not distributed object")
    prealigned_args <- lapply(args, prealign)
    aligned_args <- do.call(mapply, c(list, prealigned_args, 
        SIMPLIFY = FALSE, USE.NAMES = FALSE))
    chunks <- chunknet::do.ccall(rep(list(what), length(aligned_args)), 
        aligned_args, balance = balance)
    DistributedObject(chunks)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
