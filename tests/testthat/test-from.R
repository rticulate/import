
# Set context
context("Sanity check for test harness")

# We start with some sanity checks to ensure that
# testthat is correctly set up.
test_that("Harness works", {

  # knitr::normal_print() should not be found
  expect_error(normal_print("x"))

})

# Set context
context("Custom test harness")

# testthat does not work well with packages that manipulate
# namespaces, so tests need to be run manually.
# (see $package_root/tests/manual/manual_tests.R)
test_that("manual tests work", {

  # testthat starts in $package_root/tests/testthat, but
  # The manual tests expect to be run from $package_root
  testthat_dir <- setwd(file.path("..",".."))

  # Set up a new Rscript process to source the manual tests,
  # then check the output to examine if they ran correctly.
  rscript_exe <- paste0("'",file.path(R.home(),"bin","Rscript"),"'")
  manual_test_script <- file.path("tests","manual","manual_tests.R")
  manual_test_output <- system(paste(rscript_exe, manual_test_script), intern=TRUE)
  expect_match(
    manual_test_output,
    "Manual tests completed successfully ...",
    all=FALSE,
    label=paste(manual_test_output,collapse="\n")
  )

  # Switch back to original directory, to be safe
  setwd(testthat_dir)

})
