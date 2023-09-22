
## Build package, documentation, and readme (before commits)
{
  devtools::document()
  devtools::build_readme()
  devtools::spell_check()
  devtools::build()
  devtools::test()
  message("Pre-commit tasks completed")
}

## Build vignettes and site
{
  devtools::build_vignettes()
  devtools::build_manual()
  devtools::build_site()
}

## Final checks (before release)
{
  system("R CMD INSTALL --preclean --no-multiarch --with-keep.source .")
  devtools::spell_check()
  devtools::check()
  devtools::release_checks()
  devtools:::git_checks()
}


## Remote/long-running checks (copy to terminal and run manually)
# devtools::check_rhub()
# devtools::check_win_devel()
# revdepcheck::revdep_check(num_workers = 4)

## Finally submit to cran (copy to terminal and run manually)
# devtools::release()
