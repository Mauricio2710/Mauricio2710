# Limpiar pantalla y remover objetos existentes
cat("\014") 
rm(list = ls())

## Bases de datos ordenadas ("tidy") 

library("tidyverse")
library("janitor")
library("readr") 

setwd("/Users/Mauricio/Library/Mobile Documents/com~apple~CloudDocs/Teaching/ISUC/2020_2_data_analysis_r/repo/slides/class_10/")
va_messy <-read.delim("value_added_agricultue.csv", sep= ";")
va_messy

va_data <- va_messy %>% row_to_names(row_number = 1) %>% 
  rename(country = 1) %>% 
  mutate(across(`1800`:`1938`, ~ as.character(.x))) %>% 
  pivot_longer(cols = -c("country"), names_to = "year", values_to = "added_value") %>% 
  mutate(added_value = if_else(added_value == "", NA_character_,added_value)) %>% 
  drop_na(added_value) %>%
  arrange(year,country)
va_data 

## Valores perdidos implícitos

va_data %>% complete(country,year) 

va_data %>% complete(country,year, 
                     fill = list(added_value = 0)) 


## Completa valores perdidos

va_data %>% complete(country,year) %>% 
  filter(country=="Austria", year > 1913) %>%
  fill(added_value, .direction = c("down")) 


va_data %>% complete(country,year) %>% 
  filter(country=="Austria", year > 1913) %>%
  fill(added_value, .direction = c("up")) 


va_data %>% complete(country,year) %>% 
  filter( (country=="Argentina" & year > 1934) | (country=="Australia" & year < 1804) ) %>%
  group_by(country) %>% 
  fill(added_value, .direction = c("down")) 



## Remover valores perdidos controladamente

dummy_data <- va_data %>% complete(country,year) %>% 
  filter(country=="Austria", year > 1913) %>% 
  mutate(y = c(NA,NA,sample(1:32,23)))

dummy_data %>% drop_na() 

dummy_data %>% drop_na(added_value) 

dummy_data %>% drop_na(ends_with("y")) 


## Reemplazar valores perdidos controladamente

dummy_data %>% 
  replace_na(list(country = "Hola",  
                  added_value = 0, 
                  y = 999)) 

