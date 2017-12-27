# crmlkp
The **CRM Data Lookup** helps you to ensure a better data quality in your CRM data. The goal of this project is to use Xing, LinkedIn and other available APIs to look for the company or some keywords to deliver you back some metadata like the address, number of employees and some more information.



# Getting started
Just follow the next steps to enrich your data.

## Prerequisites

* Microsoft R Open (>=3.4.1): Just install the Microsoft R Client following https://docs.microsoft.com/en-us/machine-learning-server/r-client/install-on-windows
* Windows 10 as this includes the needed Powershell calls that can handle JSON, Webservices and a lot more
* A csv file with the following columns: CRMKey,CRMCompanyName,Keywords like here

```csv
"CRMKey","CRMCompanyName","Keywords"
"C000124356","Company Name A","company name keywords"
"C000124357","Company Name A","company name keywords"
```



## Steps to Start

1. Make sure to fullfill the prerequisites 
2. Download the powershell script and put it where you want, but be sure you have the csv file in the same directory
2. Start the oauth process for the xing application and copy the code
3. 



