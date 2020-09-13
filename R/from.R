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
#' desired. The function \code{import::here} imports into the current environment.
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
#' @section Packages vs. modules:
#' \code{import} can either be used to import objects either from R packages or
#' from \code{R} source files. If the \code{.from} parameter ends with '.R' or
#' '.r', \code{import} will look for a source file to import from. A source file
#' in this context is referred to as a \code{module} in the documentation.
#'
#' @section Package Versions:
#' With \code{import} you can specify package version requirements. To do this
#' add a requirement in parentheses to the package name (which then needs to
#' be quoted), e.g \code{import::from("parallel (>= 3.2.0)", ...)}.
#' You can use the operators \code{<}, \code{>}, \code{<=}, \code{>=},
#' \code{==}, \code{!=}. Whitespace in the specification is irrelevant.
#'
#' @rdname importfunctions
#' @param .from The package from which to import.
#' @param ... Names or name-value pairs specifying objects to import.
#'   If arguments are named, then the imported object will have this new name.
#' @param .into The name of the search path entry. Enclosing the value in curly
#'   brackets causes the parameter to be treated as an actual
#'   environment value, rather than the name of an environment. Using
#'   \code{.into={environment()}} causes imports to be made into the current
#'   environment; \code{.into=""} is an equivalent shorthand value.
#' @param .library character specifying the library to use when importing from
#'   packages. Defaults to the latest specified library.
#' @param .directory character specifying the directory to use when importing
#'   from modules. Defaults to the current working directory. If .from is a
#'   module specified using an absolute path (i.e. starting with \code{/}),
#'   this parameter is ignored.
#' @param .all logical specifying whether all available objects in a
#'   package or module should  be imported. It defaults to FALSE unless
#'   .exclude is being used to omit particular functions.
#' @param .except character vector specifying any objects that should
#'   not be imported. Any values specified here override both values
#'   provided in \code{...} and objects included because of the
#'   \code{.all} parameter
#' @param .chdir logical specifying whether to change directories before
#'   sourcing a module (this parameter is ignored for libraries)
#' @param .character_only A logical indicating whether \code{.from} and
#'   \code{...} can be assumed to be character strings. (Note that this
#'   parameter does not apply to how the \code{.into} parameter is handled).
#'
#' @return a reference to the environment containing the imported objects.
#'
#' @export
#' @examples
#' import::from(parallel, makeCluster, parLapply)
#' import::into("imports:parallel", makeCluster, parLapply, .from = parallel)
#'
#' @seealso
#'   Helpful links:
#'     \itemize{
#'       \item{[https://import.rticulate.org](https://import.rticulate.org)}
#'       \item{[https://github.com/rticulate/import](https://github.com/rticulate/import)}
#'       \item{[https://github.com/rticulate/import/issues](https://github.com/rticulate/import/issues)}
#'     }
#' @md
from <- function(.from, ..., .into = "imports",
                 .library = .libPaths()[1L], .directory=".",
                 .all=(length(.except) > 0), .except=character(),
                 .chdir = TRUE, .character_only = FALSE)
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

  # .all or .except must not be used in conjunction with ::: notation
  if (identical(cl, call(":::", quote(import), quote(from))) &&
            (.all!=FALSE || length(.except)!=0))
    stop("`import:::` must not be used in conjunction with .all or .except", call. = FALSE)

  # .into="" is a short-hand for .into={environment()}
  if (!missing(.into) && is.character(.into) && .into == "")
    .into = quote({environment()})

  # If we are inside a bad recursion call, warn and set .into to the only
  # acceptable value for an inner recursive call, which is quote({environment()})
  if (detect_bad_recursion(.traceback(0))) {
     .into = quote({environment()})
     warning(paste0("import::from() or import::into() was used recursively, to import \n",
                    "    a module from within a module.  Please rely on import::here() \n",
                    "    when using the import package in this way.\n",
                    "    See vignette(import) for further details."))
  }

  # Extract the arguments
  symbols <- symbol_list(..., .character_only = .character_only, .all = .all)

  from    <-
    `if`(isTRUE(.character_only), .from, symbol_as_character(substitute(.from)))

  into_expr <- substitute(.into)
  `{env}` <- identical(into_expr[[1]], quote(`{`))

  # if {env} syntax is used, treat env as explicit env
  if (`{env}`) {
    into <- eval.parent(.into)
    if (!is.environment(into))
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
  from_is_script <- is_script(from, .directory)

  if (from_is_script) {
    from_created <- from %in% ls(scripts, all.names = TRUE)
    if (!from_created || modified(from, .directory) > modified(scripts[[from]])) {

      # Find currently attachments
      attached <- search()

      # Create a new environment to manage the script module if it does not exist
      if (!from_created)
        assign(from, new.env(parent = parent.frame()), scripts)

      # Make modification time stamp
      modified(scripts[[from]]) <- modified(from, .directory)

      # Make behaviour match that of a package, i.e. import::from won't use "imports"
      scripts[[from]][[".packageName"]] <- from

      # Source the file into the new environment.
      packages_before <- .packages()
      suppress_output(sys.source(file_path(.directory, from), scripts[[from]], chdir = .chdir))

      # If sourcing the script loaded new packages, raise error
      packages_after <- .packages()
      if ( !identical(packages_before,packages_after) ) {
        warning("A package was loaded using 'library(...)' from within an import::*() module.\n",
             "    Please rely on import::here() to load objects from packages within an \n",
             "    import::*() module.  See vignette(import) for further details." )
      }

      # Make sure to detach any new attachments.
      on.exit({
        to_deattach <- Filter(function(.) !. %in% attached, search())
        for (d in to_deattach)
          detach(d, character.only = TRUE)
      })
    }
    pkg <- scripts[[from]]
    pkg_name <- from

    # Create list of all available objects (for use with the .all parameter)
    all_objects <- ls(scripts[[from]])
  } else {
    # Load the package namespace, which is passed to the import calls.
    spec <- package_specs(from)
    all_objects <- getNamespaceExports(spec$pkg)
    pkg <- tryCatch(
      loadNamespace(spec$pkg, lib.loc = .library,
                    versionCheck = spec$version_check),
      error = function(e) stop(conditionMessage(e), call. = FALSE)
    )
    pkg_name <- spec$pkg
  }
  # If .all parameter was specified, override with list of all objects
  # (excluding internal variable __last_modified__)
  # Take care not to lose the names of any manually specified parameters
  if (.all) {
    all_objects <- setdiff(all_objects, "__last_modified__")
    names(all_objects) <- all_objects
    symbols <- c(symbols,all_objects)
    symbols <- symbols[!duplicated(symbols)]
  }

  # If .except parameter was specified, any object specified there
  # should be omitted from the import
  if (length(.except)>0) {
    symbols <- symbols[!(symbols %in% .except)] # Fancy setdiff() to preserve names
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
        call("::", as.symbol(pkg_name), as.symbol(symbols[s]))

    # Evaluate the import call.
    tryCatch(eval.parent(import_call),
             error = function(e) stop(e$message, call. = FALSE))
  }

  if (!`{env}` && into != "" && !exists("?", into, mode = "function", inherits = FALSE)) {
    assign("?", `?redirect`, into)
  }

  invisible(as.environment(into))
}
