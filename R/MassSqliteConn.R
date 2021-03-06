#' Class for handling a Mass spectrometry database in SQLite format.
#'
#' This is the connector class for a MASS SQLite database.
#'
#' @seealso Super class \code{\link{SqliteConn}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::newInst()
#'
#' # Get path to LCMS database example file
#' lcmsdb <- system.file("extdata", "massbank_extract.sqlite", package="biodb")
#'
#' # Create a connector
#' conn <- mybiodb$getFactory()$createConn('mass.sqlite', url=lcmsdb)
#'
#' # Get an entry
#' e <- conn$getEntry('34.pos.col12.0.78')
#'
#' # Terminate instance.
#' mybiodb$terminate()
#'
#' @import R6
#' @include SqliteConn.R
#' @export
MassSqliteConn <- R6::R6Class('MassSqliteConn',
inherit=SqliteConn,

public=list(
),

private=list(

doGetMzValues=function(ms.mode, max.results, precursor, ms.level) {
    # Overwrites super class' method

    mz <- numeric()

    private$initDb()

    if ( ! is.null(private$db)) {

        # Get M/Z field name
        mzfield <- self$getMatchingMzField()

        if ( ! is.null(mzfield)) {
            mzfield <- private$fieldToSqlId(mzfield)

            # Build query
            query <- private$createMsQuery(mzfield=mzfield, ms.mode=ms.mode,
                ms.level=ms.level, precursor=precursor)
            query$addField(field=mzfield)
            if (max.results > 0)
                query$setLimit(max.results)
            logDebug('Run query "%s".', query$toString())

            # Run query
            df <- self$getQuery(query)
            mz <- df[[1]]
        }
    }

    return(mz)
},

createMsQuery=function(mzfield, ms.mode=NULL, ms.level=0, precursor=FALSE) {

    query <- BiodbSqlQuery$new()
    query$setTable(mzfield)
    query$setDistinct(TRUE)
    query$setWhere(BiodbSqlLogicalOp$new(op='and'))

    if (precursor) {
        query$addJoin(table1='msprecmz', field1='accession', table2=mzfield,
            field2='accession')
        expr <- BiodbSqlBinaryOp$new(lexpr=BiodbSqlField$new(table='msprecmz',
            field='msprecmz'), op='=', rexpr=BiodbSqlField$new(table=mzfield,
            field=mzfield))
        query$getWhere()$addExpr(expr)
    }
    if ( ! is.null(ms.level) && ! is.na(ms.level)
        && (is.numeric(ms.level) || is.integer(ms.level)) && ms.level > 0) {
        query$addJoin(table1='entries', field1='accession',
            table2=mzfield, field2='accession')
        expr <- BiodbSqlBinaryOp$new(lexpr=BiodbSqlField$new(table='entries',
            field='ms.level'), op='=', rexpr=BiodbSqlValue$new(ms.level))
        query$getWhere()$addExpr(expr)
    }
    if ( ! is.null(ms.mode) && ! is.na(ms.mode) && is.character(ms.mode)) {
        query$addJoin(table1='entries', field1='accession',
            table2=mzfield, field2='accession')
        expr <- BiodbSqlBinaryOp$new(lexpr=BiodbSqlField$new(table='entries',
            field='ms.mode'), op='=', rexpr=BiodbSqlValue$new(ms.mode))
        query$getWhere()$addExpr(expr)
    }

    return(query)
},

doSearchMzRange=function(mz.min, mz.max, min.rel.int, ms.mode, max.results,
precursor, ms.level) {

    ids <- character()

    private$initDb()

    if ( ! is.null(private$db)) {

        # Get M/Z field name
        mzfield <- self$getMatchingMzField()

        if ( ! is.null(mzfield)) {
            mzfield <- private$fieldToSqlId(mzfield)
            mzfield <- DBI::dbQuoteIdentifier(private$db, mzfield)

            # Build query
            query <- private$createMsQuery(mzfield=mzfield, ms.mode=ms.mode,
                ms.level=ms.level, precursor=precursor)
            query$addField(table=mzfield, field='accession')
            mz.range.or=BiodbSqlLogicalOp$new('or')
            for (i in seq_along(if (is.null(mz.max)) mz.min else mz.max)) {
                and=BiodbSqlLogicalOp$new('and')
                if ( ! is.null(mz.min) && ! is.na(mz.min[[i]])) {
                    rval <- BiodbSqlValue$new(as.numeric(mz.min[[i]]))
                    expr <- BiodbSqlBinaryOp$new(
                        lexpr=BiodbSqlField$new(table=mzfield,
                        field=mzfield), op='>=', rexpr=rval)
                    and$addExpr(expr)
                }
                if ( ! is.null(mz.max) && ! is.na(mz.max[[i]])) {
                    rval <- BiodbSqlValue$new(as.numeric(mz.max[[i]]))
                    expr <- BiodbSqlBinaryOp$new(
                        lexpr=BiodbSqlField$new(table=mzfield, field=mzfield),
                        op='<=', rexpr=rval)
                    and$addExpr(expr)
                }
                mz.range.or$addExpr(and)
            }
            query$getWhere()$addExpr(mz.range.or)
            if ('peak.relative.intensity' %in% DBI::dbListTables(private$db)
                && ! is.null(min.rel.int) && ! is.na(min.rel.int)
                && (is.numeric(min.rel.int) || is.integer(min.rel.int))) {
                query$addJoin(table1=mzfield, field1='accession',
                    table2='peak.relative.intensity',
                    field2='peak.relative.intensity')
                lval <- BiodbSqlField$new(table='peak.relative.intensity',
                    field='peak.relative.intensity')
                rval <- BiodbSqlValue$new(min.rel.int)
                expr <- BiodbSqlBinaryOp$new(lexpr=lval, op='>=', rexpr=rval)
                query$getWhere()$addExpr(expr)
            }
            if (max.results > 0)
                query$setLimit(max.results)
            logDebug('Run query "%s".', query$toString())

            # Run query
            df <- self$getQuery(query)
            ids <- df[[1]]
        }
    }

    return(ids)
}

,doGetChromCol=function(ids=NULL) {

    chrom.cols <- data.frame(id=character(0), title=character(0))

    private$initDb()

    if ( ! is.null(private$db)) {

        tables <- DBI::dbListTables(private$db)

        if ('entries' %in% tables) {

            fields <- DBI::dbListFields(private$db, 'entries')
            fields.to.get <- c('chrom.col.id', 'chrom.col.name')

            if (all(fields.to.get %in% fields)) {
                query <- BiodbSqlQuery$new()
                query$setTable('entries')
                query$setDistinct(TRUE)
                for (field in fields.to.get)
                    query$addField(field=field)

                # Filter on spectra IDs
                if ( ! is.null(ids)) {
                    f <- BiodbSqlField$new(field='accession')
                    w <- BiodbSqlBinaryOp$new(op='in',
                        lexpr=f, rexpr=BiodbSqlList$new(ids))
                    query$setWhere(w)
                }

                # Run query
                chrom.cols <- self$getQuery(query)
                names(chrom.cols) <- c('id', 'title')
            }
        }
    }

    return(chrom.cols)
}
))
