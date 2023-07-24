library(EDIutils)
library(EMLaide)
library(tidyverse)
library(readxl)
library(EML)

datatable_metadata <-
  dplyr::tibble(filepath = c("data/carcass.csv",
                             "data/redd.csv",
                             "data/environmental.csv",
                             "data/steelhead.csv"),
                attribute_info = c("data-raw/metadata/steelhead-carcass-metadata.xlsx",
                                   "data-raw/metadata/steelhead-and-lamprey-redd-metadata.xlsx",
                                   "data-raw/metadata/daily-info-environmental-data-metadata.xlsx",
                                   "data-raw/metadata/adult-juvenile-steelhead-data-metadata.xlsx"),
                datatable_description = c("Steelhead Carcass Survey and Chinook Escapement Survey",
                                          "Steelhead and Pacific Lamprey Redds",
                                          "Daily Environmental Data",
                                          "Obsverved Adult and Juvenile Steelhead, Chinook, and Lamprey"),
                datatable_url = paste0("https://raw.githubusercontent.com/FlowWest/stanislaus-steelhead/main/data/",
                                       c("carcass.csv",
                                         "redd.csv",
                                         "environmental.csv",
                                         "steelhead.csv")))

excel_path <- "data-raw/metadata/project-metadata-steelhead.xlsx"
sheets <- readxl::excel_sheets(excel_path)
metadata <- lapply(sheets, function(x) readxl::read_excel(excel_path, sheet = x))
names(metadata) <- sheets

abstract_docx <- "data-raw/metadata/Steelhead_abstract.docx"
methods_docx <- "data-raw/metadata/Steelhead_methods.docx"

#edi_number <- reserve_edi_id(user_id = Sys.getenv("EDI_USER_ID"), password = Sys.getenv("EDI_PASSWORD"))
# edi_number <- fill in with reserved edi number

dataset <- list() %>%
  add_pub_date() %>%
  add_title(metadata$title) %>%
  add_personnel(metadata$personnel) %>%
  add_keyword_set(metadata$keyword_set) %>%
  add_abstract(abstract_docx) %>%
  add_license(metadata$license) %>%
  add_method(methods_docx) %>%
  add_maintenance(metadata$maintenance) %>%
  add_project(metadata$funding) %>%
  add_coverage(metadata$coverage, metadata$taxonomic_coverage) %>%
  add_datatable(datatable_metadata)

# GO through and check on all units
custom_units <- data.frame(id = c("number of rotations", "NTU", "revolutions per minute", "number of fish"),
                           unitType = c("dimensionless", "dimensionless", "dimensionless", "dimensionless"),
                           parentSI = c(NA, NA, NA, NA),
                           multiplierToSI = c(NA, NA, NA, NA),
                           description = c("number of rotations",
                                           "nephelometric turbidity units, common unit for measuring turbidity",
                                           "number of revolutions per minute",
                                           "number of fish counted"))


unitList <- EML::set_unitList(custom_units)

eml <- list(packageId = edi_number,
            system = "EDI",
            access = add_access(),
            dataset = dataset,
            additionalMetadata = list(metadata = list(unitList = unitList))
)
edi_number
EML::write_eml(eml, paste0(edi_number, ".xml"))
EML::eml_validate(paste0(edi_number, ".xml"))
