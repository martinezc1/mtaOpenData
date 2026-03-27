#' List datasets available in mtaOpenData
#'
#' Retrieves the current MTA Open Data catalog and returns datasets available
#' for use with `mta_pull_dataset()`.
#'
#' Keys are generated from dataset names using `janitor::make_clean_names()`.
#'
#' @return A tibble of available datasets, including generated `key`, dataset
#'   `uid`, and dataset `dataset_title`.
#' @examples
#' if (interactive() && curl::has_internet()) {
#'   mta_list_datasets()
#' }
#' @importFrom rlang .data
#' @export
mta_list_datasets <- function() {
  .mta_catalog_tbl()
}

.mta_catalog_tbl <- function() {
  raw <- .mta_dataset_request(
    dataset_id = "f462-ka72",
    limit = 50000,
    timeout_sec = 30,
    clean_names = TRUE,
    coerce_types = FALSE
  )

  raw |>
    dplyr::filter(.data$type == "dataset") |>
    dplyr::mutate(
      key = janitor::make_clean_names(.data$dataset_title)
    ) |>
    dplyr::filter(!is.na(.data$open_dataset_id), nzchar(.data$open_dataset_id)) |>
    dplyr::filter(!is.na(.data$nys_url_url)) |>
    dplyr::distinct(.data$open_dataset_id, .keep_all = TRUE) |>
    dplyr::relocate("dataset_title", "open_dataset_id", "key")
}
