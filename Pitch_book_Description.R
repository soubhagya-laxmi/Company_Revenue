

OldSheet <- read_sheet(drive_get("Company_List"))
View(OldSheet)
data <- data.frame()
 for(x in x:3000)
 {
  name <-OldSheet$Company[x]
    #Search <-OldSheet$Company[x]
       Search <- str_replace_all(string=name, pattern=" ", repl="+")
       
     url<- paste("https://www.google.com/search?q=",Search,"+pitchbook")
     url <- str_replace_all(string=url, pattern=" ", repl="")
        
    con <- url(url, "rb") 
      pg <- read_html(con)
      close(con)
      links <- html_attr(html_nodes(pg, "a"), "href")
   
  F2 <- grep("https://pitchbook.com/profiles/company/",links)
            links[F2[1]]
            new_url <- str_match(links[F2[1]], "http\\s*(.*?)\\s*&")
            new_url <- new_url[1][1]
            new_url <- gsub("&|%","",new_url)
             
              text <- gettxt(new_url)
              Search_words <- unlist(str_split(text,"\n"))
              #Description
              F1 <- grep("Description",Search_words)
              Description <- Search_words[F1[1]+2]
              #Primary Industry
              F2 <- grep("Primary Industry",Search_words)
              Industry <- Search_words[F2[1]+2]
              #Founded
              F3 <- grep("Founded",Search_words)
              Founded <- Search_words[F3[1]]
              
  new <- data.frame(Company = name,Description = Description,Industry=Industry,
                    Founded = Founded) 
    data <- rbind(data,new) 
}

View(data)
sheet_append(drive_get("pitchbook_descrip"),data)

