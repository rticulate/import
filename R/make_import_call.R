#' Make an import call object.
#'
#' The import call constructed by this function can be evaluated with
#' \code{eval} to perform the actual import.
#'
#' @param name character: The name of the object to import.
#' @param pkg character: The name of the package to import from.
#' @param ns character: The namespace in which to import.
#' @param new_name character: The new name to use for the imported object.
#'
#' @return A call object.
make_import_call <- function(name, pkg, ns, new_name)
{
  params <- list(name = name,
                 pkg  = pkg,
                 ns   = if (is.null(ns)) -1 else ns,
                 new_name = new_name)

  substitute(assign(new_name,
                    get(name, envir = asNamespace(pkg), inherits = TRUE),
                    ns),
             params)
}
