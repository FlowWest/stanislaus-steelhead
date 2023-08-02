library(tidyverse)

# questions
# TODO 172 rows in steelhead adult/juvenile that have NA date


# carcass
carcass <- read.csv(here::here("data-raw", "steelhead-carcass-data-2021-2022.csv")) |>
  mutate(date = as.Date(date, format = "%m/%d/%Y"),
         notes = ifelse(notes == "", NA_character_, notes),
         adclip = ifelse(adclip %in% c("-", NA), "no sample", adclip),
         scales = ifelse(scales  %in% c("-", NA), "no sample", scales),
         head = ifelse(head  %in% c("-", NA), "no sample", head),
         otoliths = ifelse(otoliths %in% c("-", NA), "no sample", otoliths),
         fin_clip = ifelse(fin_clip  %in% c("-", NA), "no sample", fin_clip)) |> glimpse()

# redd
redd <- read.csv(here::here("data-raw", "steelhead-and-lamprey-redd-data-2021-2022.csv")) |>
  mutate(date = as.Date(date, format = "%m/%d/%Y"),
         pot_length_cm = ifelse(pot_length_cm == "", NA, pot_length_cm),
         pot_width_cm = ifelse(pot_width_cm == "", NA, pot_width_cm),
         pot_depth_cm = ifelse(pot_depth_cm == "", NA, pot_depth_cm),
         est_pot_substrate = ifelse(est_pot_substrate %in% c(" -", ""), NA, est_pot_substrate),
         est_tailspin_substrate = ifelse(est_tailspin_substrate %in% c("", " -"), NA, est_tailspin_substrate),
         est_ambient_substrate = ifelse(est_ambient_substrate %in% c("", " -"), NA, est_ambient_substrate),
         X = ifelse(X == "", NA, X),
         ambient_velocity_ms = ifelse(ambient_velocity_ms %in% c("", " -", "-"), NA, ambient_velocity_ms),
         average_velocity = ifelse(average_velocity %in% c("", " -", "-"), NA, average_velocity),
         fish_present = ifelse(fish_present == "", NA, fish_present),
         fish_1_sex = ifelse(fish_1_sex %in% c("", " -"), NA, fish_1_sex),
         fish_1_size = ifelse(fish_1_size %in% c("", " -"), NA, fish_1_size),
         fish_2_sex = ifelse(fish_2_sex %in% c("", " -"), NA, fish_2_sex),
         fish_2_size = ifelse(fish_2_size %in% c("", " -"), NA, fish_2_size),
         comments = ifelse(comments == "", NA, comments)) |>
  rename(species = specices) |>
  select(-c(tailspin_width_cm.1, X)) |>
  glimpse()

# environmental
environmental <- read.csv(here::here("data-raw", "daily-info-environmental-data-2021-2022.csv")) |>
  mutate(date = as.Date(date, format = "%m/%d/%Y"),
         river = ifelse(river == "", NA, river),
         crew_1 = ifelse(crew_1 == "", NA, crew_1),
         crew_2 = ifelse(crew_2 == "", NA, crew_2),
         crew_3 = ifelse(crew_3 %in% c("-", "", " -"), NA, crew_3),
         recorder = ifelse(recorder == "", NA, recorder),
         weather = ifelse(weather == "", NA, weather),
         secchi = ifelse(secchi %in% c("", "-", " -"), NA, secchi),
         notes = ifelse(notes == "", NA, notes),
         time_in = sub('(\\d{2})$', ':\\1', time_in),
         time_out = sub('(\\d{2})$', ':\\1', time_out)) |>
  glimpse()

# adult/juvenile
steelhead <- readxl::read_xlsx(here::here("data-raw", "adult-juvenile-steelhead-data-2021-2022.xlsx"),
                               col_types = c("guess", "numeric", "text", rep("numeric", 10))) |>
  glimpse()


# write to /data ----------------------------------------------------------
write.csv(carcass, here::here("data", "carcass.csv"), row.names = FALSE)
write.csv(redd, here::here("data", "redd.csv"), row.names = FALSE)
write.csv(environmental, here::here("data", "environmental.csv"), row.names = FALSE)
write.csv(steelhead, here::here("data", "steelhead.csv"), row.names = FALSE)


# read in to double check -------------------------------------------------
read.csv(here::here("data", "carcass.csv")) |> glimpse()
read.csv(here::here("data", "redd.csv")) |> glimpse()
read.csv(here::here("data", "environmental.csv")) |> glimpse()
read.csv(here::here("data", "steelhead.csv")) |> glimpse()
