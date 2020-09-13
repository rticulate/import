#' This package is not intended for use with \code{library}. It is named to make
#' calls like \code{import::from(pkg, fun1, fun2)} expressive. Using the
#' \code{import} functions complements the standard use of
#' \code{library(pkg)}(when most objects are needed, and context is clear) and
#' \code{obj <- pkg::obj} (when only a single object is needed).
#'
#' @docType package
#' @name import
#' @title An Import Mechanism for R
#' @author Stefan Milton Bache
#' @description This is an alternative mechanism for importing objects from
#'   packages. The syntax allows for importing multiple objects from a package
#'   with a single command in an expressive way. The \code{import} package
#'   bridges some of the gap between using \code{library} (or \code{require})
#'   and direct (single-object) imports. Furthermore the imported objects are
#'   not placed in the current environment (although possible), but in a named
#'   entry in the search path.
#' @seealso For usage instructions and examples, see \code{\link{from}},
#'   \code{\link{into}}, or \code{\link{here}}.
#'
#'   Helpful links:
#'     \itemize{
#'       \item{[https://import.rticulate.org/](https://import.rticulate.org/)}
#'       \item{[https://github.com/rticulate/import](https://github.com/rticulate/import)}
#'       \item{[https://github.com/rticulate/import/issues](https://github.com/rticulate/import/issues)}
#'     }
#' @md
NULL
