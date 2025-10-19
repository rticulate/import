## General

Version 1.3.4 adds `import::what()` to list available objects for import,
and provides some documentation improvements:

* New function, import::what(), which lists objects available for import from
  a given package or module.
* Documentation links now point both to release and development documentation.
* Other minor documentation improvements.

More info in `NEWS.md`


## Test environments

* local Mac OS X (R 4.5.1)
* r-hub 
* win-builder
* GitHub CE (macos, linux and windows)


## R CMD check results

There were no ERRORs, WARNINGs, or NOTEs.


## revdepcheck results

We checked 12 reverse dependencies (10 from CRAN + 2 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Other Notes (unchanged since last release):

The package's functionality may alter the search path, but this is intended and should be clear for the user, as the main functionality is an alternative to using `library`. For example the call:

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the imported there.

