\name{emerge}
\alias{emerge}
\title{
Pull and reassemble a distributed object locally
}
\description{
Pull and reassemble a distributed object locally
}
\usage{
emerge(x, combiner = TRUE, ...)
emerge.default(x, combiner = TRUE, ...)
emerge.DistributedObject(x, combiner = TRUE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
Object to emerge; S3 method dispatches on.
}
  \item{combiner}{
Logical; run a combiner on the underlying chunks for the distributed object? Optionally pass a combiner function to run on the chunks.
}
  \item{\dots}{
Further arguments passed to methods.
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
Synchronously pull and recreate a distributed object.
If no combiner function provided, and \code{combiner=TRUE}, combine based on the \code{combine} method defined for the chunk classes.
}
\value{
The value of the emerged object, or a list of chunks if \code{combine=FALSE}.
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x, combiner = TRUE, ...) 
UseMethod("emerge", x)
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
