test_that("create_business_report() scaffolds a project with expected structure", {
  skip_if_not_installed("fs")
  skip_if_not_installed("withr")

  withr::with_tempdir({
    path <- create_business_report(
      path   = "test-project",
      title  = "Test Report",
      author = "Test Author",
      font   = "lato",
      toc_style   = 1L,
      cover       = TRUE,
      back_cover  = FALSE,
      open        = FALSE
    )

    # Project directory
    expect_true(fs::dir_exists(path))

    # report.qmd
    expect_true(fs::file_exists(fs::path(path, "report.qmd")))

    # Extension directory
    expect_true(fs::dir_exists(fs::path(path, "_extensions", "business-report")))

    # Config Typst file
    config_path <- fs::path(path, "_extensions", "business-report", "_business-report-config.typ")
    expect_true(fs::file_exists(config_path))

    # Config content
    config_lines <- readLines(config_path, warn = FALSE)
    config_text  <- paste(config_lines, collapse = "\n")

    expect_match(config_text, "Lato",  fixed = TRUE)
    expect_match(config_text, "toc-style:\\s+1")
    expect_match(config_text, "cover:\\s+true")
    expect_match(config_text, "back-cover:\\s+false")

    # Assets
    expect_true(fs::dir_exists(fs::path(path, "assets")))

    # report.qmd contains the title
    qmd_text <- paste(readLines(fs::path(path, "report.qmd"), warn = FALSE), collapse = "\n")
    expect_match(qmd_text, "Test Report", fixed = TRUE)
    expect_match(qmd_text, "Test Author",  fixed = TRUE)
  })
})

test_that("create_business_report() errors if path exists and overwrite = FALSE", {
  withr::with_tempdir({
    fs::dir_create("exists-already")
    expect_error(
      create_business_report("exists-already", open = FALSE),
      regexp = "already exists"
    )
  })
})

test_that("create_business_report() accepts overwrite = TRUE", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("my-project", open = FALSE)
    expect_no_error(
      create_business_report("my-project", overwrite = TRUE, open = FALSE)
    )
  })
})

test_that("set_font() updates config file correctly", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", open = FALSE)
    set_font("proj", font = "merriweather")
    config_text <- paste(
      readLines(
        fs::path("proj", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )
    expect_match(config_text, "Merriweather", fixed = TRUE)
  })
})

test_that("set_toc_style() updates config file correctly", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", toc_style = 1L, open = FALSE)
    set_toc_style("proj", style = 3L)
    config_text <- paste(
      readLines(
        fs::path("proj", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )
    expect_match(config_text, "toc-style:\\s+3")
  })
})

test_that("toggle_cover() updates config file correctly", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", cover = TRUE, open = FALSE)
    toggle_cover("proj", cover = FALSE)
    config_text <- paste(
      readLines(
        fs::path("proj", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )
    expect_match(config_text, "cover:\\s+false")
  })
})
