###
### Load greenGenesDB into namespace
###

.onLoad <- function(libname, pkgname)
{
    ns <- asNamespace(pkgname)
    path <- system.file("extdata", package=pkgname, lib.loc=libname)
    seq_file <- system.file("extdata", "gg_13_5.fasta.gz",
                          package=pkgname, lib.loc=libname)
    if(!file.exists(seq_file)){
        .getGreenGenes13.5Db(db_dir = path, db_type = "seq")
        seq_file <- system.file("extdata", "gg_13_5.fasta.gz",
                                package=pkgname, lib.loc=libname)
    }

    db_seq <- Biostrings::readDNAStringSet(seq_file)


    db_taxa_file <- system.file("extdata", "gg_13_5.sqlite3",
                                package=pkgname, lib.loc=libname)
    if(!file.exists(db_taxa_file)){
        .getGreenGenes13.5Db(db_dir = path, db_type = "tax")
        db_taxa_file <- system.file("extdata", "gg_13_5.sqlite3",
                                    package=pkgname, lib.loc=libname)
    }

    metadata = list(URL = "https://greengenes.microbio.me",
                    DB_TYPE_NAME = "GreenGenes",
                    DB_VERSION = "gg_13_5",
                    ACCESSION_DATE = "July 20, 2015")

    ggMgDb <- new("MgDb",seq = db_seq,
        taxa = db_taxa_file,
        metadata = metadata)

    assign("gg13.5MgDb", ggMgDb, envir=ns)
    namespaceExport(ns, "gg13.5MgDb")

}
