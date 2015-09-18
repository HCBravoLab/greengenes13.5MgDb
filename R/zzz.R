###
### Load greenGenesDB into namespace
###

.onLoad <- function(libname, pkgname)
{
    ns <- asNamespace(pkgname)
    seq_file <- system.file("extdata", 'gg_13_5_seq.rds', #"gg_13_5.fasta.gz",
                            package=pkgname, lib.loc=libname)

    db_taxa_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package=pkgname, lib.loc=libname)


    if(!file.exists(seq_file) || !file.exists(db_taxa_file)){
        print("Green genes 13.5 database data not present, use `getGreenGenes13.5Db.R` In the package inst/scripts directory to downlod the database into the package data/ directory and reinstall the package")
        ## not sure this is the best error message
    }

    metadata = list(URL = "https://greengenes.microbio.me",
                    DB_TYPE_NAME = "GreenGenes",
                    DB_VERSION = "gg_13_5",
                    ACCESSION_DATE = "July 20, 2015")

    ## load database sequence object
    db_seq <- readRDS(seq_file) #Biostrings::readDNAStringSet(seq_file)

    ## initiate new MgDB object
    ggMgDb <- new("MgDb",seq = db_seq,
                  taxa = db_taxa_file,
                  metadata = metadata)

    assign("gg13.5MgDb", ggMgDb, envir=ns)
    namespaceExport(ns, "gg13.5MgDb")

}
