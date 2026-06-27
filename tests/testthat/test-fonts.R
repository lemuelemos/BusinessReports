test_that("list_fonts() returns a data frame with expected columns", {
  fonts <- list_fonts()
  expect_s3_class(fonts, "data.frame")
  expect_true(all(c("id", "display_name", "typst_family", "style", "license") %in% names(fonts)))
})

test_that("list_fonts() contains at least 10 fonts", {
  expect_gte(nrow(list_fonts()), 10L)
})

test_that("all font ids are unique", {
  fonts <- list_fonts()
  expect_equal(length(unique(fonts$id)), nrow(fonts))
})

test_that("every font has a non-empty typst_family", {
  fonts <- list_fonts()
  expect_true(all(nchar(fonts$typst_family) > 0L))
})

test_that(".check_font_id() returns typst_family for valid id", {
  result <- BusinessReport:::.check_font_id("georgia")
  expect_equal(result, "Georgia")
})

test_that(".check_font_id() errors on invalid id", {
  expect_error(
    BusinessReport:::.check_font_id("nonexistent-font"),
    regexp = "recognised font id|fonte"
  )
})

test_that("style column contains only translated style labels", {
  fonts <- list_fonts()
  expect_true(all(fonts$style %in% c("Serifada", "Sem serifa")))
})
