set.seed(1234)
map <- generate(n=4, P=100, save_movements = TRUE, type = "grid")
phase1 <- . %>%
  move_uniform(m=0.2, s=3) %>%
  meet(cn=3, cp=4, im=2) %>%
  move_back()
map <- run(map, phase1, days = 1, tE=5, tA=14,
           tI=14, ir=1, cfr=0.15, verbose = F)


context("Run")
test_that("plot", {
  expect_true("ggplot" %in% class(plot(map)))
})

test_that("add step", {
  expect_equal(map$par$t, 1)
})
