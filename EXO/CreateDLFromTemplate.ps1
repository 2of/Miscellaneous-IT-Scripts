param (

    [string]$CsvPath = "",

    [bool]$ActuallyExecute = $false

)




try {

    $csvData = Import-Csv -Path $CsvPath

}

catch {

   Write-Host "Broke importing your CSV not found or similar"

}




foreach ($row in $csvData) {

    $dlname        = $row.DL_DisplayName

    $addy          = $row.DL_Address

    $emailList     = $row.DL_Members

    $ownersRaw     = $row.DL_Owners

 

    Write-Host "`nNow Processing: $dlname"

 

    if ($ActuallyExecute) {

        try {

            $primaryOwner = ($ownersRaw -split ';')[0].Trim()

            New-DistributionGroup -Name $dlname -PrimarySmtpAddress $addy -ManagedBy $primaryOwner -ErrorAction Stop

        } catch {

            Write-Host "Failed to create distribution group '$dlname'. Error: $_"

            continue

        }

    } else {

        Write-Host "Would create distribution group: Name='$dlname', Address='$addy', ManagedBy='(from owners list)'"

    }

 

    if ($ownersRaw) {

        $ownersList = $ownersRaw -split ';' | ForEach-Object { $_.Trim() }

 

        if ($ActuallyExecute) {

            try {

                Set-DistributionGroup -Identity $dlname -ManagedBy $ownersList -ErrorAction Stop

            } catch {

                Write-Host "Failed to set owners for '$dlname'. Error: $_"

            }

        } else {

            Write-Host "Would set owners for '$dlname': $($ownersList -join ', ')"

        }

    }

 

    # Add members

    if ($emailList) {

        $emailListArray = $emailList -split ';'

        foreach ($email in $emailListArray) {

            $trimmedEmail = $email.Trim()

            if ($trimmedEmail -match '^[\w\.-]+@[\w\.-]+\.\w{2,}$') {

                if ($ActuallyExecute) {

                    try {

                        Add-DistributionGroupMember -Identity $dlname -Member $trimmedEmail -ErrorAction Stop

                    } catch {

                        Write-Host "Failed to add '$trimmedEmail' to '$dlname'. Error: $_"

                    }

                } else {

                    Write-Host "Would add member '$trimmedEmail' to '$dlname'"

                }

            } else {

                Write-Host "Skipped invalid email format: '$trimmedEmail'"

            }

        }

    }

}

 