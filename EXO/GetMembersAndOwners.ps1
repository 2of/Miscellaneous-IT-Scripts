
$boxes = ('john@johntown.com','another@asdf..... ')
'''Boxes is a list of strings of email addresses that we extract information from yuor exchange client from'''


$outputFile = Join-Path -Path $PSScriptRoot -ChildPath "DL_Info.csv"

$results = @()


foreach ($dl in $boxes) {
try {
    $owners = Get-DistributionGroup -Identity $dl | Select-Object -ExpandProperty ManagedBy
    $ownerEmails = ($owners | ForEach-Object { (Get-Recipient $_).PrimarySmtpAddress }) -join ";"

    $members = Get-DistributionGroupMember -Identity $dl
    $memberEmails = ($members | ForEach-Object { $_.PrimarySmtpAddress }) -join ";"

    $results += [PSCustomObject]@{
        DL      = $dl
        Owners  = $ownerEmails
        Members = $memberEmails
    }
}
catch {
    Write-Warning "Failed to get info for ${dl}: $_"
}

}


$results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8


