# Summary

This repository contains an R function **to generate a new column with the phytoplankton groups** from *PR2 db* taxonomy.

There are two versions available: 

* one for the **9 rank-levels** from **v5.0.0** (that should work for later versions)

* one for the **8 rank-levels** from **v4.14**

The codes take into consideration the taxonomy is already parsed into columns for each taxonomic level. If your taxonomy is not parsed, this repository also provides the following codes for that propose:

* parse-tax-pr2-v5.0.0.R
* parse-tax-pr2-v4.1.4.R

To **flag and eventually remove non-phytoplankton groups** from the output, the following codes should do the job:

* flag-phyto-pr2-v.5.0.0.R
* flag-phyto-pr2-v.4.1.4.R
* flag-phyto-pr2-v.5.0.0-simplified.R
* flag-phyto-pr2-v.4.1.4-simplified.R

Please note the first versions attempt to remove strictly heterotrophic *Dynophyceae* from the table, but that's a moving window in the field as many taxa do not have their ecological function defined yet. Therefore, the **simplified versions** keep all *Dynophyceae* in the table, but note some taxa may be heterotrophic or mixotrophic. The code's choice will depend on the user's research question. 
