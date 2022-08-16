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

new_Sheet <- read_sheet(drive_get("Macrotrend_Data"))



data <- data.frame()
for(x in 1:nrow(new_Sheet)
{
  
  Search <- new_Sheet$Company[x]]
  
  url1 <- paste("https://www.google.com/search?q=",tolower(Search),"+twitter")
  Comp_url1 <- str_replace_all(string=url1, pattern=" ", repl="")
  con <- url(Comp_url1, "rb") 
  pg <- read_html(con)
  close(con)
  new_links <- html_attr(html_nodes(pg, "a"), "href")
  F2 <- grep("twitter.com",new_links)
  T_url <- str_match(new_links[F2[1]], "http\\s*(.*?)\\s*%")
  T_url <- gsub("%","",T_url[1][1])
  
  url2 <- paste("https://www.google.com/search?q=",tolower(Search),"+Facebook")
  Comp_url2 <- str_replace_all(string=url2, pattern=" ", repl="")
  con <- url(Comp_url2, "rb") 
  pg <- read_html(con)
  close(con)
  new_links <- html_attr(html_nodes(pg, "a"), "href")
  F2 <- grep("facebook.com",new_links)
  F_url <- str_match(new_links[F2[1]], "http\\s*(.*?)\\s*&")
  F_url <- gsub("/&","",F_url[1][1])
  
  url3 <- paste("https://www.google.com/search?q=",tolower(Search),"+linkedin")
  Comp_url3 <- str_replace_all(string=url3, pattern=" ", repl="")
  con <- url(Comp_url3, "rb") 
  pg <- read_html(con)
  close(con)
  new_links <- html_attr(html_nodes(pg, "a"), "href")
  F2 <- grep("linkedin.com",new_links)
  L_url <- str_match(new_links[F2[1]], "http\\s*(.*?)\\s*&")
  L_url <- gsub("&","",L_url[1][1])
  
  url4 <- paste("https://www.google.com/search?q=",tolower(Search),"+instagram")
  Comp_url4 <- str_replace_all(string=url4, pattern=" ", repl="")
  con <- url(Comp_url4, "rb") 
  pg <- read_html(con)
  close(con)
  new_links <- html_attr(html_nodes(pg, "a"), "href")
  F2 <- grep("instagram.com",new_links)
  I_url <- str_match(new_links[F2[1]], "http\\s*(.*?)\\s*&")
  I_url <- gsub("&","",I_url[1][1])
  
  url5 <- paste("https://www.google.com/search?q=",tolower(Search),"+youtube")
  Comp_url5 <- str_replace_all(string=url5, pattern=" ", repl="")
  con <- url(Comp_url5, "rb") 
  pg <- read_html(con)
  close(con)
  new_links <- html_attr(html_nodes(pg, "a"), "href")
  F2 <- grep("youtube.com",new_links)
  Y_url <- str_match(new_links[F2[1]], "http\\s*(.*?)\\s*&")
  Y_url <- gsub("&","",Y_url[1][1])
  
  
  new <- data.frame(Company = new_Sheet$Company[x], Twitter= T_url,Facebook = F_url,
                    linkedin = L_url,Instagram = L_url,Youtube = Y_url)
  
  data <- rbind(data,new) 

}
View(data)

sheet_append(drive_get("Social_media_Data"),data)

