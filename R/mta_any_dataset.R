#' Load Any MTA Open Data Dataset
#'
#' Downloads any MTA Open Data dataset given its Socrata JSON endpoint.
#'
#' @param json_link A Socrata dataset JSON endpoint URL (e.g., "https://data.ny.gov/resource/2ucp-7wg5.json").
#' @param limit Number of rows to retrieve (default = 10,000).
#' @param timeout_sec Request timeout in seconds (default = 30).
#' @param clean_names Logical; if TRUE, convert column names to snake_case (default = TRUE).
#' @param coerce_types Logical; if TRUE, attempt light type coercion (default = TRUE).
#' @return A tibble containing the requested dataset.
#'
#' @examples
#' # Examples that hit the live MTA Open Data API are guarded so CRAN checks
#' # do not fail when the network is unavailable or slow.
#' if (interactive() && curl::has_internet()) {
#'   endpoint <- "https://data.ny.gov/resource/2ucp-7wg5.json"
#'   out <- try(mta_any_dataset(endpoint, limit = 3), silent = TRUE)
#'   if (!inherits(out, "try-error")) {
#'     head(out)
#'   }
#' }
#' @export
mta_any_dataset <- function(json_link,
                            limit = 10000,
                            timeout_sec = 30,
                            clean_names = TRUE,
                            coerce_types = TRUE) {

  if (!is.character(json_link) || length(json_link) != 1 || is.na(json_link)) {
    stop("`json_link` must be a single, non-missing character URL.", call. = FALSE)
  }
  if (!grepl("\\.json($|\\?)", json_link)) {
    stop("`json_link` must be a Socrata JSON endpoint ending in .json.", call. = FALSE)
  }

  limit <- .mta_validate_limit(limit)
  timeout_sec <- .mta_validate_timeout(timeout_sec)

  query_list <- list("$limit" = limit)

  data <- .mta_get_json(json_link, query_list, timeout_sec = timeout_sec)

  out <- tibble::as_tibble(data, .name_repair = "minimal")

  out <- .mta_postprocess(out, clean_names = clean_names, coerce_types = coerce_types)

  out
}
