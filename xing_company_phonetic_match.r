# install packages not present
if (!require("readr")) install.packages("readr")
require('readr')

# set the current working dir
setwd("<workingdir>")

inputCrm <- read_csv2(file = "companies_r_inputdata.csv",locale = locale(encoding = "UTF-8"),col_types="cc")
inputDic <- read_csv2(file = "companies_r_dictionary.csv",locale = locale(encoding = "UTF-8"),col_types="cc")

res <- rxGetFuzzyKeys(stringsIn = "CRMCompanyName",
     data = inputCrm, 
     dictionary = inputDic$Firma,
     ignoreCase = TRUE,
     matchMethod = "bag",  
     ignoreSpaces = FALSE,  
     minDistance = .7, 
     keyType = "mphone3",   
     hasMatchVarName = "hasMatch",
     matchDistVarName = "distMatch",
     keyVarName = "newFirma",
     numMatchVarName = "alternatives"
     ) 

# merge the XingId into the CRMKey
res2 <- merge(x = res[res$hasMatch == TRUE,], y = inputDic, by.x = "newFirma", by.y = "Firma", all.x = TRUE)
write.csv(res2,"result.csv")
