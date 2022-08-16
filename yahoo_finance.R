
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

Sheet1 <- read_sheet(drive_get("yahoo_Ticker"))

data <- data.frame()
for(x in x:200)
{  
  Search <- Sheet1$Ticker[x]
  new_url <- paste("https://finance.yahoo.com/quote/",Search,"/financials?p=",Search)
  new_url <- str_replace_all(string=new_url, pattern=" ", repl="")
  new_url <- gsub("  ", "", new_url)  
 
 
text <- gettxt(new_url)
words <- unlist(str_split(text, "\n\n"))

words <-gsub(",", "", words)  

currency = grep("SGD",words)

F1 <- grep("Breakdown",words)
words[F1[1]+2]
F2 <- grep("Total revenue|Total Revenue",words)

ttm <- words[F2[1]+1]
Rev_2022 <- ifelse(is.na(str_match(words[F1[1]+2],"2022")),words[F2[1]+2],ttm)
Rev_2021 <- ifelse(is.na(str_match(words[F1[1]+2],"2021")),words[F2[1]+3],words[F2[1]+2])
Rev_2020 <- ifelse(is.na(str_match(words[F1[1]+3], "2020")),words[F2[1]+4],words[F2[1]+3])
Rev_2019 <- ifelse(is.na(str_match(words[F1[1]+4], "2019")),words[F2[1]+5],words[F2[1]+4])
Rev_2018 <- ifelse(is.na(str_match(words[F1[1]+5], "2018")),"NA",words[F2[1]+5])


# Currency in SGD
if(is.na(currency) =="FALSE")
{
Rev_2022 <- round(as.numeric(Rev_2022)*.72)
Rev_2022 <- ifelse((nchar(Rev_2022)>5),paste(round(Rev_2022 *.000001,2),"M"),Rev_2022)
Rev_2021 <- round(as.numeric(Rev_2021)*.72)
Rev_2021<- ifelse((nchar(Rev_2021)>=5),paste(round(Rev_2021 *.000001,2),"M"),Rev_2021)
Rev_2020 <- round(as.numeric(Rev_2020)*.72)
Rev_2020 <- ifelse((nchar(Rev_2020)>=5),paste(round(Rev_2020 *.000001,2),"M"),Rev_2020)
Rev_2019 <- round(as.numeric(Rev_2019)*.72)
Rev_2019 <- ifelse((nchar(Rev_2019)>=5),paste(round(Rev_2019 *.000001,2),"M"),Rev_2019)
Rev_2018 <- round(as.numeric(Rev_2018)*.72)
Rev_2018 <- ifelse((nchar(Rev_2018)>=5),paste(round(Rev_2018 *.000001,2),"M"),Rev_2018)
}
# Currency in thousand 
# Converst Rs to US Dollar
else if(length(currency)=="0")
{
  # Currency in thousand so 1000/75 = 13.33
  # Converst Rs to US Dollar
  
  Rev_2022 <- round(as.numeric(Rev_2022)*13.33)
  Rev_2022 <- ifelse((nchar(Rev_2022)>5),paste(round(Rev_2022 *.000001,2),"M"),Rev_2022)
  Rev_2021 <- round(as.numeric(Rev_2021)*13.33)
  Rev_2021<- ifelse((nchar(Rev_2021)>=5),paste(round(Rev_2021 *.000001,2),"M"),Rev_2021)
  Rev_2020 <- round(as.numeric(Rev_2020)*13.33)
  Rev_2020 <- ifelse((nchar(Rev_2020)>=5),paste(round(Rev_2020 *.000001,2),"M"),Rev_2020)
  Rev_2019 <- round(as.numeric(Rev_2019)*13.33)
  Rev_2019 <- ifelse((nchar(Rev_2019)>=5),paste(round(Rev_2019 *.000001,2),"M"),Rev_2019)
  Rev_2018 <- round(as.numeric(Rev_2018)*13.33)
  Rev_2018 <- ifelse((nchar(Rev_2018)>=5),paste(round(Rev_2018 *.000001,2),"M"),Rev_2018)
  
}

new <- data.frame(Company = Sheet1$Company[x],Country = Sheet1$Country[x],
                  Website = new_url,
                  Rev_2022 = Rev_2022, Rev_2021 =Rev_2021,
                  Rev_2020 = Rev_2020,Rev_2019 = Rev_2019,Rev_2018 = Rev_2018)

new[4:8]<- paste("$",new[4:8])
data <- rbind(data,new)

}
View(data)
x<-x+1


sheet_append(drive_get("sample_data"),data)




new <- data.frame(Company = Sheet1$Company[x],Country = Sheet1$Country[x],
                  Website = " ",
                  Rev_2022 =  " ", Rev_2021 = " ",
                  Rev_2020 =  " ",Rev_2019 =  " ")
data <- rbind(data,new)
View(data)

x<-x+1


sheet_append(drive_get("Singapore_India"),data)
