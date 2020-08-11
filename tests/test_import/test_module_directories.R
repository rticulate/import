
# We use the testthat library to evaluate expectations.
# Tests must nevertheless be run outside the standard testthat
# test harness, because import::from changes environments that
# are protected when run inside the harness. See the contents
# of the testthat directory to examine the custom test harness
# that is used instead. These tests can also be run manually.
library(testthat)

# Printing the directory helps with fixing any problems if tests fail
print(getwd())

# Source cleanup script
# (we do not use import::from because then the script would clean itself up)
source("cleanup_environment.R")

## IMPORTANT:
## Remember to run the cleanup script after each test sequence with:
## > cleanup_environment()


## Tests begin

# The .directory parameter should be respected, default should be "."
test_that("The .directory parameter is respected", {
  expect_error ( fun_chdir_report() )
  expect_error ( import::from(module_chdir.R, fun_chdir_report) )
  expect_error ( fun_chdir_report() ) # Nothing should have been imported
  expect_silent( import::from(module_chdir.R, fun_chdir_report, .directory="module_chdir") )
  expect_match ( fun_chdir_report(), "module_chdir$" )
  expect_error ( import::from(module_chdir.R, fun_chdir_report, .directory="nonexisting_directory") )
  cleanup_environment()
})



# The .chdir parameter should be respected, default should be true
# fun_chdir_report() returns the directory where its definition was originally sourced
test_that("The .chdir parameter is respected (defaulting to TRUE)", {
  expect_error ( fun_chdir_report() )
  expect_silent( import::from(module_chdir.R, fun_chdir_report, .directory="module_chdir") )
  expect_match ( fun_chdir_report(), "module_chdir$" )
  cleanup_environment()
})

# The .chdir parameter should be respecte, if TRUE is explicitly passed
test_that("The .chdir parameter is respected when passed TRUE", {
  expect_error ( fun_chdir_report() )
  expect_silent( import::from(module_chdir.R, fun_chdir_report, .directory="module_chdir", .chdir=TRUE) )
  expect_match ( fun_chdir_report(), "module_chdir$" )
  cleanup_environment()
})

# The .chdir parameter should be respected, if set to false no chdir performed,
# so the report should NOT match the name of the module_chdir directory
test_that("The .chdir parameter is respected when passed FALSE", {
  expect_error  ( fun_chdir_report() )
  expect_silent ( import::from(module_chdir.R, fun_chdir_report, .directory="module_chdir", .chdir=FALSE) )
  expect_failure( expect_match(fun_chdir_report(),"module_chdir$") )
  cleanup_environment()
})


## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

