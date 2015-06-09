# Output a message for the user if they attach the package rather than use the
# colon-syntax.
.onAttach <- function(libname, pkgname)
{
  msg <-
    paste0("The import package should not be attached.\n",
           "Use \"colon syntax\" instead, e.g. import::from, or import:::from.")

  packageStartupMessage(msg)

  invisible()
}
