# Flag phytoplankton taxa using PR2 v4.14 (8 taxonomic ranks).
# Simplified version: all Dinophyceae are flagged 'Yes', even though
# some genera are heterotrophic or mixotrophic.
#
# Requires phyto_tax() output from phyto-tax-pr2-v4.1.4.R, with
# Domain, Supergroup, Division, Class, Order, Family, Genus, Species,
# and taxo_phyto. Returns an is_phyto column with 'Yes' or 'No'.
# No package dependencies; operates on a data.frame or tibble.

flag_phyto <- function(data) {
  ranks <- c("Domain", "Supergroup", "Division", "Class",
             "Order", "Family", "Genus", "Species")
  required <- c(ranks, "taxo_phyto")
  missing_columns <- setdiff(required, names(data))
  if (length(missing_columns)) {
    stop("Missing required columns: ", paste(missing_columns, collapse = ", "))
  }

  non_photo_groups <- c(
    "MOCH-3", "MOCH-4", "Pteridomonas", "Ciliophrys_infusionum", "Pedospumella",
    "Spumella", "Poteriospumella", "Oikomonas",
    "Chrysophyceae_Clade-F", "Chrysophyceae_Clade-G", "Chrysophyceae_Clade-H",
    "Chrysophyceae_Clade-I", "Chrysophyceae_Clade-EC2H", "Chrysophyceae_Clade-EC2I",
    "Colpodellaceae"
  )

  other_photo <- c(
    "Dictyochophyceae", "Eustigmatophyceae", "Xanthophyceae",
    "Chrysoparadoxophyceae", "Olisthodiscophyceae", "Synchromophyceae",
    "Euglenophyceae"
  )

  # PR2 v4.14 broad groups as assigned by phyto_tax().
  non_phyto_labels <- c(
    "Other Ochrophytes", "Other Stramenopiles",
    "Unclassified Archaeplastida", "Unclassified Stramenopiles", "Other"
  )

  matches_any_rank <- function(values, columns) {
    hit <- rep(FALSE, nrow(data))
    for (col in columns) hit <- hit | (data[[col]] %in% values)
    hit
  }

  flag <- rep("Yes", nrow(data))

  # Reverse precedence relative to the v5 simplified case_when().
  flag[matches_any_rank(non_photo_groups, ranks)] <- "No"
  flag[data$Class %in% "Dinophyceae"] <- "Yes"
  flag[data$taxo_phyto %in% non_phyto_labels] <- "No"
  flag[matches_any_rank(other_photo, c("Class", "Order"))] <- "Yes"

  data$is_phyto <- flag
  data
}
