flag_phyto <- function(data) {
  
  # List of non-phototrophic ochrophytes and Colpodellaceae (non-photrophic family of Chrompodellids)
  non_photo_ochrophytes <- c(
    "MOCH-3", "MOCH-4", "Pteridomonas", "Ciliophrys_infusionum", "Pedospumella", "Spumella", "Poteriospumella", "Oikomonas",
    "Chrysophyceae_Clade-F", "Chrysophyceae_Clade-G", "Chrysophyceae_Clade-H", "Chrysophyceae_Clade-I",
    "Chrysophyceae_Clade-EC2H", "Chrysophyceae_Clade-EC2I","Colpodellaceae"
  )
  
  # Phototrophic groups among "Other Gyrista" and "Euglenophyceae"
  other_photo <- c("Dictyochophyceae","Eustigmatophyceae", "Xanthophyceae", "Chrysoparadoxophyceae", "Olisthodiscophyceae", "Synchromophyceae","Euglenophyceae")
  
  # Apply classification
  data %>%
    mutate(is_phyto = case_when(
      
      # Rule 1: Phototrophic Gyrista classes & Euglenophyceae → Yes
      apply(select(., Class:Order), 1, function(x) any(x %in% other_photo)) ~ "Yes",

      # Rule 2: Not phytoplankton groups
      taxo_phyto %in% c("Other Gyrista", "Other Stramenopiles", "Unclassified Archaeplastida",
                        "Unclassified Gyrista", "Unclassified Stramenopiles","Other") ~ "No",
      
      # Rule 3: Dinophyceae → Yes
      Class == "Dinophyceae" ~ "Yes",
      
      # Rule 4: Match non-photo ochrophytes at any level → No
      apply(select(., Domain:Species), 1, function(x) any(x %in% non_photo_ochrophytes)) ~ "No",
      
      # Rule 5: All others → Yes
      
      TRUE ~ "Yes"
    ))
}
