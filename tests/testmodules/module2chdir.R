
# This variable is set when the script is sourced, so that
# the .chdir parameter can be tested.
directory_of_sourcing <- getwd()

fun_chdir_report <- function() {
  paste0("Module was sourced in: ",directory_of_sourcing)
}
