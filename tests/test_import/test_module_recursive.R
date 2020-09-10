
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

test_that("Recursive import::here() works with modules", {
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(print_title_text(text))
  expect_error(to_title(text)) # Inner utility function should not be available

  expect_silent(import::from(module_recursive_outer_here.R, print_title_text))
  expect_output(print_title_text(text), text_title_case)
  expect_error(to_title(text)) # Inner utility function should not be available
  cleanup_environment()
})

test_that("Recursive import::from() works with modules (with warning)", {
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(print_title_text(text))
  expect_error(to_title(text)) # Inner utility function should not be available

  expect_warning(import::from(module_recursive_outer_from.R, print_title_text))
  expect_output(print_title_text(text), text_title_case)
  expect_error(to_title(text)) # Inner utility function should not be available
  cleanup_environment()
})

test_that("Recursive import::here() works with modules and packages", {
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(normal_print("OK")) # This test actually relies on knitr::normal_print()
  expect_error(print_title_text(text))
  expect_error(to_title(text)) # Inner utility function should not be available

  expect_silent(import::from(module_recursive_package_here.R, print_title_text))
  expect_output(print_title_text(text), text_title_case)
  expect_error(to_title(text))     # Inner utility function should not be available
  expect_error(normal_print("OK")) # Inner utility function should not be available
  cleanup_environment()
})

test_that("Recursive import::from() works with modules and packages (with warning)", {
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(normal_print("OK")) # This test actually relies on knitr::normal_print()
  expect_error(print_title_text(text))
  expect_error(to_title(text)) # Inner utility function should not be available

  expect_warning(import::from(module_recursive_package_from.R, print_title_text))
  expect_output(print_title_text(text), text_title_case)
  expect_error(to_title(text))     # Inner utility function should not be available
  expect_error(normal_print("OK")) # Inner utility function should not be available
  cleanup_environment()
})

# Combines recursive tests with chdir functionality
test_that("Recursive module imports in subdirs work (with warning)", {
  skip_on_os("windows") # Test relies on using forward slashes in paths
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(print_text(text))
  expect_error(print_title_text(text))

  expect_silent(import::from("module_recursive/src/text.R", print_text))
  expect_output(print_text(text), text)
  expect_warning(import::from("module_recursive/src/title_text.R", print_title_text))
  expect_output(print_title_text(text), text_title_case)
  cleanup_environment()
})

test_that("Recursive module imports in subdirs work with here()", {
  skip_on_os("windows") # Test relies on using forward slashes in paths
  text = "hi friend, how are you"
  text_title_case = "Hi Friend, How are you"
  expect_error(print_text(text))
  expect_error(print_title_text(text))
  expect_silent(import::from("module_recursive/src/text.R", print_text))
  expect_output(print_text(text), text)
  expect_silent(import::from("module_recursive/src/title_text_here.R", print_title_text))
  expect_output(print_title_text(text), text_title_case)
  cleanup_environment()
})


# Using library() inside a module does not work and should throw an error
test_that("Using library() inside a module throws an error", {
  expect_error(import::from(module_recursive_library.R, print_title_text))
  cleanup_environment()
})



## Tests end


## IMPORTANT:
## The following line must be printed exactly as is,
## it is used by the custom harness to check if the tests worked:
print("Import tests completed successfully ...")

