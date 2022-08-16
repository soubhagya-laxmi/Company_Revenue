
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

Sheet1 <- read_sheet(drive_get("sample"))

data <- data.frame()
for(x in 1:10)
{
  Search <- tolower(Sheet1$Company[x])
  Search <- str_to_title(Search)
  #Search <- Sheet1$Company[x]
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  Search_comp <- str_replace_all(string=Search_comp, pattern="&", repl="%26")
  url <- paste("https://www.google.com/search?q=",Search_comp,"+yahoo+finance+ticker+SES")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
  con <- url(Comp_url, "rb") 
  pg <- read_html(con)
  close(con)
  
  links <- html_attr(html_nodes(pg, "a"), "href")
  F1 <- grep("https://sg.finance.yahoo.com/quote/|https://finance.yahoo.com/quote",links)
  links[F1[1]]
  
  ticker <- str_match(links[F1[1]], c("quote/s*(.*?)\\s*&","quote/s*(.*?)\\s*%","quote/s*(.*?)\\s*?"))
  ticker <- ticker[1][1]
  ticker <- gsub("quote/|&|%|?|/","",ticker)
  new <- data.frame(Company = Sheet1$Company[x],Country = "🇮🇳 India",
                    Ticker = ticker)
  data <- rbind(data,new)
}
  View(data)
  
  sheet_append(drive_get("yahoo_Ticker"),data)
  
