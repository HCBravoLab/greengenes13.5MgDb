### Code to generate source files for a MgDb-object with data from the
### Greengenes 13.5 database
library(DECIPHER)
library(Biostrings)
library(metagenomeFeatures) ## Needed for the make_mgdb_sqlite function

## Database URL
db_root_url <- "ftp://greengenes.microbio.me/greengenes_release/gg_13_5"
taxa_url <- paste0(db_root_url, "/gg_13_5_taxonomy.txt.gz")
seq_url <- paste0(db_root_url, "/gg_13_5.fasta.gz")

## RNAcentral ids - external to greengenes
rnacentral_url <- paste0("ftp://ftp.ebi.ac.uk/pub/databases/RNAcentral",
                          "/releases/8.0/id_mapping/database_mappings/",
                          "greengenes.tsv")

## Downloaded files
taxa_file <- tempfile()
seq_file <- tempfile()
rnacentral_file <- tempfile()

## MD5 check sums from initial download
taxa_md5 <- "b6d5d28336af73ab46f3cfe89e26f654"
seq_md5 <- "3a832c3f486ab5f311acccdddd2cb54b"
rnacentral_md5 <- "653fe7608d6c1a4ba137f0b997844d5d"

## MgDb database files name
db_file <- "../extdata/gg13.5.sqlite"
metadata_file <- "../extdata/gg13.5_metadata.RDS"

### Download database files ####################################################
download_db <- function(url, file_name, md5){
    ## Downloade file and check to make sure MD5 checksum matches checksum for
    ## previously downloaded version

    download.file(url,file_name)
    new_md5 <- tools::md5sum(file_name)
    if (md5 != new_md5) warning("checksum does not match downloaded file.")
}

## Taxa Data
download_db(taxa_url, taxa_file, taxa_md5)

## RNAcentral data
download_db(rnacentral_url, rnacentral_file, rnacentral_md5)

## Seq Data
download_db(seq_url, seq_file, seq_md5)

### Create SQLite DB with Taxa and Seq Data ####################################
### Parse greengenes taxonomy
parse_greengenes <- function(taxonomy_file){
    taxa <- read.delim(taxonomy_file, stringsAsFactors = FALSE, header = FALSE)

    ## Generating a data frame with taxonomy
    taxa_df <- data.frame(Keys = as.character(taxa[,1]), stringsAsFactors = FALSE)

    taxonomy <- strsplit(taxa[,2],split = "; ")
    taxonomy_df <- data.frame(t(sapply(taxonomy,function(i){i})),
                                 stringsAsFactors = FALSE)
    colnames(taxonomy_df) <- c("Kingdom","Phylum","Class","Ord",
                               "Family","Genus","Species")

    ## Return as data.frame with Keys and taxonomic heirarchy
    cbind(taxa_df,taxonomy_df)
}

taxa_tbl <- parse_greengenes(taxa_file)

## Load RNAcentral data
rnacentral_ids <- read.delim(rnacentral_file,
                          stringsAsFactors = FALSE,
                          header = FALSE)

colnames(rnacentral_ids) <- c("rnacentral_ids", "database",
                             "Keys", "ncbi_tax_id",
                             "RNA_type", "gene_name")

## Dropping database, RNA_type, and gene_name columns
rnacentral_ids$database <- NULL
rnacentral_ids$RNA_type <- NULL
rnacentral_ids$gene_name <- NULL

## Converting GG ids to character strings - ensure compatible typing
rnacentral_ids$Keys <- as.character(rnacentral_ids$Keys)
taxa_tbl$Keys <- as.character(taxa_tbl$Keys)

## Adding RNAcentral and NCBI_tax ids to taxonomy table
taxa_tbl <- dplyr::left_join(taxa_tbl, rnacentral_ids)

## Reading sequence data file
seqs <- Biostrings::readDNAStringSet(seq_file)

## Creating MgDb formated sqlite database
metagenomeFeatures::make_mgdb_sqlite(db_name = "greengenes13.5",
                              db_file = db_file,
                              taxa_tbl = taxa_tbl,
                              seqs = seqs)

### Database Metadata ##########################################################
metadata <- list(ACCESSION_DATE = date(),
                 URL = "ftp://greengenes.microbio.me/greengenes_release/gg_13_5/",
                 DB_TYPE_NAME = "GreenGenes",
                 DB_VERSION = "13.5",
                 DB_TYPE_VALUE = "MgDb",
                 DB_SCHEMA_VERSION = "2.0")

saveRDS(metadata, file = metadata_file)
