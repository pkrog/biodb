#' Progress class.
#'
#' @description
#' A class for informing user about the progress of a process.
#'
#' @details
#' This class displays progress of a process to user, and sends
#' notifications of this progress to observers too.
#'
#' @import R6
#' @import chk
#' @import progress
#' @export
Progress <- R6::R6Class('Progress'

,public=list(
             
#' @description
#' Constructor.
#' @param msg The message to display to the user.
#' @param total The total number of elements to process.             
#' @return A new instance.
initialize=function(biodb, msg, total){
    if ( ! is.null(biodb))
        chk::chk_is(biodb, "Biodb")
    chk::chk_string(msg)
    chk::chk_whole_number(total)
    chk::chk_gte(total, 0)

    private$biodb <- biodb
    private$msg <- msg
    private$index <- 0
    private$total <- total
    fmt <- sprintf("%s [:bar] :percent ETA: :eta", msg)
    private$bar <- progress_bar$new(format=fmt, total=total)
}

#' @description
#' Increment progress.
#' @return Nothing.
,increment=function() {
    
    private$index <- private$index + 1

    # Update progress bar
    private$bar$tick()
    
    # Notify biodb observers
    if ( ! is.null(private$biodb))
        private$biodb$notify('notifyProgress', list(what=private$msg,
                             index=private$index, total=private$total))
    
    return(invisible(NULL))
}    
)

,private=list(
    biodb=NULL,
    msg=NULL,
    total=NULL,
    index=NULL,
    bar=NULL
))