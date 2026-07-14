library(dplyr)
library(readxl)
library(tidyr)
X18_05 <- read_excel("data/18-05.xls", skip = 4)
X18_05 <- X18_05 %>% 
      dplyr::filter(!is.na(Region)) %>% 
       dplyr::filter(Region!= "Sichuan")
names(X18_05)[1] <- "市"
names(X18_05)[3:22] <- seq(2014, 2022, by =1)
#write.csv(X18_05, "data/sichuan_export.csv")


sichuan_export <- X18_05 %>% 
        dplyr::select("市", "Region", "2022")
sichuan <- st_read("data/sichuan.geojson")

sichuan <- left_join(sichuan, sichuan_export, by = c("name" = "市"))

sichuan <- sichuan %>% 
        dplyr::rename(export22 =  `2022`)

st_write(obj = sichuan, dsn = "data/sichuan2022.geojson")
