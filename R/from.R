#' Import Objects From a Package.
#'
#' The \code{import::from} and \code{import::into} functions provide an
#' alternative way to import objects (e.g. functions) from packages. It is
#' sometimes preferred over using \code{library} (or \code{require}) which will
#' import all objects exported by the package. The benefit over \code{obj <-
#' pkg::obj} is that the imported objects will (by default) be placed in a
#' separate entry in the search path (which can be specified), rather in the
#' global/current environment. Also, it is a more succinct way of importing
#' several objects. Note that the two functions are symmetric, and usage is a
#' matter of preference and whether specifying the \code{.into} argument is
#' desired. The function \code{import::here} is short-hand for
#' \code{import::from} with \code{.into = ""} which imports into the current
#' environment.
#'
#' The function arguments can be quoted or unquoted as with e.g. \code{library}.
#' In any case, the character representation is used when unquoted arguments are
#' provided (and not the value of objects with matching names). The period in
#' the argument names \code{.into} and \code{.from} are there to avoid name
#' clash with package objects. The double-colon syntax \code{import::from}
#' allows for imports of exported objects (and lazy data) only. To import
#' objects that are not exported, use triple-colon syntax, e.g.
#' \code{import:::from}. The two ways of calling the \code{import} functions
#' analogue the \code{::} and \code{:::} operators themselves.
#'
#' Note that the \code{import} functions usually have the (intended) side-effect
#' of altering the search path, as they (by default) import objects into the
#' "imports" search path entry rather than the global environment.
#'
#' The \code{import} package is not meant to be loaded with \code{library} (and
#' will output a message about this if attached), but rather it is named to make
#' the function calls expressive without the need to preload, i.e. it is
#' designed to be used explicitly with the \code{::} syntax, e.g.
#' \code{import::from(pkg, x, y)}.
#'
#' @section Package Versions:
#' With \code{import} you can specify package version requirements. To do this
#' add a requirement in parentheses to the package name (which then needs to
#' be quoted), e.g \code{import::from("parallel (>= 3.2.0)", ...)}.
#' You can use the operators \code{<}, \code{>}, \code{<=}, \code{>=},
#' \code{==}, \code{!=}. Whitespace in the specification is irrelevant.
#'
#' @section Package Libraries:
#' The search path for packages is specified by the \code{.library}
#' argument to \code{import::from}. By default, this grabs the
#' library location from the \code{import.library} option, which in
#' turn defaults to the first entry in \code{.libPaths()}. You can
#' customize the default behavior by changing this option. For
#' instance, to search all of \code{.libPaths()}, you could do:
#'
#' \preformatted{
#'   options("import.library" = .libPaths())
#' }
#'
#' A convenient place to do this is in a global or directory-specific ".Rprofile".
#'
#' @rdname importfunctions
#' @param .from The package from which to import.
#' @param ... Names or name-value pairs specifying objects to import.
#'   If arguments are named, then the imported object will have this new name.
#' @param .into The name of the search path entry. Use \code{""} to import
#'   into the current environment.
#' @param .library character specifying the library to use. Defaults to
#'   \code{getOption("import.library")}.
#' @param .character_only A logical indicating whether \code{.from} and
#'   \code{...} can be assumed to be charater strings.
#'
#' @return a reference to the environment with the imports or \code{NULL}
#'   if \code{into = ""}, invisibly.
#'
#' @export
#' @examples
#' import::from(parallel, makeCluster, parLapply)
#' import::into("imports:parallel", makeCluster, parLapply, .from = parallel)
from <- function(.from, ..., .into = "imports", .library = getOption("import.library"),
                 .character_only = FALSE)
{
  # Capture the relevant part of the call to see if
  # the import function is used as intended.
  cl <- match.call()[[1L]]

  # Check if only exported objects are considered valid,
  # i.e. when called as import::from

  exports_only <- identical(cl, call("::", quote(import), quote(from)))

  # If not, the only other valid way of calling the function is import:::from
  # which will allow non-exported values too.
  if (!exports_only && !identical(cl, call(":::", quote(import), quote(from))))
    stop("Use `import::` or `import:::` when importing objects.", call. = FALSE)

  # Ensure that .from is specified.
  if (missing(.from))
    stop("Argument `.from` must be specified for import::from.",  call. = FALSE)

  # Extract the arguments
  symbols <- symbol_list(..., .character_only = .character_only)

  from    <-
    `if`(isTRUE(.character_only), .from, symbol_as_character(substitute(.from)))

  into_expr <- substitute(.into)
  `{env}` <- identical(into_expr[[1]], quote(`{`))

  # if {env} syntax is used, treat env as explicit env
  if (`{env}`) {
    into <- eval.parent(.into)
    if (!is.environment(.into))
      stop("into is not an environment, but {env} notation was used.", call. = FALSE)
  } else {
    into    <- symbol_as_character(into_expr)
  }

  # Check whether assignment should be done in a named entry in the search path.
  use_into <- !exists(".packageName", parent.frame(), inherits = TRUE) &&
              !`{env}` &&
              !into == ""

  # Check whether the name already exists in the search path.
  into_exists <- !`{env}` && (into %in% search())

  # Create the entry if needed.
  make_attach <- attach # Make R CMD check happy.
  if (use_into && !into_exists)
    make_attach(NULL, 2L, name = into)

  # Determine whether the source is a script or package.
  from_is_script <- is_script(from)

  if (from_is_script) {
    from_created <- from %in% ls(scripts, all.names = TRUE)
    if (!from_created || modified(from) > modified(scripts[[from]])) {

      # Find currently attachments
      attached <- search()

      # Create a new environment to manage the script module if it does not exist
      if (!from_created)
        assign(from, new.env(parent = parent.frame()), scripts)

      # Make modification time stamp
      modified(scripts[[from]]) <- modified(from)

      # Make behaviour match that of a package, i.e. import::from won't use "imports"
      scripts[[from]][[".packageName"]] <- from

      # Source the file into the new environment.
      suppress_output(sys.source(from, scripts[[from]], chdir = TRUE))

      # Make sure to detach any new attachments.
      on.exit({
        to_deattach <- Filter(function(.) !. %in% attached, search())
        for (d in to_deattach)
          detach(d, character.only = TRUE)
      })
    }
    pkg <- scripts[[from]]
  } else {
    # Load the package namespace, which is passed to the import calls.
    spec <- package_specs(from)
    pkg <- tryCatch(
      loadNamespace(spec$pkg, lib.loc = .library,
                    versionCheck = spec$version_check),
      error = function(e) stop(conditionMessage(e), call. = FALSE)
    )
  }

  # import each object specified in the argument list.
  for (s in seq_along(symbols)) {
    import_call <-
      make_import_call(
        list(new = names(symbols)[s],
             nm  = symbols[s],
             ns  = pkg,
             inh = !exports_only,
             pos = if (use_into || `{env}`) into else -1),
        exports_only && !from_is_script)

    if (!from_is_script)
      import_aliases[[names(symbols)[s]]] <-
        call("::", as.symbol(from), as.symbol(symbols[s]))

    # Evaluate the import call.
    tryCatch(eval.parent(import_call),
             error = function(e) stop(e$message, call. = FALSE))
  }

  if (!`{env}` && into != "" && !exists("?", into, mode = "function", inherits = FALSE)) {
    assign("?", `?redirect`, into)
  }

  invisible(if (use_into) as.environment(into) else NULL)
}
