#function to parse taxonomy from pr2 (v4.14)

parse_pr2_taxonomy <- function(data) {
  data %>%
    mutate(taxonomy_split = str_split(taxonomy, '\\|', simplify = FALSE)) %>%
    rowwise() %>%
    mutate(tax_levels = list({
      split <- taxonomy_split
      length_split <- length(split)
      if (length_split < 8) {
        c(split, rep(NA, 8 - length_split))  # pad with NA
      } else {
        split[1:8]
      }
    })) %>%
    ungroup() %>%
    mutate(
      Domain = map_chr(tax_levels, 1),
      Supergroup = map_chr(tax_levels, 2),
      Division = map_chr(tax_levels, 3),
      Class = map_chr(tax_levels, 4),
      Order = map_chr(tax_levels, 5),
      Family = map_chr(tax_levels, 6),
      Genus = map_chr(tax_levels, 7),
      Species = map_chr(tax_levels, 8)
    ) %>%
    select(-taxonomy_split, -tax_levels)
}
