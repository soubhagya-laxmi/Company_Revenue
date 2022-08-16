
library(httr)
library(XML)
library(xml2)
library(rvest)
library(readr)
library(htm2txt) 
library(googledrive)
library(googlesheets4)
library(stringr)
library(RCurl)


Sheet1 <- read_sheet(drive_get("Company_List"))

data <- data.frame()
for(x in x:nrow(Sheet1))
{
  Search <- str_to_lower(Sheet1$Company[x])
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  Search_comp <- str_replace_all(string=Search, pattern="&", repl="%26")
  
  url <- paste("https://www.google.com/search?q=",Search_comp,"+S%26P+credit+rating")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
  
  text <- gettxt(Comp_url)
  text <- str_replace_all(string=text, pattern="'s", repl=" s")
  score <- str_match(text, "'\\s*(.*?)\\s*'")[1][1]
 
  new <- data.frame(Company = Sheet1$Company[x],rating = score)
  
  data <- rbind(data,new)
}
View(data)
  
sheet_append(drive_get("Credit Rating Data"),data)
 

