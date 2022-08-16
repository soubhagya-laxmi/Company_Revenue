
library(rvest)
library(readr)
library(data.table)
library(stringr)
library(RCurl)
library(googledrive) 
library(googlesheets4) 

OldSheet <- read_sheet(drive_get("Macrotrend_Data"))
View(OldSheet)

OldSheet$Company <-str_to_title(OldSheet$Company)

data <- data.frame()
for(x in 1:nrow(OldSheet))
{
  
  Search <-OldSheet$Company[x]
  Search <- str_replace_all(string=Search, pattern=" ", repl="+")
  
  url<- paste("https://commons.wikimedia.org/w/index.php?search=",Search,
              "+logo&title=Special:MediaSearch&go=Go&type=image")
  url <- str_replace_all(string=url, pattern=" ", repl="")
  
  con <- url(url, "rb") 
  webpage <- read_html(con)
  link.titles <- webpage %>% html_nodes("img")%>%
    html_attr("src")
  close(con)
  F1<- grep(words[1],link.titles)
  logo_url <- link.titles[F1[1]]
  logo = paste('=IMAGE("',logo_url,'")')
  logo <- str_replace_all(string=logo, pattern=" ", repl="")
  
  new <- data.frame(Company = OldSheet$Company[x],Logo = logo) 
  data <- rbind(data,new) 
  #View(data)
  #x<-x+1
}
View(data)

sheet_append(drive_get("Wikimedia_logo"),data)
