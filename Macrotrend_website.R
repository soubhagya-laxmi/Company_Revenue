
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
for(x in 1:100)
{
  Search <- Sheet1$Company[x]
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  url <- paste("https://www.google.com/search?q=",Search_comp,"revenue+macrotrends")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
  
  con <- url(Comp_url, "rb") 
  pg <- read_html(con)
  close(con)
  links <- html_attr(html_nodes(pg, "a"), "href")
  
  F2 <- grep("www.macrotrends.net",links)
  links[F2[1]]
  new_url <- str_match(links[F2[1]], "https\\s*(.*?)\\s*&")
  new_url <- new_url[1][1]
  new_url <- gsub("&","",new_url)
  
  new <- data.frame(Company = Sheet1$Company[x],Country = Sheet1$Country[x],
                    Website = new_url)
  
  data <- rbind(data,new) 
  #x<- x+1
}
View(data)

sheet_append(drive_get("Macrotrend_Website"),data)
