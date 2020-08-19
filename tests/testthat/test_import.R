
# Manual setup to duplicate testthat environment
#library(testthat)
#setwd("tests/testthat")

# Set context
context("Setting up custom test harness")

# We start with some sanity checks to ensure that
# testthat is correctly set up.
test_that("Harness works", {

  # knitr::normal_print() should not be found
  expect_error(normal_print("x"))

})

# testthat does not work well with packages that manipulate
# namespaces, so tests need to be run manually.
# (see $package_root/tests/test_import/.R)

# testthat starts in                $package_root/tests/testthat
# test_import tests should start in $package_root/tests/test_import
# Change to the right directory, then change back again at the end.
testthat_dir <- setwd(file.path("..","test_import"))

# Look for any files in test_import dir that start with "test"
# and run each of them in a new process. See test_import/test_template
# for an example of required parts for each test file
test_files <- list.files(".","^test")

for ( test_file in test_files ) {

  # Set context according to the file name
  context(test_file)

  # Setup a test sequence
  test_that(paste(test_file," works"), {

    # Skip on windows CI for now
    if ( isTRUE(as.logical(Sys.getenv("CI"))) &
         tolower(Sys.info()[["sysname"]]) == "windows" ) {
      skip("Skipping on CI Windows Action")
    }

    # Set up a new Rscript process to source the manual tests,
    # then check the output to examine if they ran correctly.
    rscript_file <- ifelse(Sys.info()['sysname']=="Windows","Rscript.exe","Rscript")
    rscript_path <- paste0("\"",file.path(R.home(),"bin",rscript_file),"\"")
    test_output <- system(paste(rscript_path, test_file), intern=TRUE)
    expect_match(
      test_output,
      "Import tests completed successfully ...",
      all=FALSE,
      label=paste(test_output,collapse="\n")
    )

  })
}

# Skipped tests in the test_import directory are not automatically reported.
# Any skipped tests can be noted here
context("List any skipped tests")
test_that("Recursive imports work (they do not)",{
  skip("Skipping this, implementation is not working")
})

# Switch back to the original directory, just to be safe
setwd(testthat_dir)
