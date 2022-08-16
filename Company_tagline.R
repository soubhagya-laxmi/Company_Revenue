library(rvest)
library(readr)
library(data.table)
library(stringr)
library(RCurl)
library(htm2txt)
library(googledrive) 
library(googlesheets4) 



OldSheet <- read_sheet(drive_get("Company_List"))
View(OldSheet)

data <- data.frame()
for(x in x:nrow(OldSheet))
{
Search <- str_to_lower(OldSheet$Company[x])
#Search_comp <- str_replace_all(string=Search, pattern="&", repl="-")
Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
url1 <- paste("https://www.google.com/search?q=",Search_comp,"+tagline")
url1 <- str_replace_all(string=url1, pattern=" ", repl="")

con1 <- url(url1, "rb") 
text1 <- gettxt(con1)
close(con1)
Search_words <- unlist(str_split(text1,"\n"))

url2 <- paste("https://www.google.com/search?q=",Search_comp,"+motto")
url2 <- str_replace_all(string=url2, pattern=" ", repl="")

con2 <- url(url2, "rb") 
text2 <- gettxt(con2)
close(con2)
Search_motto <- unlist(str_split(text2,"\n"))

    new <- data.frame(Company = OldSheet$Company[x],Tagline = Search_words[23],
                      motto = Search_motto[23])
    data <- rbind(data,new)
}
x<-x+1
View(data)

sheet_append(drive_get("Company Tagline"),data)

