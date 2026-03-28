# Pull a MTA Open Data dataset from the MTA Open Data catalog

Uses a dataset \`key\` or \`open_dataset_id\` from
\`mta_list_datasets()\` to pull data from MTA Open Data.

## Usage

``` r
mta_pull_dataset(
  dataset,
  limit = 10000,
  filters = list(),
  date = NULL,
  from = NULL,
  to = NULL,
  date_field = NULL,
  where = NULL,
  order = NULL,
  timeout_sec = 30,
  clean_names = TRUE,
  coerce_types = TRUE
)
```

## Arguments

- dataset:

  A dataset key or open_dataset_id from \`mta_list_datasets()\`.

- limit:

  Number of rows to retrieve (default = 10,000).

- filters:

  Optional named list of filters. Supports vectors (translated to IN()).

- date:

  Optional single date (matches all times that day) using
  \`date_field\`.

- from:

  Optional start date (inclusive) using \`date_field\`.

- to:

  Optional end date (exclusive) using \`date_field\`.

- date_field:

  Optional date/datetime column to use with \`date\`, \`from\`, or
  \`to\`. Must be supplied when \`date\`, \`from\`, or \`to\` are used.

- where:

  Optional raw SoQL WHERE clause. If \`date\`, \`from\`, or \`to\` are
  provided, their conditions are AND-ed with this.

- order:

  Optional SoQL ORDER BY clause.

- timeout_sec:

  Request timeout in seconds (default = 30).

- clean_names:

  Logical; if TRUE, convert column names to snake_case (default = TRUE).

- coerce_types:

  Logical; if TRUE, attempt light type coercion (default = TRUE).

## Value

A tibble.

## Details

Dataset keys are generated from dataset_title using
\`janitor::make_clean_names()\`. Because keys are derived from live
catalog metadata, dataset open_dataset_ids are the more stable option.

## Examples

``` r
if (interactive() && curl::has_internet()) {
  # Pull by key
  mta_pull_dataset("mta_bus_stops", limit = 3)

  # Pull by open_dataset_id
  mta_pull_dataset("2ucp-7wg5", limit = 3)

  # Filters
  mta_pull_dataset("2ucp-7wg5", limit = 3, filters = list(route_id = "QM3"))

}
```
