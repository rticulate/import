#' Make an import call object.
#'
#' The import call constructed by this function can be evaluated with
#' \code{eval} to perform the actual import.
#'
#' @param name character: The name of the object to import.
#' @param pkg character: The name of the package to import from.
#' @param into character: The namespace in which to import.
#' @param new character: The new name to use for the imported object.
#' @param lib character: The library in which to find \code{pkg}.
#'
#' @return A call object.
make_import_call <- function(name, new, pkg, into, lib)
{
  params <- list(name = name,
                 new  = new,
                 pkg  = pkg,
                 into = if (is.null(into)) -1 else into,
                 lib  = lib)

  substitute(assign(new,
                    get(name, envir = loadNamespace(pkg, lib.loc = lib),
                        inherits = TRUE),
                    into),
             params)
}
