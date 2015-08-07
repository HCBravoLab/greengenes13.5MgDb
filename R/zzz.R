###
### Load greenGenesDB into namespace
###

.onAttach <- function(libname, pkgname)
{
    ns <- asNamespace(pkgname)
    path <- system.file("extdata", package=pkgname, lib.loc=libname)
    seq_file <- system.file("extdata", "gg_13_5.fasta.gz",
                          package=pkgname, lib.loc=libname)
    if(!file.exists(seq_file)){
        print("Green genes 13.5 database sequence data not present, use `getGreenGenes13.5Db()` to dowload database.")
        return()
    }

    db_taxa_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package=pkgname, lib.loc=libname)
    if(!file.exists(db_taxa_file)){
        print("Green genes 13.5 taxonomy database not present, use `getGreenGenes13.5Db()` to dowload database")
        return()
    }

    metadata = list(URL = "https://greengenes.microbio.me",
                    DB_TYPE_NAME = "GreenGenes",
                    DB_VERSION = "gg_13_5",
                    ACCESSION_DATE = "July 20, 2015")

    ## load database sequence object
    db_seq <- Biostrings::readDNAStringSet(seq_file)

    ## load taxa sqlite database
    db_taxa_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package=pkgname, lib.loc=libname)

    ## initiate new MgDB object
    ggMgDb <- new("MgDb",seq = db_seq,
        taxa = db_taxa_file,
        metadata = metadata)

    assign("gg13.5MgDb", ggMgDb, envir=ns)
    namespaceExport(ns, "gg13.5MgDb")

}
