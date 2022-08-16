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

Sheet1 <- read_sheet(drive_get("sample_data"))

data <- data.frame()
for(x in x:874)
{
  Search <- Sheet1$Company[x]
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  Search_comp <- str_replace_all(string=Search_comp, pattern="&", repl="%26")
  url <- paste("https://www.google.com/search?q=",Search_comp,"+moneycontrol+revenue")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
  
  con <- url(Comp_url, "rb") 
  pg <- read_html(con)
  close(con)
  links <- html_attr(html_nodes(pg, "a"), "href")
  
  F2 <- grep("profit-lossVI",links)
  #F2 <- grep("https://www.moneycontrol.com/financials/",links)
  #F2 <- grep("https://companiesmarketcap.com/*(.*?)\\s*/revenue/&",links)
  links[F2[1]]
  
  
  new_url <-str_extract(string = links[F2[1]], pattern = "(?<=q).*(?=&)")
   new_url <- gsub("=","",new_url)
  
  con <- url(new_url, "rb") 
  webpage <- read_html(con)
  tbls <- html_nodes(webpage, "table")
  tbls_ls <- webpage %>%
    html_nodes("table") %>%
    .[[length(tbls)]] %>%
    html_table(fill = TRUE)
  close(con)
  
  Final <- data.frame(tbls_ls)
  
  colnames(Final) <-  Final[1,] 
  
  Final[is.na(Final)] <- 0
  gsub("`", "", colnames(Final))
  
  
  
  Rev_2022 <- as.numeric(gsub(",","",Final$`Mar 22`[9]))*10000000
  Rev_2021 <- as.numeric(gsub(",","",Final$`Mar 21`[9]))*10000000
  Rev_2020 <- as.numeric(gsub(",","",Final$`Mar 20`[9]))*10000000
  Rev_2019 <- as.numeric(gsub(",","",Final$`Mar 19`[9]))*10000000
  Rev_2018 <- as.numeric(gsub(",","",Final$`Mar 18`[9]))*10000000
  
  
  Rev_2022 <- round(as.numeric(Rev_2022)/75)
  Rev_2022 <- ifelse((nchar(Rev_2022)>5),paste(round(Rev_2022 *.000000001,2),"B"),Rev_2022)
  Rev_2021 <- round(as.numeric(Rev_2021)/75)
  Rev_2021<- ifelse((nchar(Rev_2021)>=5),paste(round(Rev_2021 *.000000001,2),"B"),Rev_2021)
  Rev_2020 <- round(as.numeric(Rev_2020)/75)
  Rev_2020 <- ifelse((nchar(Rev_2020)>=5),paste(round(Rev_2020 *.000000001,2),"B"),Rev_2020)
  Rev_2019 <- round(as.numeric(Rev_2019)/75)
  Rev_2019 <- ifelse((nchar(Rev_2019)>=5),paste(round(Rev_2019 *.000000001,2),"B"),Rev_2019)
  Rev_2018 <- round(as.numeric(Rev_2018)/75)
  Rev_2018 <- ifelse((nchar(Rev_2018)>=5),paste(round(Rev_2018 *.000000001,2),"B"),Rev_2018)
  
  
  Rev_2022 <- ifelse(length(Rev_2022),Rev_2022, "NA")
  Rev_2021 <- ifelse(length(Rev_2021),Rev_2021, "NA")
  Rev_2020 <- ifelse(length(Rev_2020),Rev_2020, "NA")
  Rev_2019 <- ifelse(length(Rev_2019),Rev_2019, "NA")
  Rev_2018 <- ifelse(length(Rev_2018),Rev_2018, "NA")
  
  new <- data.frame(Company = Sheet1$Company[x],Country = "India",Website = new_url,
                    Rev_22 = Rev_2022,
                    Rev_21 = Rev_2021,Rev_20 = Rev_2020,Rev_19 =Rev_2019,
                    Rev_18 = Rev_2018)
  new[4:8]<- paste("$",new[4:8])
  data <- rbind(data,new)
  
}
View(data)
 
sheet_append(drive_get("sample_data"),data) 



  
