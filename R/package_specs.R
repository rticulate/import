#' Package Specifications
#'
#' Decompse package specification into name and a list
#' for \code{checkVersion} in \code{loadNamespace}.
#'
#' @param pkg character: name og package, optionally with a
#'   version requirement in parentheses (as in Depends/Imports
#'   fields in package DESCRIPTION files).
#'
#' @return list with \code{name} and \code{version_check}, the
#'   latter which can be passed to \code{loadNamespace}.
#'
#' @noRd
#'
#' @details One can specify the package version using the
#'   operators > < >= <= == !=.
#'
#' @examples
#'
#' package_specs("magrittr (>= 1.0.1)")
#' package_specs("magrittr(1.5)")
package_specs <- function(pkg)
{
  if (!is.character(pkg) || length(pkg) != 1L)
    stop("`from` must be character with length 1.", call. = FALSE)

  contains_version_spec <- grepl("\\(.+\\)", pkg)

  if (contains_version_spec) {
    spec <- gsub("(.*\\()|(\\).*)", "", pkg)
    op   <- gsub(".*((>)|(<)|(>=)|(<=)|(==)|(!=)).*", "\\1", spec)
    if (identical(spec, op))
      op <- "=="
    version <- gsub(sprintf("( )|(%s)|(\\()|(\\))", op), "", spec)
    nm <- gsub("( )|(\\(.*\\))", "", pkg)
    list(pkg = nm,
         version_check = list(name = nm, op = op, version = version))
  } else {
    list(pkg = gsub(" ", "", pkg),
         version_check = NULL)
  }
}
