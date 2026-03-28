# List datasets available in mtaOpenData

Retrieves the current MTA Open Data catalog and returns datasets
available for use with \`mta_pull_dataset()\`.

## Usage

``` r
mta_list_datasets()
```

## Value

A tibble of available datasets, including generated \`key\`, dataset
\`uid\`, and dataset \`dataset_title\`.

## Details

Keys are generated from dataset names using
\`janitor::make_clean_names()\`.

## Examples

``` r
if (interactive() && curl::has_internet()) {
  mta_list_datasets()
}
```
