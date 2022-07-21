
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
for(x in x:1900)
{
  Search <- Sheet1$Company[x]
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  Search_comp <- str_replace_all(string=Search_comp, pattern="&", repl="%26")
  url <- paste("https://www.google.com/search?q=",Search_comp,"moneycontrol+profit+and+loss")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
  
  con <- url(Comp_url, "rb") 
  pg <- read_html(con)
  close(con)
  links <- html_attr(html_nodes(pg, "a"), "href")
  
  F2 <- grep("https://www.moneycontrol.com/financials/",links)
  #F2 <- grep("https://companiesmarketcap.com/*(.*?)\\s*/revenue/&",links)
  links[F2[1]]
  new_url <- str_match(links[F2[1]], "https\\s*(.*?)\\s*&")
  new_url <- new_url[1][1]
  new_url <- gsub("&","",new_url)
  
  # Macro trend revenue from website
  con <- url(new_url, "rb") 
  webpage <- read_html(con)
  tbls <- html_nodes(webpage, "table")
  tbls_ls <- webpage %>%
    html_nodes("table") %>%
    .[[1]] %>%
    html_table(fill = TRUE)
  close(con)
  
  colnames(tbls_ls) <- c("Year","Revenue")
  
  Revenue_2022 = tbls_ls[tbls_ls$Year %in% c("2022","2022 (TTM)"), "Revenue"]
  Revenue_2021 = tbls_ls[tbls_ls$Year %in% c("2021","2021 (TTM)"), "Revenue"]
  Revenue_2020 = tbls_ls[tbls_ls$Year %in% c("2020","2020 (TTM)"), "Revenue"]
  Revenue_2019 = tbls_ls[tbls_ls$Year %in% c("2019","2019 (TTM)"), "Revenue"]
  Revenue_2018 = tbls_ls[tbls_ls$Year %in% "2018", "Revenue"]
  
  rev <- cbind (Revenue_2022[1,1],Revenue_2021[1,1],Revenue_2020[1,1],Revenue_2019[1,1],Revenue_2018[1,1])
 
  
  # Mcro Trend Text revenue 2022
  text <- gettxt(new_url)
  words <- unlist(str_split(text, "\n"))
  F2 <- grep("annual revenue for 2022| March 31, 2022|April 30, 2022 ",words)
  words[F2[1]]
  rev_2022 <- str_match(words[F2[1]], "2022\\s*(.*?)\\s*B")
  rev_2022 <- gsub("was","",rev_2022[1,2])
  
  
  new <- data.frame(Company = Sheet1$Company[x],Country = "India",Website = new_url,rev,latest =  rev_2022)
  new[4:8]<- paste(new[4:8],"B")
  data <- rbind(data,new)
  
  
  #x<- x+1
}
View(data)

sheet_append(drive_get("sample_data"),data)
x<-x+1
