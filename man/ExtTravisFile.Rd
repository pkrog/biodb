% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ExtTravisFile.R
\name{ExtTravisFile}
\alias{ExtTravisFile}
\title{Extension Travis YAML file generator class}
\description{
A class for generating a .travis.yml file for a new extension package.
}
\details{
Write a .travis.yml file inside the package directory, using a template file.
}
\examples{
# Generate a new package:
pkgFolder <- file.path(tempfile(), 'biodbFoo')
dir.create(pkgFolder, recursive=TRUE)
biodb::ExtTravisFile$new(path=pkgFolder, email='myname@e.mail')$generate()

}
\section{Super classes}{
\code{\link[biodb:ExtGenerator]{biodb::ExtGenerator}} -> \code{\link[biodb:ExtFileGenerator]{biodb::ExtFileGenerator}} -> \code{ExtTravisFile}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{ExtTravisFile$new()}}
\item \href{#method-clone}{\code{ExtTravisFile$clone()}}
}
}
\if{html}{
\out{<details open ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="biodb" data-topic="ExtGenerator" data-id="generate">}\href{../../biodb/html/ExtGenerator.html#method-generate}{\code{biodb::ExtGenerator$generate()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="biodb" data-topic="ExtGenerator" data-id="upgrade">}\href{../../biodb/html/ExtGenerator.html#method-upgrade}{\code{biodb::ExtGenerator$upgrade()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Initializer.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ExtTravisFile$new(...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{...}}{See the constructor of ExtFileGenerator for the parameters.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
Nothing.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ExtTravisFile$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
