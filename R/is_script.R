#' Determine if File is an R Script.
#'
#' Given an import source, this function will infer whether it is a script
#' (as opposed to a package). It will be treated as a file if there exists
#' a file with the provided name, and it ends in .R or .r.
#'
#' @param file_name character: the name of a possible R script file.
#' @return logical
#' @noRd
is_script <- function(file_name, .directory)
{
  is.character(file_name) &&
  is.character(.directory) &&
  length(file_name) == 1L &&
  isTRUE(grepl(".+\\.[rR]$", file_name)) &&
  file.exists(file.path(.directory,file_name))
}
