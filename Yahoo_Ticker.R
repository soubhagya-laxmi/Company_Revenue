


url <- "https://en.wikipedia.org/wiki/List_of_companies_listed_on_the_National_Stock_Exchange_of_India"
webpage <- read_html(url)
tbls <- html_nodes(webpage, "table")
tbls_ls <- webpage %>%
  html_nodes("table") %>%
  .[[28]] %>%
  html_table(fill = TRUE)
View(tbls_ls)
sheet_append(drive_get("sample"),tbls_ls)

############################################################################

Sheet1 <- read_sheet(drive_get("sample"))

data <- data.frame()
for(x in 1001:1809)
{
  Search <- Sheet1$NSE[x]
  #Extract string after (:)
  Ind <- sub('.*:', '', Search)
  Ind <- sub('.', '',Ind)
  ticker <- paste(Ind,".NS")
  ticker <- str_replace_all(string=ticker, pattern=" ", repl="")
  new <- data.frame(Company = Sheet1$Company[x],Country = "🇮🇳 India",
                    Ticker = ticker)
  data <- rbind(data,new)
}
View(data)

sheet_append(drive_get("yahoo_Ticker"),data)
==============================================================================

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
  