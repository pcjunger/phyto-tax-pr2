# Summary

This repository contains an R function **to generate a new column with the phytoplankton groups** from *PR2 db* taxonomy.

There are two versions available: 

* one for the **9 rank-levels** from **v5.0.0** (that should work for later versions): phyto-tax-pr2-v5.0.0.R

* one for the **8 rank-levels** from **v4.14**: `phyto-tax-pr2-v4.14.R`

The codes take into consideration the taxonomy is already parsed into columns for each taxonomic level. If your taxonomy is not parsed, this repository also provides the following codes for that propose:

* parse-tax-pr2-v5.0.0.R
* parse-tax-pr2-v4.14.R

To **flag and eventually remove non-phytoplankton groups** from the output, the following codes should do the job:

* `flag-phyto-pr2-5.0.0.R`
* `flag-phyto-pr2-v4.14.R` (PR2 v4.14, 8 ranks)
* `flag-phyto-pr2-5.0.0-simplified.R`
* `flag-phyto-pr2-v4.14-simplified.R` (PR2 v4.14, 8 ranks)

The non-simplified flaggers mark known non-phototrophic *Dinophyceae* as `No` and ambiguous assignments as `Uncertain`. This classification remains provisional because the trophic mode of many taxa is incompletely described. The **simplified versions** flag all *Dinophyceae* as `Yes`, although some taxa may be heterotrophic or mixotrophic. The code's choice will depend on the user's research question. 


### PR2 v4.14 flagging

The two `flag-phyto-pr2-v4.14*.R` files are designed to run **after**
`phyto-tax-pr2-v4.14.R`. They expect eight separate rank columns
(`Domain`, `Supergroup`, `Division`, `Class`, `Order`, `Family`, `Genus`,
`Species`) plus the `taxo_phyto` column produced by `phyto_tax()`.

```r
library(dplyr)  # needed by phyto_tax()
source("phyto-tax-pr2-v4.14.R")
source("flag-phyto-pr2-v4.14.R")  # OR the -simplified.R version

data <- phyto_tax(data)
data <- flag_phyto(data)
table(data$is_phyto, useNA = "ifany")
```

The full version uses `Yes`, `No`, and `Uncertain`; the simplified
version uses `Yes` and `No` and flags all Dinophyceae as `Yes`.
Both check for non-phototrophic Ochrophyta and Colpodellaceae and use
`*` as the PR2 v4.14 unclassified-rank marker (rather than PR2 v5's
`unclassified_` labels). They **flag** records; neither function removes
rows. Review the ecological scope of ambiguous groups before treating
all `Yes` records as confirmed phototrophs.


## Acknowledgements
This repository was created under the framework of the EU-project [MARCO-BOLO](https://marcobolo-project.eu/). The MARCO-BOLO project is funded by the European Union under the Horizon Europe Programme, Grant Agreement No. 101082021 (MARCO-BOLO). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Executive Agency (REA). Neither the European Union nor the granting authority can be held responsible for them. UK participants in MARCO-BOLO are supported by the UKRI’s Horizon Europe Guarantee under the Grant No. 10068180 (MS); No. 10063994 (MBA); No. 10048178 (NOC).

![Fig1](https://raw.githubusercontent.com/pcjunger/eDNA-EOVs-HABs/main/figures_readme/MARCO-BOLO_logo_col.png)
