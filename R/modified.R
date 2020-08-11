#' Get Modification Time of Script Module.
#'
#' When a script is loaded to allow imports, a modification time is stored to
#' allow re-sourcing the script if modified after it was loaded.
#'
#' @param e A script environment or the file name of a script file.
#' @param .directory A directory to use in the case where e is a character
#'   variable, to be treated as a file path. The file path to use is then
#'   constructed using \code{file.path(.directory,e)}
#' @return POSIXct indicating modification time of the file when it was
#'   sourced into \code{e} (within \code{scripts}).
#' @noRd
modified <- function(e, .directory=NULL)
{
  if (is.environment(e)) {
    e[["__last_modified__"]]
  } else if (is.character(e) && is.character(.directory) &&
             file.exists(file.path(.directory,e)) ) {
    file.info(file.path(.directory,e))[["mtime"]]
  } else {
    NULL
  }
}

#' Set Modification Time of Script Module.
#'
#' When a script is loaded to allow imports, a modification time is stored to
#' allow re-sourcing the script if modified after it was loaded.
#'
#' @param e A script environment.
#' @param value POSIXct indicating modification time.
#' @noRd
`modified<-` <- function(e, value)
{
  if (!inherits(value, "POSIXct"))
    stop("Modification time must be a POSIXct timestamp.")

  assign("__last_modified__", value, envir = e)
  invisible(e)
}
