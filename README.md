# Miscellaneous IT Scripts
A collection of scripts for use in the IT world [Note these are stripped of anything identifying an org / identifying a business or individual, these are written by me and hosted here publically. Proceed with the expectation that you may break production and contextualize the code thoroughly before running... thanks :( ] 


### EXO > Distribution Lists

## Create Dist lists from big spooky excel sheets:

In a windows terminal with ps run:


1. Connect-ExchangeOnline -UserPrincipalName "yourusername@somewhere.com" (likely will pop up an MS login SSO window, use an exchange shell authorisued ms account, could be a script but aren't we all a bit lazy :) )

2. Import-Module ExchangeOnlineManagement 

3. ./GetMembersAndOwners.ps1
	a. Go in and set the $boxes variable to a list of strings of the intended mailboxes to RETRIEVE owners and Members from


4. For CreateDLFROMTemplate

	a. Use TEMPLATE.csv to fill the details, members are a single string separated by ';' chars and the csv is comma delimited

	b. run CreateDLFromTemplate with -CsvPath pointing at your adjusted template and also -ActiallyExecute set to $true (for the sake of not ruining a live environment not setting true will just spit things to console)



5. no warranty


