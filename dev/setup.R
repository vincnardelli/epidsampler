# setup
usethis::use_build_ignore("dev")

#usethis::use_package("dplyr")
#usethis::use_package("ggplot2")
#usethis::use_package("testthat")

usethis::use_description(
  list(
    Title = "epidsampler",
    `Authors@R` = "c(
    person('Vincenzo', 'Nardelli', email = 'vincnardelli@gmail.com', role = c('cre', 'aut')),
    person('Giuseppe', 'Arbia', email = 'giuseppearbia13@gmail.com', role = c('aut')))",
    Description = "A package for generating simulated epidemic dataset. Useful for testing sampling methods.",
    URL = "https://github.com/vincnardelli/epidsampler"
  )
)
usethis::use_lgpl_license( name = "Vincenzo Nardelli" )
usethis::use_tidy_description()

usethis::use_readme_md( open = FALSE )

usethis::use_testthat()
usethis::use_test("map_generation")
usethis::use_test("map_step")


usethis::use_git_config(
  scope = "user",
  user.name = "Vincenzo Nardelli",
  user.email = "vincnardelli@gmail.com"
)
usethis::use_git()

usethis::use_travis()
usethis::use_coverage()


#usethis::use_vignette(name="linear_model_with_gradient_package")
