# Summary

This repository contains an R function **to generate a new column with the phytoplankton groups** from *PR2 db* taxonomy.

There are two versions available: 

* one for the **9 rank-levels** from **v5.0.0** (that should work for later versions)

* one for the **8 rank-levels** from **v4.14**

The codes take into consideration the taxonomy is already parsed into columns for each taxonomic level. If your taxonomy is not parsed, this repository also provides the following codes for that propose:

* parse-tax-pr2-v5.0.0.R
* parse-tax-pr2-v4.1.4.R

To **flag and eventually remove non-phytoplankton groups** from your table, the following codes should do the job:

* flag-phyto-v.5.0.0.R
* flag-phyto-v.4.1.4.R
