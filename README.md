This is an R Bioconductor Annotation package with the greengenes 13.5 database.
 (https://github.com/HCBravoLab/metagenomeFeatures.git).
The database data is formatted as a `MgDb-class` object defined in the metagenomeFeatures Bioconductor package (https://bioconductor.org/packages/release/bioc/html/metagenomeFeatures.html).

The package is available from (bioconductor)[https://bioconductor.org] https://bioconductor.org/packages/release/data/annotation/html/greengenes13.5MgDb.html.

To install the development version of the package:  
1. You need to use the development version of metagenomeFeatures, which can be installed using `devtools::install_github`.

```
devtools::install_github("HCBravoLab/metagenomeFeatures")
````

2. Download the source version of the annotation package
We have provided a link to a source version of the package with the database files as the database files are too large to include in the github repository. 
```
wget -v -O greengenes13.5MgDb_1.9.0.tar.gz https://umd.box.com/shared/static/kfl94pacgeuwmarm0m4o7v16ipyzywgy.gz 
```

3. Install using the downloaded file.  
```
install.packages("greengenes13.5MgDb_1.9.0.tgz", repo = NULL)
```

The metagenomeFeatures package has vignettes demonstrating how to work with `MgDb-class` objects.
