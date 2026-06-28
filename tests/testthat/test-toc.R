test_that("list_toc_styles() returns a data frame with four rows", {
  styles <- list_toc_styles()
  expect_s3_class(styles, "data.frame")
  expect_equal(nrow(styles), 4L)
  expect_true(all(c("id", "name", "description") %in% names(styles)))
})

test_that("toc style ids are 1, 2, 3, 4", {
  styles <- list_toc_styles()
  expect_equal(styles$id, 1L:4L)
})

test_that(".check_toc_style() returns integer for valid input", {
  expect_equal(BusinessReport:::.check_toc_style(1), 1L)
  expect_equal(BusinessReport:::.check_toc_style(2L), 2L)
  expect_equal(BusinessReport:::.check_toc_style(3), 3L)
  expect_equal(BusinessReport:::.check_toc_style(4), 4L)
})

test_that(".check_toc_style() errors on out-of-range value", {
  expect_error(BusinessReport:::.check_toc_style(0),  regexp = "between 1 and 4")
  expect_error(BusinessReport:::.check_toc_style(5),  regexp = "between 1 and 4")
  expect_error(BusinessReport:::.check_toc_style("x"), regexp = "between 1 and 4")
})

test_that(".check_color() accepts valid hex strings", {
  expect_equal(BusinessReport:::.check_color("#1a3a5c"), "#1a3a5c")
  expect_equal(BusinessReport:::.check_color("#FFFFFF"), "#FFFFFF")
})

test_that(".check_color() rejects invalid formats", {
  expect_error(BusinessReport:::.check_color("1a3a5c"),  regexp = "hex colour")
  expect_error(BusinessReport:::.check_color("#fff"),     regexp = "hex colour")
  expect_error(BusinessReport:::.check_color("#GGGGGG"), regexp = "hex colour")
})
