#' import
#'
#' @docType package
#' @name import
#' @author Stefan Milton Bache
#' @description The package provides an alternative mechanism for importing
#' objects from packages.
NULL

#' Import objects from a package.
#'
#' The \code{import::from} and \code{import::into} functions provide
#' an alternative way to import objects (e.g. functions) from packages.
#' It is sometimes preferable compared with \code{library} or \code{require}
#' which will expose all exported objects from the package.
#' The benefit over \code{obj <- pkg::obj} is that the imports will be
#' imported into a namespace rather than into the global environment. Also,
#' it is a more succinct way of importing several objects.
#'
#' These functions have the intended side-effect of altering
#' the search path, as they (by default) imports objects into the "imports"
#' namespace rather than the global environment.
#'
#' The \code{import} package is not meant to be loaded with \code{library},
#' but rather it is named to make the function calls expressive without the
#' need to preload, i.e. it is designed to be used explicitely with the `::`
#' syntax: \code{import::from(pkg, x, y)}.
#'
#' @rdname importfunctions
#' @param ns. The namespace which is imported to.
#' @param ... names or name-value pairs specifying objects to import.
#'   If arguments are named, then the imported object will have this new name.
#' @param from the package from which to import.
#'
#' @export
from <- function(from, ..., ns. = "imports")
{
  symbols <- symbol_list(...)
  parent  <- parent.frame()
  from    <- symbol_as_character(substitute(from))
  ms.     <- symbol_as_character(substitute(ns.))

  use_ns <- !exists(".packageName", parent) &&
            !ns. == ""

  ns_exists <- ns. %in% search()

  make_namespace <- attach # Make R CMD check happy.
  if (use_ns && !ns_exists)
    make_namespace(NULL, 2L, name = ns.)

  for (s in seq_along(symbols)) {
    import_call <-
      make_import_call(symbols[s],
                       from,
                       if (use_ns) symbol_as_character(ns.),
                       names(symbols)[s])

    eval(import_call, parent, parent)
  }

  invisible(NULL)
}

#' @rdname importfunctions
#' @export
into <- function(ns., ..., from)
{
  parent <- parent.frame()
  cl <- match.call()
  cl[[1L]] <- quote(from)
  eval(cl, parent, parent)
}

