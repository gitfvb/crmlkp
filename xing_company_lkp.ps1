# definition of variables -> CHANGE TO START!
$consumerKey = "<consumerKey>"
$token = "<token>"

# read the keywords file as a powershell object
# change the parameters e.g. if you have other encodings or other delimiter
$crmKeywords = import-csv -Delimiter "," -Encoding "UTF8" -path .\keywords.csv
