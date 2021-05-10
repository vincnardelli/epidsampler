set.seed(1234)
map <- generate(n = 4, P = 100, type = "grid")

context("Map generation")

test_that("map generation parameters", {
  expect_equal(map$par, list(n = 4, p = 1, P = 100, rho = 0, t = 0, save_movements = FALSE))
})

test_that("map generation contact all zero", {
  expect_equal(
    0,
    sum(unlist(lapply(map$contacts, function(x) length(x))))
  )
})

test_that("map generation starting exposed people", {
  expect_equal(
    sum(map$data$condition == "E"),
    10
  )
})

test_that("map generation print", {
  expect_equal(
    capture.output(print(map)),
    c("Epidmic generated map ", "Dimension 2 x 2 ", "Total 100 people")
  )
})

test_that("map generation plot", {
  expect_error(
    plot(map),
    "Not enough data"
  )
})

map <- generate(n = 4, P = 100, save_movements = TRUE)
test_that("map generation verbose", {
  expect_equal(
    map$movements,
    NULL
  )
})
