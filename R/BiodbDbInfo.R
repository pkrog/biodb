#' A class for describing the characteristics of a database.
#'
#' This class is used by \code{\link{BiodbDbsInfo}} for storing database
#' characteristics, and returning them through the \code{get()} method.
#' This class inherits from \code{\link{BiodbConnBase}}.
#'
#' @seealso Parent class \code{\link{BiodbDbsInfo}} and super class
#' \code{\link{BiodbConnBase}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::newInst()
#'
#' # Get a BiodbDbInfo object for a database:
#' mybiodb$getDbsInfo()$get('comp.csv.file')
#'
#' # Terminate instance.
#' mybiodb$terminate()
#'
#' @import R6
#' @include BiodbConnBase.R
#' @export
BiodbDbInfo <- R6::R6Class("BiodbDbInfo",
inherit=BiodbConnBase
)
