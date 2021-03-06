# setup
usethis::use_build_ignore("dev")

# Description
usethis::use_description(
  list(
    Title = "Simulations for Sampling in Epidemics",
    `Authors@R` = "c(
    person('Vincenzo', 'Nardelli', email = 'vincnardelli@gmail.com', role = c('cre', 'aut')),
    person('Giorgio', 'Alleva', role = c('ctb')),
    person('Giuseppe', 'Arbia', email = 'giuseppearbia13@gmail.com', role = c('ctb')),
    person('Piero Demetrio', 'Falorsi', role = c('ctb')),
    person('Alberto', 'Zuliani', role = c('ctb'))
    )",
    Description = "Simulate an epidemic map with mobility and social interaction between individuals. Useful for testing sampling methods.",
    URL = "https://github.com/vincnardelli/epidsampler"
  )
)
usethis::use_lgpl_license( name = "Vincenzo Nardelli" )
usethis::use_tidy_description()

usethis::use_package("dplyr")
usethis::use_package("ggplot2")
usethis::use_package("spdep")
usethis::use_package("purrr")
usethis::use_package("testthat", "Suggest")
usethis::use_package("magrittr", "Suggest")
usethis::use_package("utils", "Suggest")

usethis::use_vignette(name="epidsampler")


# Read me
usethis::use_readme_md( open = FALSE )


# Test that
usethis::use_testthat()
usethis::use_test("map_generation")
usethis::use_test("map_step")


usethis::use_git_config(
  scope = "user",
  user.name = "Vincenzo Nardelli",
  user.email = "vincnardelli@gmail.com"
)
usethis::use_git()


# CI
usethis::use_travis()
usethis::use_coverage()
usethis::use_lifecycle_badge("experimental")
usethis::use_github_action_check_standard()

# Website
usethis::use_pkgdown()
pkgdown::build_site()
usethis::use_github_action("pkgdown")
