\name{init_locator}
\alias{init_locator}
\alias{init_worker}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Remote initialisation of node types
}
\description{
Remotely initialise a worker or locator node.
}
\usage{
init_locator(host, port)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{host}{
Scalar character naming the host to initialise the node on.
}
  \item{port}{
Scalar integer declaring the port to bind to. Can be 0L if unknown.
}
}
\details{
Initialises a worker node, or a locator node.
}
\value{
None
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
function (host, port) 
{
    chunknet::LOCATOR(host, port)
    remote_sys(host, "chunknet::locator_node", list(host, port))
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
