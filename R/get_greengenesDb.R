### =========================================================================
### Downloading database greengenes 13_5 database
###
.fetch_db <- function(db_url, db_dir){
    f_basename <- strsplit(db_url, split = "/") %>% unlist() %>% .[length(.)]
    f <- paste0(db_dir,"/",f_basename)
    download.file(db_url,destfile = f, method = "wget")
    return(f)
}

.load_taxa <- function(taxonomy_file, db_con){
    # Create the database
    taxa=read.delim(taxonomy_file,stringsAsFactors=FALSE,header=FALSE)
    keys = taxa[,1]
    taxa = strsplit(taxa[,2],split="; ")
    taxa = t(sapply(taxa,function(i){i}))
    taxa = cbind(keys,taxa)
    colnames(taxa) = c("Keys","Kingdom","Phylum","Class","Order","Family","Genus","Species")
    taxa = data.frame(taxa)
    dplyr::copy_to(db_con,taxa,temporary=FALSE, indexes=list(colnames(taxa)))
}

.buildGreenGenes13.5Db <- function(db_dir, db_type, db_name = "gg_13_5",
                                    taxa_url = "ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_5_taxonomy.txt.gz",
                                    seq_url = "ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_5.fasta.gz"
                                    ){
    if(db_type == "seq"){
        .fetch_db(seq_url, db_dir)
    }

    if(db_type == "tax"){
        db_taxa_file <- paste0(db_dir,"/",db_name, ".sqlite3")
        db_con <- dplyr::src_sqlite(db_taxa_file, create = T)
        taxonomy_file <- .fetch_db(taxa_url, db_dir)
        .load_taxa(taxonomy_file, db_con)
    }
}

#' getGreenGenes13.5Db download and build database
#'
#'
#' @return
#' @export
#'
#' @examples
getGreenGenes13.5Db <- function(pkgname="greengenes13.5MgDb"){
    pkg_path <- system.file(package=pkgname, lib.loc=.libPaths())
    path <- paste0(pkg_path,"inst/extdata")
    .buildGreenGenes13.5Db(db_dir = path, db_type = "seq")

    .buildGreenGenes13.5Db(db_dir = path, db_type = "tax")
}
