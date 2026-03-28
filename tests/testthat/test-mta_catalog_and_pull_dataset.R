test_that("mta_list_datasets returns a catalog tibble with expected columns", {
  skip_if_not_installed("vcr")
  skip_if_not_installed("curl")
  skip_if_no_cassette("mta_list_datasets_catalog")

  vcr::use_cassette("mta_list_datasets_catalog", {
    cat <- mta_list_datasets()

    expect_s3_class(cat, "tbl_df")
    expect_gte(nrow(cat), 1)
    expect_true(all(c("key", "open_dataset_id", "dataset_title") %in% names(cat)))
  })
})

test_that("mta_pull_dataset returns a tibble, respects limits, supports filters + date/from/to", {
  skip_if_not_installed("vcr")
  skip_if_not_installed("curl")
  skip_if_no_cassette("mta_pull_dataset_robust")

  dataset_open_dataset_id <- "2ucp-7wg5"

  vcr::use_cassette("mta_pull_dataset_robust", {
    base <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      timeout_sec = 60
    )
    expect_s3_class(base, "tbl_df")
    expect_gte(nrow(base), 0)
    expect_lte(nrow(base), 2)
    expect_gt(ncol(base), 0)
    expect_true(all(!grepl("\\.", names(base))))

    f1 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      filters = list(route_id = "QM3"),
      timeout_sec = 60
    )
    expect_s3_class(f1, "tbl_df")
    expect_gte(nrow(f1), 0)
    expect_lte(nrow(f1), 2)

    f2 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      filters = list(route_id = c("QM3", "QM44")),
      timeout_sec = 60
    )
    expect_s3_class(f2, "tbl_df")
    expect_gte(nrow(f2), 0)
    expect_lte(nrow(f2), 2)

    d1 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      date = "2020-11-20",
      date_field = "valid_from",
      limit = 2,
      timeout_sec = 60
    )
    expect_s3_class(d1, "tbl_df")
    expect_gte(nrow(d1), 0)
    expect_lte(nrow(d1), 2)

    d2 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      from = "2020-11-20",
      to = "2020-11-21",
      date_field = "valid_from",
      limit = 2,
      timeout_sec = 60
    )
    expect_s3_class(d2, "tbl_df")
    expect_gte(nrow(d2), 0)
    expect_lte(nrow(d2), 2)

    d3 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      from = "2020-11-20",
      date_field = "valid_from",
      limit = 2,
      timeout_sec = 60
    )
    expect_s3_class(d3, "tbl_df")
    expect_gte(nrow(d3), 0)
    expect_lte(nrow(d3), 2)

    d4 <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      to = "2020-11-20",
      date_field = "valid_from",
      limit = 2,
      timeout_sec = 60
    )
    expect_s3_class(d4, "tbl_df")
    expect_gte(nrow(d4), 0)
    expect_lte(nrow(d4), 2)
  })
})

test_that("mta_pull_dataset supports lookup by generated key as well as open_dataset_id", {
  skip_if_not_installed("vcr")
  skip_if_not_installed("curl")
  skip_if_no_cassette("mta_pull_dataset_key_lookup")

  vcr::use_cassette("mta_pull_dataset_key_lookup", {
    cat <- mta_list_datasets()

    row <- cat[cat$open_dataset_id == "2ucp-7wg5", , drop = FALSE]
    if (nrow(row) == 0) {
      skip("Known dataset not found in catalog")
    }

    dataset_key <- row$key[[1]]

    out <- mta_pull_dataset(
      dataset = dataset_key,
      limit = 2,
      timeout_sec = 60
    )

    expect_s3_class(out, "tbl_df")
    expect_lte(nrow(out), 2)
  })
})

test_that("mta_pull_dataset input validation errors", {
  expect_error(
    mta_pull_dataset(dataset = NA_character_),
    "`dataset` must be"
  )
  expect_error(
    mta_pull_dataset(dataset = ""),
    "`dataset` must be"
  )

  expect_error(
    mta_pull_dataset(dataset = "not_a_real_dataset", limit = 1),
    "Unknown dataset"
  )

  expect_error(
    mta_pull_dataset(
      dataset = "2ucp-7wg5",
      date = "2026-03-05",
      from = "2026-03-10",
      date_field = "valid_from"
    ),
    "either `date` OR `from`/`to`"
  )

  expect_error(
    mta_pull_dataset(
      dataset = "2ucp-7wg5",
      date = "11/20/2020",
      date_field = "valid_from",
      limit = 1
    ),
    "YYYY-MM-DD"
  )

  expect_error(
    mta_pull_dataset(
      dataset = "2ucp-7wg5",
      from = "2020-11-20",
      limit = 1
    ),
    "must also provide a single non-empty `date_field`"
  )

  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", limit = "a string"),
    "`limit` must be"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", limit = NA),
    "`limit` must be"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", limit = -1),
    "between 0 and Inf"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", limit = 1.2),
    "integer"
  )

  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", filters = "not a list"),
    "`filters` must be"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", filters = list("QM3")),
    "named"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", filters = list(route_id = character(0))),
    "cannot be empty"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", filters = list(route_id = NA_character_)),
    "cannot contain NA"
  )

  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", timeout_sec = 0),
    "`timeout_sec` must be > 0"
  )
  expect_error(
    mta_pull_dataset(dataset = "2ucp-7wg5", timeout_sec = "fast"),
    "`timeout_sec` must be"
  )
})

test_that("mta_pull_dataset supports clean_names/coerce_types toggles", {
  skip_if_not_installed("vcr")
  skip_if_not_installed("webmockr")
  skip_if_not_installed("curl")
  skip_if_no_cassette("mta_pull_dataset_toggles")

  dataset_open_dataset_id <- "2ucp-7wg5"

  vcr::use_cassette("mta_pull_dataset_toggles", {
    a <- mta_pull_dataset(dataset = dataset_open_dataset_id, limit = 2, timeout_sec = 60)
    expect_s3_class(a, "tbl_df")
    expect_lte(nrow(a), 2)

    b <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      clean_names = FALSE,
      timeout_sec = 60
    )
    expect_s3_class(b, "tbl_df")
    expect_lte(nrow(b), 2)

    c <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      coerce_types = FALSE,
      timeout_sec = 60
    )
    expect_s3_class(c, "tbl_df")
    expect_lte(nrow(c), 2)

    d <- mta_pull_dataset(
      dataset = dataset_open_dataset_id,
      limit = 2,
      clean_names = FALSE,
      coerce_types = FALSE,
      timeout_sec = 60
    )
    expect_s3_class(d, "tbl_df")
    expect_lte(nrow(d), 2)

    expect_gt(ncol(a), 0)
    expect_gt(ncol(b), 0)
    expect_gt(ncol(c), 0)
    expect_gt(ncol(d), 0)
  })
})

test_that("mta_pull_dataset throws internal error if catalog is corrupted", {
  corrupted_catalog <- tibble::tibble(
    key = "some_dataset",
    dataset_title = "Some Dataset"
  )

  testthat::with_mocked_bindings(
    .mta_catalog_tbl = function() corrupted_catalog,
    {
      expect_error(
        mta_pull_dataset("some_dataset"),
        "Internal error: catalog missing required column"
      )
    }
  )
})

test_that("mta_pull_dataset errors if multiple matches found", {
  duplicate_catalog <- tibble::tibble(
    key = c("duplicate", "duplicate"),
    open_dataset_id = c("open_dataset_id-1", "open_dataset_id-2"),
    dataset_title = c("Dataset 1", "Dataset 2")
  )

  testthat::with_mocked_bindings(
    .mta_catalog_tbl = function() duplicate_catalog,
    {
      expect_error(
        mta_pull_dataset("duplicate"),
        "Multiple catalog matches found"
      )
    }
  )
})
