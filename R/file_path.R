#' Return a file path given file name and directory
#'
#' Given a directory and a file name (path), return the combined path.
#' For relative file names, this is identical to \code{file.path()},
#' for absolute file names, it simply returns the absolute file name.
#'
#' @param working_directory character: the working directory to use
#' @param file_name character: the name of a possible R script file.
#' @return character: the resulting file name of the file.
#' @noRd
file_path <- function(working_directory, file_name) {

  # Credit to Henrik Bengtson and the R.utils package
  # https://cran.r-project.org/web/packages/R.utils/index.html
  isAbsolutePath <- function(pathname, ...) {

    # Argument 'pathname':
    pathname <- as.character(pathname)
    # BACKWARD COMPATIBILITY: Treat empty path specially?
    #pathname <- .getPathIfEmpty(pathname, where="isAbsolutePath")

    nPathnames <- length(pathname)

    # Nothing to do?
    if (nPathnames == 0L) return(logical(0L))

    # Multiple path to be checked?
    if (nPathnames > 1L) {
      res <- sapply(pathname, FUN=isAbsolutePath, ...)
      return(res)
    }

    # A missing pathname?
    if (is.na(pathname)) return(FALSE)

    # Recognize '~' paths
    if (regexpr("^~", pathname) != -1L)
      return(TRUE)

    # Windows paths
    if (regexpr("^.:(/|\\\\)", pathname) != -1L)
      return(TRUE)

    # Split pathname...
    components <- strsplit(pathname, split="[/\\]")[[1L]]
    if (length(components) == 0L)
      return(FALSE)

    (components[1L] == "")
  }


  if ( isAbsolutePath(file_name) ) {
    file_name
  } else {
    file.path(working_directory, file_name)
  }

}
