library(googledrive) 
library(googlesheets4) 
OldSheet <- read_sheet(drive_get("Fortune 500 Data"))
View(OldSheet)

library(rvest)
library(readr)
library(data.table)
library(stringr)
library(RCurl)

OldSheet$Company <-str_to_lower(OldSheet$Company)
data <- data.frame()
for(x in 1:100)
{
  
  Search <-OldSheet$Company[x]
  Search <- str_replace_all(string=Search, pattern=" ", repl="+")
url<- paste("https://www.pngpix.com/search/",Search)
url <- str_replace_all(string=url, pattern=" ", repl="")

con <- url(url, "rb") 
webpage <- read_html(con)
  link.titles <- webpage %>% html_nodes("img")%>%
    html_attr("src")
  close(con)
  #Search_words <- str_replace_all(string="+", pattern=" ", repl=" ")
  
  #F1<- grep(Search_words[1],link.titles)
  logo_url <- link.titles[2]
  logo = paste('=IMAGE("',logo_url,'")')
  logo <- str_replace_all(string=logo, pattern=" ", repl="")
  
  new <- data.frame(Company = OldSheet$Company[x],Logo = logo) 
  data <- rbind(data,new) 
  #View(data)
  #x<-x+1
}
View(data)

sheet_append(drive_get("Macrotrend_Data"),data)
sheet_append(drive_get("Social_media_Links"),comp_logo)

 