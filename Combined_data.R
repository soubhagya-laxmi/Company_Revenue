
library(googledrive)
library(googlesheets4)

df2 <- read_sheet(drive_get("Company-website"))
df1 <- read_sheet(drive_get("Company_Logo"))

data <- merge(x = df1, y = df2, by = "Company", all.y = TRUE)

# arrange according to df2 dataframe list
#df[match(target, df$name),]
new <- data[match(df2$Company,data$Company ),]

df2$Company <- tolower(df2$Company)
df<- df1

  df$Rev_2022 <- ifelse(is.na(df$Rev_2022), df2$Rev_2022, df$Rev_2022)
  #df$Rev_2021 <- ifelse(is.na(df$Rev_2021), df2$Rev_2021, df$Rev_2021)
  #df$Rev_2020 <- ifelse(is.na(df$Rev_2020), df2$Rev_2020, df$Rev_2020)
  #df$Rev_2019 <- ifelse(is.na(df$Rev_2019), df2$Rev_2019, df$Rev_2019)
  #df$Rev_2018 <- ifelse(is.na(df$Rev_2018), df2$Rev_2018, df$Rev_2018)
  
  
  # Keeping first row having same rownames
  final <-df[!duplicated(df$Company), ]
  
  final$Website <- df2$Website[match(final$Company,df2$Company)]
  
  View(df)
  
  library(imputeTS)
  new <- na.replace(new, 0)
  
  library(data.table)
  new <- nafill(new, fill="NA")
  
  
  new <- replace(is.na(.), 0)
  
  sheet_append(drive_get("new-data",new))
  write.csv(new, "data.csv", na = "0")
  
  sheet_append(drive_get("Macrotrend_Data"),unique(data))
  
 