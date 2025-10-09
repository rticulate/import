## General

Version 1.3.3 is a bug fix release with the following fixes:

* Add conflicting name in error message
* Update docs to point to rticulate.github.io/import

More info in `NEWS.md`


## Test environments

* local Mac OS X (R 4.5.1)
* r-hub 
* win-builder
* GitHub CE (macos, linux and windows)


## R CMD check results

There were no ERRORs or WARNINGs.

On winbuilder, there were no NOTEs:

On r-hub.io, some platforms raise one or the other of the following notes:

+---
❯ checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''

❯ checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'
+---

These notes are not reproducible locally or on all platforms, and seem not to affect the output. The check reports no errors related to the PDF version of the manual:

#> * checking PDF version of manual ... [12s] OK


## revdepcheck results

We checked 13 reverse dependencies (12 from CRAN + 1 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages


## Other Notes (unchanged since last release):

The package's functionality may alter the search path, but this is intended and should be clear for the user, as the main functionality is an alternative to using `library`. For example the call:

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the imported there.

