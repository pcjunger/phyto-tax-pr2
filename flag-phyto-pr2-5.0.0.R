flag_phyto <- function(data) {
  
  # List of phototrophic Dinophyceae genera
  photo_dino <- c(
    "Pileidinium", "Posoniella", "Ceratium", "Neoceratium", "Protoceratium", "Ceratocorys", "Pyrodinium", "Alexandrium", "Amylax",
    "Gonyaulax", "Lingulodinium", "Coolia", "Ostreopsis", "Pyrocystis", "Fragilidium", "Pyrophacus", "Testudodinium", "Brachidinium",
    "Akashiwo", "Amphidinium", "Apicoporus", "Bispinodinium", "Cochlodinium", "Gymnodinium", "Gyrodinium", "Paragymnodinium", 
    "Margalefidinium", "Barrufeta", "Moestrupia", "Lepidodinium", "Spiniferodinium", "Togula", "Torodinium", "Hemidinium", "Karenia", 
    "Karlodinium", "Takayama", "Polykrikos", "Jadwigia", "Heterodinium", "Woloszynskia", "Blastodinium", "Adenoides", "Peridinium", 
    "Scrippsiella", "Peridiniopsis", "Amphidiniella", "Thecadinium", "Ensiculifera", "Azadinium", "Brandtodinium", "Bysmatrum", 
    "Glenodiniopsis", "Cachonina", "Heterocapsa", "Durinskia", "Galeidinium", "Kryptoperidinium", "Herdmania", "Calciodinellum", 
    "Glenodinium", "Leonella", "Parvodinium", "Pentapharsodinium", "Theleodinium", "Thoracosphaera", "Gloeodinium", "Phytodinium", 
    "Prorocentrum", "Biecheleria", "Polarella", "Pelagodinium", "Protodinium", "Borghiella", "Symbiodinium", "Spatulodinium",
    "Cladocopium","Breviolum","Durusdinium","Symbiodiniaceae_X","Effrenium","Fugacium","unclassified_Symbiodiniaceae","Zooxanthella",
    "Ansanella","Biecheleriopsis","Centrodinium","Fukuyoa","Gambierdiscus","Spiniferites","Tripos"
  )
  
  # List of certainly non-photosynthetic Dinophyceae genera
  non_photo_dino <- c(
    "Chytriodinium", "Crypthecodinium", "Diplopsalopsis", "Impagidinium", "Islandinium",
    "Nusuttodinium", "Oodinium", "Paulsenella", "Protoperidinium", "Sinophysis",
    "Warnowia"
  )
  
  # List of non-phototrophic ochrophytes
  non_photo_ochrophytes <- c(
    "MOCH-3", "MOCH-4", "Pteridomonas", "Ciliophrys_infusionum", "Pedospumella", "Spumella", "Poteriospumella", "Oikomonas",
    "Chrysophyceae_Clade-F", "Chrysophyceae_Clade-G", "Chrysophyceae_Clade-H", "Chrysophyceae_Clade-I",
    "Chrysophyceae_Clade-EC2H", "Chrysophyceae_Clade-EC2I"
  )
  
  # Phototrophic groups among "Other Gyrista" and "Euglenophyceae"
  other_photo <- c("Dictyochophyceae","Eustigmatophyceae", "Xanthophyceae", "Chrysoparadoxophyceae", "Olisthodiscophyceae", "Synchromophyceae","Euglenophyceae")

  # Apply classification
  data %>%
    mutate(is_phyto = case_when(
      
      # Rule 1: Phototrophic Gyrista classes & Euglenophyceae → Yes
      apply(select(., Class:Order), 1, function(x) any(x %in% other_photo)) ~ "Yes",
      #Class %in% other_photo ~ "Yes",
      
      # Rule 2: Not phytoplankton groups
      taxo_phyto %in% c("Other Gyrista", "Other Stramenopiles", "Unclassified Archaeplastida",
                        "Unclassified Gyrista", "Unclassified Stramenopiles","Other") ~ "No",
      
      # Rule 3a: Unclassified Dinophyceae at order level → Uncertain
      Class == "Dinophyceae" & (is.na(Order) | grepl("^unclassified", Order, ignore.case = TRUE)) ~ "Uncertain",
      
      # Rule 3b: Dinophyceae but in certainly non-photo genera → No
      Class == "Dinophyceae" & Genus %in% non_photo_dino ~ "No",
      
      # Rule 3c: Dinophyceae but genus not phototrophic → Uncertain
      Class == "Dinophyceae" & !(Genus %in% photo_dino) ~ "Uncertain",
      
      # Rule 4: Match non-photo ochrophytes at any level → No
      apply(select(., Domain:Species), 1, function(x) any(x %in% non_photo_ochrophytes)) ~ "No",
      
      # Rule 5: All others → Yes
      
      TRUE ~ "Yes"
    ))
}
