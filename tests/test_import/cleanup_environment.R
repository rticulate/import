
#' Cleans up any objects in the environment left over from
#' a given test sequence
#' @param environments A list (by name) of environments to cleanup
#' @param cleanup_here Should the calling environment be cleaned up? (for tests with here())
#' @param exclude_self Should the cleanup_environment function itself be excluded from cleanup?
#'
cleanup_environment <- function(environments=c("imports"),
                                cleanup_here=FALSE, exclude_self=TRUE) {
  for (env_name in environments) {
    if(env_name %in% search())
      rm(list=ls(n=env_name, all.names=TRUE), pos=env_name)
  }
  # Cleanup the local environment, if applicable
  if (cleanup_here) {
    obj_list <- ls(pos=parent.env(environment()), all.names=TRUE)
    if (exclude_self)
      obj_list <- setdiff(obj_list,"cleanup_environment")
    rm(list=obj_list, pos=parent.env(environment()))
  }
  # The import:::scripts environment must always be cleaned up
  rm(list=ls(env=import:::scripts), pos=import:::scripts)
}
