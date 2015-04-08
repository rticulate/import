.onAttach <- function(libname, pkgname)
{
  packageStartupMessage("The import package should not be attached. Use :: syntax instead.")

  invisible()
}
