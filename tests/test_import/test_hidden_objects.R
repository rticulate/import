
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


test_that("Standard import from module works", {
  abs_module <- file.path(tempdir(),"module_hidden_objects.R")
  file.copy("module_hidden_objects.R",abs_module)
  expect_error ( fun1() )
  expect_silent( import::from(abs_module, "fun1", .character_only=TRUE) )
  expect_equal ( fun1(), "fun1" )
  cleanup_environment()
})

test_that("Import hidden object with .character_only=TRUE", {
  abs_module <- file.path(tempdir(),"module_hidden_objects.R")
  file.copy("module_hidden_objects.R",abs_module)
  expect_error ( .script_version )
  expect_silent( import::from(abs_module, ".script_version", .character_only=TRUE) )
  expect_equal ( .script_version, "v1.0" )
  cleanup_environment()
})

test_that("Import hidden objects with argument name conflicts", {
  abs_module <- file.path(tempdir(),"module_hidden_objects.R")
  file.copy("module_hidden_objects.R",abs_module)
  expect_error ( .from )
  expect_error ( .into )
  expect_error ( .directory )
  expect_silent( import::from(abs_module, ".from", ".into", ".directory", .character_only=TRUE) )
  expect_equal ( .from, "a script" )
  expect_equal ( .into, "an env" )
  expect_equal ( .directory, "my_dir" )
  cleanup_environment()
})

test_that("Import hidden object with argument name conflict and both specified", {
  abs_module <- file.path(tempdir(),"module_hidden_objects.R")
  file.copy("module_hidden_objects.R",abs_module)
  expect_error ( .directory )
  expect_silent( import::from("module_hidden_objects.R", ".directory", .character_only=TRUE, .directory = tempdir()) )
  expect_equal ( .directory, "my_dir" )
  cleanup_environment()
})

test_that("Import hidden object with argument name conflict and both specified and .character_only=FALSE", {
  expect_error ( .from )
  expect_error ( .into )
  expect_error ( .directory )
  expect_silent( import::from(module_hidden_objects.R, .from, .directory, .into, .directory = ".", .into = "new env") )
  expect_equal ( .from, "a script" )
  expect_equal ( .into, "an env" )
  expect_equal ( .directory, "my_dir" )
  expect_true  (all(c(".from", ".into", ".directory") %in% ls(n = "new env", all.names = TRUE)))
  cleanup_environment(environments = "new env")
})

test_that("Import hidden object with .character_only=FALSE", {
  expect_error ( .script_version )
  expect_silent( import::from(module_hidden_objects.R, .script_version) )
  expect_equal ( .script_version, "v1.0" )
  cleanup_environment()
})

test_that("Import hidden (unexported) object", {
  expect_error ( .packageName )
  expect_silent( import:::from(rmarkdown, .packageName) )
  expect_equal ( .packageName, "rmarkdown" )
  cleanup_environment()
})

test_that("Import all objects, including hidden, .character_only=TRUE", {
  abs_module <- file.path(tempdir(),"module_hidden_objects.R")
  file.copy("module_hidden_objects.R",abs_module)
  expect_error ( .script_version )
  expect_error ( fun1() )
  expect_error ( .directory )
  expect_silent( import::from(abs_module, .all=TRUE, .character_only=TRUE) )
  expect_equal ( .script_version, "v1.0" )
  expect_equal ( fun1(), "fun1" )
  expect_equal ( .directory, "my_dir" )
  cleanup_environment()
})

test_that("Import all objects, including hidden, .character_only=FALSE", {
  expect_error ( .script_version )
  expect_error ( fun1() )
  expect_error ( .directory )
  expect_silent( import::from(module_hidden_objects.R, .all=TRUE) )
  expect_equal ( .script_version, "v1.0" )
  expect_equal ( fun1(), "fun1" )
  expect_equal ( .directory, "my_dir" )
  cleanup_environment()
})

## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

