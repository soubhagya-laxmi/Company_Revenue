library(rvest)
library(readr)
library(data.table)
library(stringr)
library(RCurl)

library(googledrive) 
library(googlesheets4) 

OldSheet <- read_sheet(drive_get("Company_List"))
View(OldSheet)


data <- data.frame()
for(x in x:5)
  
{
  url <- OldSheet$Website[x]
con <- url(url, "rb") 
webpage <- read_html(con)

link.titles <- webpage %>% html_nodes("img")%>%
  html_attr("src")
F1<- grep("logo",link.titles)
logo <- link.titles[F1[1]]
#logo <- paste(OldSheet$Website[x],"/",link.titles[F1[1]])
#logo <- str_replace_all(string=logo, pattern=" ", repl="") 

new.link <- webpage %>% html_nodes("img")%>%
  html_attr("data-src")
F2<- grep("logo",new.link)
new_logo <- new.link[F2[1]]

new <- data.frame(Num = x,Company = OldSheet$Company[x],Logo = logo)
new$Logo <- ifelse(is.na(new$Logo),new_logo,logo)

p<-new$Logo

new_link <- paste(OldSheet$Website[x],"/",new$Logo)
new_link <- str_replace_all(string=new_link, pattern=" ", repl="") 


new$Logo <- ifelse(is.na(str_match(new$Logo, "http")),new_link,p)

data <- rbind(data,new) 
#View(data)
}
x<-x+1
new <- data.frame(Company = OldSheet$Company[x],Logo = "NA")
data <- rbind(data,new) 
View(data)
sheet_append(drive_get("Logo_company"),data)



