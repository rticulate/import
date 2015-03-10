#' import
#'
#' @docType package
#' @name import
#' @title An Import Mechanism For R
#' @author Stefan Milton Bache
#' @description The package provides an alternative and expressive
#' mechanism for importing objects from packages.
#' @seealso \code{\link{from}}, \code{\link{into}}, \code{\link{here}}.
NULL

#' Import objects from a package.
#'
#' The \code{import::from} and \code{import::into} functions provide an
#' alternative way to import objects (e.g. functions) from packages. It is
#' sometimes prefered over using \code{library} (or \code{require}) which will
#' import all objects exported by the package. The benefit over \code{obj <-
#' pkg::obj} is that the imported objects will (by default) be placed in a
#' separate entry in the search path (which can be specified), rather in the
#' global/current environment. Also, it is a more succinct way of importing
#' several objects. Note that the two functions are symmetric, and usage is a
#' matter of preference and whether specifying the \code{.into} argument is
#' needed. The function \code{import::here} is short-hand for
#' \code{import::from} with \code{.into = ""} which imports into the current
#' environment.
#'
#' The function arguments can be quoted or unquoted as with e.g. \code{library}.
#' In any case, the character representation is used when unquoted arguments are
#' provided (and not the value of objects with matching names). The period in
#' the argument names \code{.into} and \code{.from} are there to avoid name
#' clash with package objects.
#'
#' Note that the \code{import} functions have usually the (intended) side-effect
#' of altering the search path, as they (by default) imports objects into the
#' "imports" search path entry rather than the global environment.
#'
#' The \code{import} package is not meant to be loaded with \code{library}, but
#' rather it is named to make the function calls expressive without the need to
#' preload, i.e. it is designed to be used explicitely with the \code{::} syntax:
#' \code{import::from(pkg, x, y)}.
#'
#' @rdname importfunctions
#' @param .from The package from which to import.
#' @param ... Names or name-value pairs specifying objects to import.
#'   If arguments are named, then the imported object will have this new name.
#' @param .into The name of the search path entry. Use \code{""} to import
#'   into the current environment.
#'
#' @export
from <- function(.from, ..., .into = "imports")
{
  symbols <- symbol_list(...)
  parent  <- parent.frame()
  from    <- symbol_as_character(substitute(.from))
  into    <- symbol_as_character(substitute(.into))

  use_into <- !exists(".packageName", parent) &&
              !into == ""

  into_exists <- into %in% search()

  make_attach <- attach # Make R CMD check happy.
  if (use_into && !into_exists)
    make_attach(NULL, 2L, name = into)

  for (s in seq_along(symbols)) {
    import_call <-
      make_import_call(symbols[s],
                       from,
                       if (use_into) symbol_as_character(into),
                       names(symbols)[s])

    eval.parent(import_call)
  }

  invisible(NULL)
}

#' @rdname importfunctions
#' @export
into <- function(.into, ..., .from)
{
  cl <- match.call()
  cl[[1L]] <- quote(import::from)
  eval.parent(cl)
}

#' @rdname importfunctions
#' @export
here <- function(..., .from)
{
  cl <- match.call()
  cl[[1L]] <- quote(import::from)
  cl[[".into"]] <- ""
  eval.parent(cl)
}
