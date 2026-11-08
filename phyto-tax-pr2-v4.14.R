##Function to generate a new column with the phytoplankton groups from taxonomy (PR2 v4.14)

#### phyto group column generator ####
# _X = Other and * = unclassified

phyto_tax <- function(data) {
  data %>%
    mutate(
      taxo_phyto = case_when(
        # Diatoms
        Class %in% c("Bacillariophyta") ~ "Diatoms",
        
        # Named classes we keep as-is
        Class %in% c("Bolidophyceae", "Dictyochophyceae", "Chrysophyceae", "Raphidophyceae", 
                     "Phaeophyceae", "Pinguiophyceae", "Dinophyceae", "Pelagophyceae",
                     "Chlorarachniophyceae", "Chloropicophyceae", "Mamiellophyceae") ~ Class,
        
        # Other groups by subdivision/order/division
        Division %in% c("Chrompodellids") ~ Division,
        Order %in% c("Euglyphida") ~ Order,
        Division %in% c("Prasinodermophyta", "Streptophyta", "Rhodophyta", "Haptophyta", "Cryptophyta") ~ Division,
        
        # MOCH group
        grepl("MOCH", Class) ~ "MOCH",
        
        # Unclassified Archaeplastida
        grepl("Archaeplastida", Supergroup) & (is.na(Division) | grepl("\\*", Division)) ~ "Unclassified Archaeplastida",
        
        # Unclassified Chlorophyta
        grepl("Chlorophyta", Division) & (is.na(Class) | grepl("\\*", Class)) ~ "Unclassified Chlorophyta",
        
        # Other Chlorophyta
        Class %in% c("Chlorodendrophyceae", "Chlorophyceae", "Nephroselmidophyceae", "Pedinophyceae",
                     "Prasino-Clade-9", "Pyramimonadophyceae", "Trebouxiophyceae", "Ulvophyceae") ~ "Other Chlorophyta",
        Class %in% c("Chlorophyta_X") ~ "Other Chlorophyta",
        
        # Other Ochrophytes
        Class %in% c("Chrysomerophyceae", "Eustigmatophyceae","Xanthophyceae") ~ "Other Ochrophytes",
        
        # Unclassified Ochrophytes
        grepl("Ochrophyta", Division) & (is.na(Class) | grepl("\\*", Class)) ~ "Unclassified Ochrophytes",
        
        # Other Stramenopiles
        grepl("Stramenopiles", Supergroup) & (Division == "Stramenopiles_X") ~ "Other Stramenopiles",
        Class %in% c("Developea", "Hyphochytriomyceta","Peronosporomycetes","Pirsonia_Clade") ~ "Other Stramenopiles",

        # Unclassified Stramenopiles
        grepl("Stramenopiles", Supergroup) & (is.na(Division) | grepl("\\*", Division)) ~ "Unclassified Stramenopiles",
        
        # Fallback
        TRUE ~ "Other"
      )
    )
}
