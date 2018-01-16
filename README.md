This is an R Bioconductor Annotation package with the greengenes 13.5 database.
 (https://github.com/HCBravoLab/metagenomeFeatures.git).
The database data is formatted as a `MgDb-class` object defined in the metagenomeFeatures Bioconductor package (https://bioconductor.org/packages/release/bioc/html/metagenomeFeatures.html).

The package is available from (bioconductor)[https://bioconductor.org] https://bioconductor.org/packages/release/data/annotation/html/greengenes13.5MgDb.html.

To install the development version of the package:  
1. You need to use the development version of metagenomeFeatures, which can be installed using `devtools::install_github`.

```
devtools::install_github("HCBravoLab/metagenomeFeatures")
````

2. clone this repository `git clone https://github.com/HCBravoLab/greengenes13.5MgDb.git`   

3. to download the database data, from the `inst/scripts` directory in the repository run the `get_greengenes13.5MgDb.R` script. Note the script requires `dplyr`, `RSQLite`, `phyloseq`, and `Biostrings`.  

4. install greengenes13.5MgDb, using `devtools::install_github`.
```
# replace `local/path` with the path to the downloaded git repo.   
install_local("local/path/greengenes13.5MgDb")`
```

The metagenomeFeatures package has vignettes demonstrating how to work with `MgDb-class` objects.
