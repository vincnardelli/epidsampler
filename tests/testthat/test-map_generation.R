set.seed(1234)
map <- genmap(verbose=F)

context("Map generation")

test_that("map generation parameters", {
  expect_equal(map$par, list(n = 5, p = c(10, 50), t = 0))
})

test_that("map generation condition", {
  expect_equal(map$condition,
               structure(list(), .Names = character(0), row.names = integer(0), class = "data.frame"))
})

test_that("map generation contact all zero", {
  expect_equal(0,
               sum(unlist(lapply(map$contacts, function(x) length(x)))))
})

test_that("map generation number of people", {
  expect_equal(map$map$p,
               c(15, 35, 34, 35, 44, 36, 10, 19, 37, 31, 38, 32, 21, 47, 22,
                 43, 21, 21, 17, 19, 23, 22, 16, 12, 19))
})

test_that("map generation starting exposed people", {
  expect_equal(sum(map$data$condition == "E"),
               10)
})

test_that("map generation print", {
  expect_equal(capture.output(print(map)),
               c("Epidmic generated map ", "Dimension 5 x 5 ", "Total 669 people"))
})

test_that("map generation plot", {
  expect_error(plot(map),
               "Not enough data")
})

test_that("map generation verbose", {
  expect_equal(capture.output(genmap())[1:2],
               c("1/2: Grid generated", "2/2: People generated"))
})


