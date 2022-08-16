
Sheet1 <- read_sheet(drive_get("Company_List"))

data <- data.frame()
for(x in x:500)
{
  Search <- str_to_lower(Sheet1$Company[x])
  #Search_comp <- str_replace_all(string=Search, pattern="&", repl="-")
  Search_comp <- str_replace_all(string=Search, pattern=" ", repl="+")
  url <- paste("https://www.google.com/search?q=",Search_comp,"+wikipedia")
  Comp_url <- str_replace_all(string=url, pattern=" ", repl="")
 
   con <- url(Comp_url, "rb") 
  pg <- read_html(con)
  close(con)
  links <- html_attr(html_nodes(pg, "a"), "href")
  
  F2 <- grep("https://en.wikipedia.org/wiki/",links)
  links[F2[1]]
  new_url <- str_match(links[F2[1]], "https\\s*(.*?)\\s*&|https\\s*(.*?)\\s*%")
  new_url <- new_url[1][1]
  new_url <- gsub("&|%","",new_url)
  
  con <- url(new_url, "rb") 
  webpage <- read_html(con)
  tbls <- html_nodes(webpage, "table")
  tbls_ls <- webpage %>%
    html_nodes("table") %>%
    .[[1]] %>%
    html_table(fill = TRUE)
  close(con)
  
  colnames(tbls_ls) <- c("Name","Details")
  
  Type = tbls_ls[tbls_ls$Name %in% "Type", "Details"]
  #Industry = tbls_ls[tbls_ls$Name %in% "Industry", "Details"]
  Headquarters = tbls_ls[tbls_ls$Name %in% "Headquarters", "Details"]
  Founded = tbls_ls[tbls_ls$Name %in% "Founded", "Details"]
  Founder = tbls_ls[tbls_ls$Name %in% c("Founder","Founders"), "Details"]
  Owner = tbls_ls[tbls_ls$Name %in% c("Owner","Owners"), "Details"]
  Website = tbls_ls[tbls_ls$Name %in% "Website", "Details"]
  
  details <- cbind (Type[1,1],Founded[1,1],Founder[1,1],Owner[1,1],Website[1,1],	
                    Headquarters[1,1])
  
  new <- data.frame(Company = Sheet1$Company[x],details)

  data <- rbind(data,new)
  
}
View(data)

sheet_append(drive_get("Wikipedia Data"),data)


  
