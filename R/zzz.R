###
### Load greenGenesDB into namespace
###

.onAttach <- function(libname, pkgname){

    db_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package = pkgname, lib.loc = libname)

    metadata_file <- system.file("extdata", "gg13.5_metadata.RData",
                                package = pkgname, lib.loc = libname)

    ## Note no tree for gg13.5

    if (!file.exists(db_file) | !file.exists(metadata_file)) {
        packageStartupMessage("Greengenes 13.5 database data not present, use `get_greengenesDb.R` In the package inst/scripts directory to download the database into the package inst/extdata/ directory and reinstall the package")
    }
}

.onLoad <- function(libname, pkgname){
    ns <- asNamespace(pkgname)

    db_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package = pkgname, lib.loc = libname)

    metadata_file <- system.file("extdata", "gg13.5_metadata.RData",
                                package = pkgname, lib.loc = libname)

    ## Note no tree for gg13.5

    metadata <- readRDS(metadata_file)

    ## initiate new MgDB object
    ggMgDb <- newMgDb(db_file = db_file,
                      tree_file = "not available",
                      metadata = metadata)

    assign("gg13.5MgDb", ggMgDb, envir = ns)
    namespaceExport(ns, "gg13.5MgDb")

}
