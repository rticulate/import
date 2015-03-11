## General
NB: This is a resubmit, as I forgot to ignore my 
cran-comments.md file! Version number increased to be able to submit again,
hope you don't waste time. Nothing else changed.

## Test environments
* local Windows installation (R 3.1.2)
* local Mac OS X (R 3.1.2)
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:
  Components with restrictions and base license permitting such:
  MIT + file LICENSE
  File 'LICENSE':
    YEAR: 2015
    COPYRIGHT HOLDER: Stefan Milton Bache

## Downstream dependencies
There are no downstream dependencies.

## Other Notes:
The package's functionality may alter the search path, but this
is intended and should be clear for the user, as the main functionality 
is an alternative to using `library`. For example the call 

`import::from(parallel, makeCluster, parLapply)`

will make an "imports" entry in the search path and place the
imported there.


