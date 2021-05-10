# setup
usethis::use_build_ignore("dev")

# Description
usethis::use_description(
  list(
    Title = "Simulations for Sampling in Epidemics",
    `Authors@R` = "c(
    person('Vincenzo', 'Nardelli', email = 'vincnardelli@gmail.com', role = c('cre', 'aut', 'cph'), comment = c(ORCID = '0000-0002-7215-7934')),
    person('Giorgio', 'Alleva', role = c('ctb'), comment = c(ORCID = '0000-0002-3910-3029')),
    person('Giuseppe', 'Arbia', email = 'giuseppearbia13@gmail.com', role = c('ctb')),
    person('Piero Demetrio', 'Falorsi', role = c('ctb'), comment = c(ORCID = '0000-0001-5173-3931')),
    person('Alberto', 'Zuliani', role = c('ctb'))
    )",
    Description = "Simulate an epidemic map with mobility and social interaction between individuals. Useful for testing sampling methods.",
    URL = "https://github.com/vincnardelli/epidsampler"
  )
)
usethis::use_lgpl_license()
usethis::use_tidy_description()

usethis::use_package("magrittr")
usethis::use_pipe(export = TRUE)
usethis::use_package("dplyr", min_version = T)
usethis::use_package("sf", min_version = T)
usethis::use_package("ggplot2", min_version = T)
usethis::use_package("spdep")
usethis::use_package("purrr", min_version = T)
usethis::use_package("parallel")
usethis::use_package("progress")
usethis::use_package("gganimate", min_version = T)
usethis::use_package("testthat", "Suggest", min_version = T)
usethis::use_package("utils", "Suggest")
usethis::use_package("methods")
usethis::use_package("stats")
usethis::use_vignette(name="epidsampler")

# URL and bugReports
use_github_links(overwrite = T)


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
usethis::use_github_action_check_standard(save_as="test.yaml")
usethis::use_github_action("test-coverage")

# Website
usethis::use_pkgdown()
pkgdown::build_site()
usethis::use_github_action("pkgdown")
