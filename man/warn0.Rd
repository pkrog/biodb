% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fcts_biodb.R
\name{warn0}
\alias{warn0}
\title{Throw a warning and log it too.}
\usage{
warn0(...)
}
\arguments{
\item{...}{Values to be passed to paste0().}
}
\value{
Nothing.
}
\description{
Throws a warning and logs it too with biodb logger, using paste0().
}
\examples{
# Throws a warning:
tryCatch(biodb::warn0('Index is ', 10, '.'), warning=function(w){w$message})

}
