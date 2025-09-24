##Function to generate a new column with the phytoplankton groups from taxonomy (PR2 v5.0.0)

#### phyto group column generator ####

phyto_tax <- function(data) {
  data %>%
    mutate(
      taxo_phyto = case_when(
        # Diatoms
        Class %in% c("Mediophyceae", "Bacillariophyceae", "Coscinodiscophyceae", "Diatomeae_X") ~ "Diatoms",
        
        # Named classes we keep as-is
        Class %in% c("Bolidophyceae", "Dictyochophyceae", "Chrysophyceae", "Raphidophyceae", 
                     "Phaeophyceae", "Pinguiophyceae", "Dinophyceae", "Pelagophyceae",
                     "Chlorarachniophyceae", "Chloropicophyceae", "Mamiellophyceae", "MOCH") ~ Class,
        
        # Other groups by subdivision/order/division
        Subdivision %in% c("Chrompodellids") ~ Subdivision,
        Order %in% c("Euglyphida") ~ Order,
        Division %in% c("Prasinodermophyta", "Streptophyta", "Rhodophyta", "Haptophyta", "Cryptophyta") ~ Division,
        
        # MOCH group
        grepl("Euglenophyceae", Order) ~ "Euglenophyceae",
        
        # Unclassified Archaeplastida
        grepl("Archaeplastida", Supergroup) & (is.na(Division) | grepl("^unclassified_", Division)) ~ "Unclassified Archaeplastida",
        
        # Unclassified Chlorophyta
        grepl("Chlorophyta", Division) & (is.na(Class) | grepl("^unclassified_", Class)) ~ "Unclassified Chlorophyta",
        
        # Other Chlorophyta
        Class %in% c("Chlorodendrophyceae", "Chlorophyceae", "Nephroselmidophyceae", "Pedinophyceae",
                     "Prasino-Clade-9", "Pyramimonadophyceae", "Trebouxiophyceae", "Ulvophyceae") ~ "Other Chlorophyta",
        Class %in% c("Chlorophyta_XX", "unclassified_Chlorophyta_X") ~ "Other Chlorophyta",
        
        # Other Gyrista
        Class %in% c("Chrysomerophyceae", "Developea", "Eustigmatophyceae", "Gyrista_X", "Hyphochytriomyceta","Peronosporomycetes",
                    "Pirsoniales", "Xanthophyceae", "Chrysoparadoxophyceae","Olisthodiscophyceae","Synchromophyceae") ~ "Other Gyrista",
        
        # Unclassified Gyrista
        grepl("Gyrista", Subdivision) & (is.na(Class) | grepl("^unclassified_", Class)) ~ "Unclassified Gyrista",
        
        # Unclassified Stramenopiles
        grepl("Stramenopiles", Division) & (is.na(Subdivision) | Subdivision == "Stramenopiles_X" | grepl("^unclassified_", Class)) ~ "Unclassified Stramenopiles",
        
        # Other Stramenopiles
        Subdivision %in% c("Bigyra") ~ "Other Stramenopiles",
        
        # Fallback
        TRUE ~ "Other"
      )
    )
}
