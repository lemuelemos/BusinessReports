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

test_that("bundled Typst extension uses root-based imports and current outline API", {
  ext_dir <- system.file(
    "quarto", "_extensions", "business-report",
    package = "BusinessReport"
  )

  expect_true(nzchar(ext_dir))

  show_text <- paste(readLines(fs::path(ext_dir, "typst-show.typ"), warn = FALSE), collapse = "\n")
  template_text <- paste(readLines(fs::path(ext_dir, "typst-template.typ"), warn = FALSE), collapse = "\n")
  modern_toc <- paste(readLines(fs::path(ext_dir, "toc", "toc-modern.typ"), warn = FALSE), collapse = "\n")
  classic_toc <- paste(readLines(fs::path(ext_dir, "toc", "toc-classic.typ"), warn = FALSE), collapse = "\n")
  minimal_toc <- paste(readLines(fs::path(ext_dir, "toc", "toc-minimal.typ"), warn = FALSE), collapse = "\n")
  cards_toc <- paste(readLines(fs::path(ext_dir, "toc", "toc-cards.typ"), warn = FALSE), collapse = "\n")
  cover_text <- paste(readLines(fs::path(ext_dir, "cover.typ"), warn = FALSE), collapse = "\n")

  expect_no_match(show_text, '#import', fixed = TRUE)
  expect_match(show_text, '$if(title)$', fixed = TRUE)
  expect_match(show_text, '$if(by-author)$', fixed = TRUE)

  expect_match(template_text, '_extensions/business-report/_business-report-config.typ', fixed = TRUE)
  expect_match(template_text, 'logo-path:    "../../assets/logo.svg"', fixed = TRUE)
  expect_match(template_text, 'cover-image:  _cover-image', fixed = TRUE)
  expect_match(template_text, 'cover-title-color: _cover-title-color', fixed = TRUE)

  expect_match(cover_text, 'set text(fill: text-on-dark)', fixed = TRUE)
  expect_no_match(cover_text, 'font: "inherit"', fixed = TRUE)
  expect_match(cover_text, 'if cover-image != none', fixed = TRUE)
  expect_match(cover_text, 'dx: cover-title-x', fixed = TRUE)
  expect_match(cover_text, 'fill: cover-title-color', fixed = TRUE)

  for (toc_text in list(modern_toc, classic_toc, minimal_toc)) {
    expect_match(toc_text, 'it.element.body', fixed = TRUE)
    expect_match(toc_text, 'font-family', fixed = TRUE)
  }

  for (toc_text in list(modern_toc, classic_toc, minimal_toc)) {
    expect_match(toc_text, 'it.page()', fixed = TRUE)
    expect_match(toc_text, 'outline(title: none, depth: 3, indent: auto)', fixed = TRUE)
  }

  expect_match(cards_toc, 'counter(page).at(cap.location()).first()', fixed = TRUE)
  expect_match(cards_toc, 'cap.body', fixed = TRUE)
  expect_match(cards_toc, 'sec.body', fixed = TRUE)
  expect_match(cards_toc, 'font-family', fixed = TRUE)
})

test_that("create_business_report() writes cover_image to config when provided", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report(
      "cover-image-project",
      cover_image = "assets/minha-capa.png",
      cover_title_color = "#FFFFFF",
      cover_title_x = "18mm",
      cover_title_y = "110mm",
      open = FALSE
    )

    config_text <- paste(
      readLines(
        fs::path("cover-image-project", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )

    expect_match(config_text, 'cover-image:\\s+"\\.\\./\\.\\./assets/minha-capa\\.png"')
    expect_match(config_text, 'cover-title-color:\\s+rgb\\("#FFFFFF"\\)')
    expect_match(config_text, 'cover-title-x:\\s+18mm')
    expect_match(config_text, 'cover-title-y:\\s+110mm')
  })
})

test_that("create_business_report() rejects invalid cover_image values", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    expect_error(
      create_business_report("bad-cover-image", cover_image = 1, open = FALSE),
      regexp = "cover_image"
    )
  })
})

test_that("create_business_report() rejects invalid Typst lengths for cover title", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    expect_error(
      create_business_report("bad-cover-x", cover_title_x = "18", open = FALSE),
      regexp = "cover_title_x"
    )
    expect_error(
      create_business_report("bad-cover-y", cover_title_y = "abc", open = FALSE),
      regexp = "cover_title_y"
    )
  })
})

test_that("create_business_report() errors if path exists and overwrite = FALSE", {
  withr::with_tempdir({
    fs::dir_create("exists-already")
    expect_error(
      create_business_report("exists-already", open = FALSE),
      regexp = "ja existe"
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

test_that("create_business_report() writes report.qmd in UTF-8", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report(
      "utf8-project",
      title = "Relatório com Acentuação",
      author = "Área Técnica",
      open = FALSE
    )

    qmd_text <- paste(
      readLines(fs::path("utf8-project", "report.qmd"), warn = FALSE, encoding = "UTF-8"),
      collapse = "\n"
    )

    expect_match(qmd_text, "Relatório com Acentuação", fixed = TRUE)
    expect_match(qmd_text, "Introdução", fixed = TRUE)
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

test_that("set_primary_color() updates config file correctly", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", open = FALSE)
    set_primary_color("proj", color = "#8B1A1A")
    config_text <- paste(
      readLines(
        fs::path("proj", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )
    expect_match(config_text, 'primary-color:\\s+rgb\\("#8B1A1A"\\)')
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

test_that("toggle_back_cover() updates config file correctly", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", back_cover = TRUE, open = FALSE)
    toggle_back_cover("proj", back_cover = FALSE)
    config_text <- paste(
      readLines(
        fs::path("proj", "_extensions", "business-report", "_business-report-config.typ"),
        warn = FALSE
      ),
      collapse = "\n"
    )
    expect_match(config_text, "back-cover:\\s+false")
  })
})

test_that("config updates rewrite manually edited spacing into normalized format", {
  skip_if_not_installed("withr")
  withr::with_tempdir({
    create_business_report("proj", open = FALSE)

    config_path <- fs::path("proj", "_extensions", "business-report", "_business-report-config.typ")
    writeLines(
      c(
        "#let business-config = (",
        'font-family:"Georgia",',
        'primary-color:rgb("#1a3a5c"),',
        "toc-style:1,",
        "cover:true,",
        "cover-image:none,",
        'cover-title-color:rgb("#FFFFFF"),',
        "cover-title-x:18mm,",
        "cover-title-y:110mm,",
        "back-cover:true,",
        'lang:"pt",',
        ")"
      ),
      config_path
    )

    set_font("proj", font = "inter")

    config_lines <- readLines(config_path, warn = FALSE)
    config_text <- paste(config_lines, collapse = "\n")

    expect_match(config_text, 'font-family:\\s+"Inter"', perl = TRUE)
    expect_true(any(grepl("^  font-family:\\s+\"Inter\",$", config_lines)))
    expect_true(any(grepl("^  back-cover:\\s+true,$", config_lines)))
  })
})
