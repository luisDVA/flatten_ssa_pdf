library(pdftools) # Text Extraction, Rendering and Converting of PDF Documents
library(dplyr) # A Grammar of Data Manipulation
library(stringi) # Character String Processing Facilities
library(purrr) # Functional Programming Tools
library(readr) # Read Rectangular Text Data
library(textutils) # Utilities for Handling Strings and Text


flatten_ssa_pdf <- function(pdfpath) {
  covtxt <- pdf_text(pdfpath)
  pagelines <- stri_split_lines(covtxt)

  read_cov_delim <- function(pagelines) {
    covlinestr <- pagelines %>% stri_trim_left()
    st_line <- which(stri_detect_regex(covlinestr, "^\\d"))[1]
    end_line <- which(stri_detect_regex(covlinestr, "Fuente")) - 1
    varnames <- c("Nº Caso", "Estado", "Sexo", "Edad", "Fecha de Inicio de síntomas", "Identificación de COVID-19 por RT-PCR en tiempo real", "Procedencia", "Fecha de llegada a México")
    if (is_empty(end_line) & is.na(st_line)) {
      covTablines <- c("")
    } else if (!is_empty(end_line)) {
      covTablines <- covlinestr[st_line:end_line]
    } else {
      covTablines <- covlinestr[st_line:length(covlinestr)]
    }

    regex_valign <- function(stringvec, reg_align, reg_insert, sepstr) {
      pos <- regexpr(reg_align, stringvec, perl = TRUE, ignore.case = TRUE)
      ns <- textutils::spaces(max(pos) - pos)
      for (i in seq_along(stringvec)) {
        stringvec[i] <- sub(reg_insert, ns[i], stringvec[i],
          perl = TRUE, ignore.case = TRUE
        )
      }
      sub(reg_align, sepstr, stringvec, perl = TRUE, ignore.case = TRUE)
    }

    regex_valign <- function(stringvec, reg_align, reg_insert, sepstr) {
      pos <- regexpr(reg_align, stringvec, perl = TRUE, ignore.case = TRUE)
      ns <- textutils::spaces(max(pos) - pos)
      for (i in seq_along(stringvec)) {
        stringvec[i] <- sub(reg_insert, ns[i], stringvec[i],
          perl = TRUE, ignore.case = TRUE
        )
      }
      sub(reg_align, sepstr, stringvec, perl = TRUE, ignore.case = TRUE)
    }

    covTablines <- stri_replace_all_regex(covTablines, "\\s{8,20}", "    ")
    covTablines <-
      regex_valign(covTablines,
        reg_align = "\\b(?=[A-Z])",
        reg_insert = "\\b(?=[A-Z])", sepstr = "  "
      )
    covTablines <-
      stri_replace_first_regex(covTablines, "(?<=\\sM|\\sF)\\s(?=\\d)", "   ")
    covTablines <-
      regex_valign(covTablines, "\\b(?=F\\s|M\\s)", "\\b(?=F\\s|M\\s)", "  ")
    covTablines <-
      stri_replace_first_regex(covTablines, "(?<=\\sM\\s|\\sF\\s)\\s+(?=\\d)", "   ")
    covTablines <-
      stri_replace_first_regex(covTablines, "([0-9]{2}[\\/]{1}[0-9]{2}[\\/]{1}[0-9]{4})", "  $1  ")
    covTablines <- stri_replace_first_regex(covTablines, "(?<=confirmado)(\\s+)(?=[A-Z])", "    ")
    covTablines <- regex_valign(
      covTablines, "\\b(?=[0-9]{2}[\\/]{1}[0-9]{2}[\\/]{1}[0-9]{4}$|NA$)",
      "\\b(?=[0-9]{2}[\\/]{1}[0-9]{2}[\\/]{1}[0-9]{4}$|NA$)", "  "
    )

    tryCatch({
      read_fwf(paste0(covTablines, collapse = "\n"),
        col_positions = fwf_empty(paste0(covTablines, collapse = "\n"),
          col_names = varnames
        )
      )
    },
    warning = function(cond) {
      message("readr issues")
      return(
        read_fwf(
          paste0(covTablines, collapse = "\n"),
          fwf_empty(stri_replace_all_regex(covTablines, "([A-Z])\\s(?=[A-Z])", "$1_"),
            col_names = varnames
          )
        )
      )
    },
    error = function(cond) {
      message("no lines on page")
      return(NULL)
    }
    )
  }

  map_df(pagelines, read_cov_delim)
}



