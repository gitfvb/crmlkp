# definition of variables -> CHANGE TO START!
$consumerKey = "<consumerKey>"
$token = "<token>"

# This shouldn't have to be defined -> RE-WORK!
$oauth_timestamp="<oauthTimeStamp>"
$oauth_nonce="<oauthNonce>"
$oauth_signature="<oauthSignature>"

# read the keywords file as a powershell object
# change the parameters e.g. if you have other encodings or other delimiter
$crmKeywords = import-csv -Delimiter "," -Encoding "UTF8" -path .\keywords.csv

# create initial objects
$companies = New-Object PSObject
$result = @()

# do a lookup for every companies keywords
$crmKeywords | ForEach {

  # do not reach the limits of the API too fast
  Start-Sleep -Seconds 3 

  # save the original crmKey and company name in separate variables
  $crmKey = $_.CRMKey
  $crmCompanyName = $_.CRMCompanyName

  # Espace the keywords otherwise e.g. double quotes could cause problems
  $keywords = [uri]::EscapeDataString($_.Keywords)

  [System.Uri]$uriNew = "https://api.xing.com:/v1/companies/find.json?keywords=$($keywords)&oauth_consumer_key=$($consumerKey)&oauth_token=$($token)&oauth_signature_method=PLAINTEXT&oauth_timestamp=$($oauthTimeStamp)&oauth_nonce=$($oauthNonce)&oauth_version=1.0&oauth_signature=$($oauthSignature)"
  
  # Write the created url to the powershell window
  Write-Host $uriNew

  # Call API to load a resultset for the given keywords
  $obj = Invoke-RestMethod -Uri $uriNew 
    
  # Enrich the list with the original crm key and companies name  
  $obj.companies.items | ForEach {
      $_ | Add-Member Noteproperty "CRMKey" $crmKey
      $_ | Add-Member Noteproperty "CRMCompanyName" $crmCompanyName
  }
  
  # Attach the new list to the global array
  $result += $obj

}

# Show result
Write-Host $result.companies | Select -expand items | Format-Table

# Export different files to use

$companies = $result.companies | Select -expand items

# writing company data to csv
$companies | Select CRMKey,CRMCompanyName,id,name,fax,phone,url,company_size,employee_count,permalink,foundation_year,follower_count | Export-Csv -Delimiter "`t" -Encoding "UTF8" -path companies_xing.csv -NoTypeInformation -Append

# writing the companies locations to csv
$companies | Select id -expand location | Export-Csv -Delimiter "`t" -Encoding "UTF8" -path companies_xing_locations.csv -NoTypeInformation -Append

# writing lat long to csv (not all addresses contain lat/long)
$companies | Select id -expand location | Select id,zip_code,city,country,street -expand geo_location | Select * | Export-Csv -Delimiter "`t" -Encoding "UTF8" -path companies_xing_locations_latlong.csv -NoTypeInformation -Append 
 
# writing industries to csv
$companies | Select @{Name="companyId";Expression={$_.id}} -expand industries | Select * | Export-Csv -Delimiter "`t" -Encoding "UTF8" -path companies_xing_industries.csv -NoTypeInformation -Append
 
# Group and Export DUNS + company name
$companies | Select CRMKey, CRMCompanyName | Group CRMKey | Select @{Name="CRMKey";Expression={$_.Name}}, @{Name="CRMCompanyName";Expression={$_.Group[0].CRMCompanyName}} | Export-Csv -Delimiter "`t" -Encoding "UTF8" -path companies_r_inputdata.csv -NoTypeInformation -Append
 
# Group and Export Xing companies as dictionary
$companies | Select id,name | Group id | Select @{Name="xingId";Expression={$_.Name}}, @{Name="Firma";Expression={$_.Group[0].name}} | Export-Csv -Delimiter ";" -Encoding "UTF8" -path companies_r_dictionary.csv -NoTypeInformation -Append




