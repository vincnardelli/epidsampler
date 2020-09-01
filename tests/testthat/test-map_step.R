set.seed(1234)
map <- genmap(verbose=F) %>%
  addsteps(n=2, m=0.03, s=4,
           cn=20, cp=5,
           im=3, tE=5, tA=14,
           tI=14, ir=0.25, cfr=0.15,
           verbose=F)

context("Add step")


test_that("plot", {
  expect_true("ggplot" %in% class(plot(map)))
})

test_that("add step", {
  expect_equal(map$par$t, 2)
})

test_that("null input in addstep", {
  expect_equal(addstep(map)$par$t, 3)
})

test_that("null input in addstep with verbose", {
  expect_equal(capture.output(addstep(map, verbose = T))[1],
               "Starting simulation in step  2 ")
})


test_that("change status to E", {
  set.seed(1234)
  map <- genmap() %>%
    addsteps(9, m=0, s=0, tE=2, tI=2, tA=2, ir=0.25, cfr=1, cn=1, cp=3, im=2, verbose=T)

  expect_true(sum(map$data$condition == "I") > 0)
  expect_true(sum(map$data$condition == "D") > 0)
  expect_true(sum(map$data$condition == "A") > 0)
  expect_true(sum(map$data$condition == "R") > 0)
})
