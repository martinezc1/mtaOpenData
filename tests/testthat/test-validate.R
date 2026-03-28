# tests/testthat/test-validate.R

test_that(".mta_dataset_request validates limit", {
  expect_error(.mta_dataset_request("2ucp-7wg5", limit = "bad"), "limit.*single numeric", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", limit = NA), "limit.*non-missing", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", limit = -1), "limit.*between 0", ignore.case = TRUE)
})

test_that(".mta_dataset_request validates timeout_sec", {
  expect_error(.mta_dataset_request("2ucp-7wg5", timeout_sec = "bad"), "timeout_sec.*single numeric", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", timeout_sec = NA), "timeout_sec.*non-missing", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", timeout_sec = 0), "timeout_sec.*> 0", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", timeout_sec = -5), "timeout_sec.*> 0", ignore.case = TRUE)
})

test_that(".mta_dataset_request validates filters structure", {
  expect_error(.mta_dataset_request("2ucp-7wg5", filters = "not a list"), "filters.*named list", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", filters = list("QM3")), "filters.*named", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", filters = list(route_id = NA)), "filters.*NA", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", filters = list(route_id = character(0))), "filters.*empty", ignore.case = TRUE)
})

test_that(".mta_dataset_request validates order and where", {
  expect_error(.mta_dataset_request("2ucp-7wg5", order = 1), "order.*character", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", order = ""), "order.*non-empty", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", where = 1), "where.*character", ignore.case = TRUE)
  expect_error(.mta_dataset_request("2ucp-7wg5", where = NA_character_), "where.*non-missing", ignore.case = TRUE)
})

test_that(".mta_add_filters supports IN() for multi-value filters", {
  q <- .mta_add_filters(list(), list(route_id = c("QM3", "QM44")))
  expect_true(grepl("(TRIM\\(route_id\\)|route_id)\\s+IN\\s*\\(", q[["$where"]]))
  expect_true(grepl("'QM3'", q[["$where"]]))
  expect_true(grepl("'QM44'", q[["$where"]]))
})

test_that(".mta_add_where combines clauses with AND", {
  q <- .mta_add_filters(list(), list(route_id = "QM3"))
  q2 <- .mta_add_where(q, "direction == 'W'")
  expect_true(grepl("route_id", q2[["$where"]]))
  expect_true(grepl("direction", q2[["$where"]]))
  expect_true(grepl("\\) AND \\(", q2[["$where"]]))
})
